import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  late IO.Socket socket;

  void initSocket(String token) {
    // RECONNECTION & AUTH CONFIGURATION
    // Replace 'http://YOUR_LOCAL_IP:3000' with your actual server URL
    // For Android emulator use 'http://10.0.2.2:3000'
    // For iOS simulator use 'http://localhost:3000' or your machine's IP
    socket = IO.io(
      'http://192.168.1.35:8080/v1/delivery',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Web
          .disableAutoConnect() // We connect manually
          .setAuth({'token': token}) // AUTH: Send JWT here
          .setReconnectionAttempts(5) // Retry logic
          .build(),
    );
  }

  void connect() {
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void on(String event, Function(dynamic) handler) {
    socket.on(event, handler);
  }

  void off(String event) {
    socket.off(event);
  }

  void onConnect(Function(dynamic) handler) {
    socket.onConnect(handler);
  }

  void onDisconnect(Function(dynamic) handler) {
    socket.onDisconnect(handler);
  }

  void emitWithAck(String event, dynamic data, {Function(dynamic)? ack}) {
    socket.emitWithAck(event, data, ack: ack);
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
