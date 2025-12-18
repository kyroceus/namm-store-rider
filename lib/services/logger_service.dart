import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _realLogger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // No call stack by default
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static final Logger _nopLogger = _NopLogger();

  static Logger get instance => kDebugMode ? _realLogger : _nopLogger;
}

class _NopLogger implements Logger {
  @override
  Future<void> close() async {
    // Does nothing
  }

  // --- ALL METHODS IMPLEMENTED WITH CORRECT NAMED PARAMETERS ---

  @override
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  @override
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  // ADDED: Missing 'f' (fatal) method
  @override
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  @override
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  // ADDED: Missing 'log' method
  @override
  void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  // ADDED: Missing 't' (trace) method
  @override
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  @override
  void v(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  @override
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  @override
  void wtf(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Does nothing
  }

  @override
  bool isClosed() => true;

  @override
  Future<void> get init => Future.value();
}
