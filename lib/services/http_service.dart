import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nammastore_rider/services/auth_service.dart';
import 'package:nammastore_rider/services/logger_service.dart';

class _CacheEntry {
  final String body;
  final DateTime expiry;

  _CacheEntry({required this.body, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

class HttpService {
  final String baseUrl;

  static HttpService? _instance;
  static bool _initialized = false;
  final GetStorage storage = GetStorage();
  final Map<String, _CacheEntry> _tempCache = {};

  static void init({required String baseUrl}) {
    if (_initialized) {
      throw Exception("HttpService.init() called more than once! Not allowed.");
    }

    _instance = HttpService._internal(baseUrl);
    _initialized = true;
  }

  static HttpService get instance {
    if (_instance == null) {
      throw Exception(
        "HttpService not initialized! Call HttpService.init(baseUrl: ...) once before use.",
      );
    }
    return _instance!;
  }

  HttpService._internal(this.baseUrl);

  Future<dynamic> request({
    required String path,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool auth = false,
    String? cacheKey,
    bool isPermanent = false,
    int? tempCacheTtlMins,
    int? permanentCacheTtlMins,
  }) async {
    if (cacheKey != null && !isPermanent) {
      if (_tempCache.containsKey(cacheKey)) {
        final cachedEntry = _tempCache[cacheKey]!;

        if (cachedEntry.isExpired) {
          AppLogger.instance.i(
            'Temp cache for $cacheKey is expired. Fetching new.',
          );
        } else {
          AppLogger.instance.i(
            'HTTP RESPONSE: 200 (Loaded from Temp Cache $cacheKey)',
          );
          return http.Response(
            cachedEntry.body,
            200,
            reasonPhrase: 'OK (Loaded from Temp Cache)',
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
      }
    }

    if (cacheKey != null && isPermanent) {
      final expiryTimeStr = storage.read<String>('${cacheKey}_expiry');
      final cachedBody = storage.read<String>(cacheKey);

      if (expiryTimeStr != null && cachedBody != null) {
        final expiryTime = DateTime.parse(expiryTimeStr);

        if (DateTime.now().isBefore(expiryTime)) {
          AppLogger.instance.i(
            'HTTP RESPONSE: 200 (Loaded from Permanent Cache $cacheKey - Valid for ${permanentCacheTtlMins}m)',
          );
          // Skip network entirely!
          return http.Response(
            cachedBody,
            200,
            reasonPhrase: 'OK (Loaded from Disk Cache)',
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        } else {
          AppLogger.instance.i(
            'Permanent cache for $cacheKey expired. Revalidating with Server.',
          );
        }
      }
    }

    final url = Uri.parse('$baseUrl$path');
    headers ??= {'Content-Type': 'application/json'};

    if (auth) {
      final authService = Get.find<AuthService>();
      final token = authService.authToken;
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        AppLogger.instance.w('No access token found for auth request');
        return;
      }
    }

    if (cacheKey != null && isPermanent) {
      final localEtag = storage.read<String>('${cacheKey}_etag');
      if (localEtag != null) {
        headers['If-None-Match'] = localEtag;
      }
    }

    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PATCH':
          response = await http.patch(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      _logRequest(method, url, body, headers);
      _logResponse(response);

      if (cacheKey != null && response.statusCode == 304) {
        AppLogger.instance.i(
          'HTTP RESPONSE 304: Loading from cache ($cacheKey)',
        );
        if (isPermanent) {
          await storage.write(
            '${cacheKey}_expiry',
            DateTime.now()
                .add(Duration(minutes: permanentCacheTtlMins ?? 0))
                .toIso8601String(),
          );
        }
        final cachedBody = storage.read<String>(cacheKey);

        if (cachedBody != null) {
          return cachedBody;
        } else {
          AppLogger.instance.w(
            'Cache 304 for $cacheKey, but no cached body found. Cache is corrupt.',
          );
        }
      }
      final responseBody = jsonDecode(response.body);
      final data = responseBody['data'];
      final message = responseBody['message'] as String;
      final isSuccess = responseBody['success'] as bool;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (cacheKey != null) {
          if (isPermanent) {
            final newEtag =
                response.headers['etag']; // etag header is lowercase

            if (newEtag != null) {
              AppLogger.instance.i(
                'Caching response for $cacheKey with ETag: $newEtag',
              );
              await storage.write(cacheKey, jsonEncode(data));
              await storage.write('${cacheKey}_etag', newEtag);
              await storage.write(
                '${cacheKey}_expiry',
                DateTime.now()
                    .add(Duration(minutes: permanentCacheTtlMins ?? 0))
                    .toIso8601String(),
              );
            } else {
              AppLogger.instance.w(
                'Wanted to cache $cacheKey, but no ETag header found in response.',
              );
            }
          } else {
            AppLogger.instance.i(
              'Caching response (Temp) for $cacheKey for $tempCacheTtlMins mins',
            );
            final expiryTime = DateTime.now().add(
              Duration(minutes: tempCacheTtlMins ?? 15),
            );
            _tempCache[cacheKey] = _CacheEntry(
              body: jsonEncode(data),
              expiry: expiryTime,
            );
          }
        }
        if (isSuccess) {
          return data;
        } else {
          throw Exception(message);
        }
      } else if (response.statusCode == 401) {
        // update later
        Get.offAllNamed('/login');
      } else {
        throw Exception(message);
      }
    } catch (e) {
      AppLogger.instance.e('HTTP ERROR: $e');
      rethrow;
    }
  }

  void clearCache(String key) {
    storage.remove(key);
    storage.remove('${key}_etag');
    storage.remove('${key}_expiry');
  }

  void _logRequest(
    String method,
    Uri url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  ) {
    AppLogger.instance.i('HTTP REQUEST $method $url');
    AppLogger.instance.i('Headers: ${jsonEncode(headers)}');
    if (body != null) AppLogger.instance.i('Body: ${jsonEncode(body)}');
  }

  void _logResponse(http.Response response) {
    AppLogger.instance.i('HTTP RESPONSE Status: ${response.statusCode}');
    AppLogger.instance.i('Body: ${response.body}');
  }
}
