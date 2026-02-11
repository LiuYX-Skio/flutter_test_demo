import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../../navigation/utils/app_data_utils.dart';
import '../models/chat_models.dart';

class ChatSocketClient {
  ChatSocketClient({required this.wsUrl});

  final String wsUrl;

  static const int loginCommand = 0;
  static const int heartbeatCommand = 1;
  static const int chatMessageCommand = 3;
  static const int textMessageType = 0;
  static const Duration heartbeatInterval = Duration(seconds: 10);
  static const Duration reconnectInterval = Duration(seconds: 5);

  final StreamController<ChatSocketPushEvent> _eventController =
      StreamController<ChatSocketPushEvent>.broadcast();

  WebSocket? _socket;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  String _token = '';
  bool _isDisposed = false;
  bool _isConnected = false;

  Stream<ChatSocketPushEvent> get events => _eventController.stream;

  bool get isConnected => _isConnected;

  Future<void> connect({required String token}) async {
    _token = token;
    if (_isDisposed) {
      return;
    }
    if (_isConnected || _socket != null) {
      return;
    }
    await _connectInternal();
  }

  Future<void> _connectInternal() async {
    try {
      _socket = await WebSocket.connect(wsUrl).timeout(
        const Duration(seconds: 12),
      );
      _isConnected = true;
      _socket?.listen(
        _onMessage,
        onDone: _onClosed,
        onError: (_) => _onClosed(),
        cancelOnError: true,
      );
      _startHeartbeat();
      _sendLogin();
    } catch (_) {
      _onClosed();
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      _sendJson(<String, dynamic>{'cmd': heartbeatCommand.toString()});
    });
  }

  void _sendLogin() {
    if (_token.isEmpty) {
      return;
    }
    _sendJson(<String, dynamic>{
      'cmd': loginCommand.toString(),
      'data': <String, dynamic>{'accessToken': _token},
    });
  }

  void _sendJson(Map<String, dynamic> json) {
    if (!_isConnected || _socket == null) {
      return;
    }
    _socket?.add(jsonEncode(json));
  }

  void _onMessage(dynamic rawMessage) {
    try {
      final dynamic decoded = jsonDecode(rawMessage.toString());
      if (decoded is! Map<String, dynamic>) {
        return;
      }
      final int command = AppDataUtils.toInt(decoded['cmd']) ?? -1;
      if (command != chatMessageCommand) {
        return;
      }
      final dynamic data = decoded['data'];
      if (data is! Map) {
        return;
      }
      final ChatMessageEntity message = ChatMessageEntity.fromJson(
        Map<String, dynamic>.from(data),
      );
      final int messageType = message.type ?? -1;
      if (messageType != textMessageType) {
        return;
      }
      _eventController.add(
        ChatSocketPushEvent(cmd: command, data: message),
      );
    } catch (_) {}
  }

  void _onClosed() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    try {
      _socket?.close();
    } catch (_) {}
    _socket = null;
    _isConnected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isDisposed) {
      return;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectInterval, () async {
      if (_isDisposed || _isConnected || _socket != null) {
        return;
      }
      await _connectInternal();
    });
  }

  Future<void> dispose() async {
    _isDisposed = true;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _heartbeatTimer = null;
    _reconnectTimer = null;
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
    _isConnected = false;
    await _eventController.close();
  }
}
