import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/dialog/loading_manager.dart';
import '../../../../app/provider/user_provider.dart';
import '../../../../network/api_exception.dart';
import '../api/chat_api.dart';
import '../models/chat_models.dart';
import '../services/chat_socket_client.dart';

class ChatViewModel extends ChangeNotifier {
  static const String serviceUserId = '1000000001';
  static const String socketUrl = 'ws://appbysc.xinjiuyou.xyz/im';
  static const int firstPage = 1;
  static const int pageSize = 60;

  final ChatSocketClient _socketClient = ChatSocketClient(wsUrl: socketUrl);

  final List<ChatMessageEntity> _messages = <ChatMessageEntity>[];
  StreamSubscription<ChatSocketPushEvent>? _socketSubscription;

  int _page = firstPage;
  bool _isLoading = false;
  bool _isSending = false;
  bool _hasMore = true;
  bool _showAlbumPanel = false;
  String? _errorMessage;

  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get hasMore => _hasMore;
  bool get showAlbumPanel => _showAlbumPanel;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await _loadHistory(showLoading: true);
    _subscribeSocket();
    await _socketClient.connect(token: UserProvider.getUserToken());
  }

  void _subscribeSocket() {
    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.events.listen((ChatSocketPushEvent event) {
      final ChatMessageEntity mapped = _mapViewType(event.data);
      _messages.add(mapped);
      notifyListeners();
      _markAsRead();
    });
  }

  Future<void> refreshOlderMessages() async {
    if (!_hasMore || _isLoading) {
      return;
    }
    await _loadHistory(showLoading: false);
  }

  Future<void> _loadHistory({required bool showLoading}) async {
    _setLoading(showLoading);
    final List<ChatMessageEntity>? result = await ChatApi.messageHistory(
      friendId: serviceUserId,
      page: _page,
      size: pageSize,
      showLoading: showLoading && _page == firstPage,
      onError: _onApiError,
    );
    if (result == null) {
      _setLoading(false);
      return;
    }

    for (final ChatMessageEntity message in result) {
      _messages.insert(0, _mapViewType(message));
    }
    if (result.isNotEmpty) {
      _page += 1;
    } else {
      _hasMore = false;
    }
    _setLoading(false);
    _markAsRead();
  }

  Future<void> sendTextMessage(String text) async {
    final String content = text.trim();
    if (content.isEmpty) {
      LoadingManager.instance.showToast('请输入要发送的内容');
      return;
    }
    await _sendMessage(content: content, type: 0);
  }

  Future<void> sendImageMessage(File imageFile) async {
    final ChatUploadEntity? uploadResult = await ChatApi.uploadImage(
      filePath: imageFile.path,
      onError: _onApiError,
    );
    final String imageUrl = (uploadResult?.url ?? '').trim();
    if (imageUrl.isEmpty) {
      LoadingManager.instance.showToast(_errorMessage ?? '图片上传失败');
      return;
    }
    final String imagePayload = jsonEncode(<String, dynamic>{
      'thumbUrl': imageUrl,
      'originUrl': imageUrl,
    });
    await _sendMessage(content: imagePayload, type: 1);
  }

  Future<void> _sendMessage({
    required String content,
    required int type,
  }) async {
    if (_isSending) {
      return;
    }
    _isSending = true;
    notifyListeners();
    final ChatMessageEntity? result = await ChatApi.sendMessage(
      content: content,
      type: type,
      recvId: serviceUserId,
      onError: _onApiError,
    );
    _isSending = false;
    if (result == null) {
      notifyListeners();
      return;
    }
    _messages.add(_mapViewType(result));
    notifyListeners();
  }

  Future<void> markAsRead() async {
    await _markAsRead();
  }

  Future<void> _markAsRead() async {
    await ChatApi.readMessage(
      friendId: serviceUserId,
      onError: (_) {},
    );
  }

  ChatMessageEntity _mapViewType(ChatMessageEntity source) {
    final bool isServiceMessage = source.sendId == serviceUserId;
    int resolvedType = ChatViewTypes.rightText;
    if (isServiceMessage) {
      resolvedType = source.type == 1
          ? ChatViewTypes.leftImage
          : ChatViewTypes.leftText;
    } else {
      resolvedType = source.type == 1
          ? ChatViewTypes.rightImage
          : ChatViewTypes.rightText;
    }
    return source.copyWith(viewType: resolvedType);
  }

  void toggleAlbumPanel() {
    _showAlbumPanel = !_showAlbumPanel;
    notifyListeners();
  }

  void hideAlbumPanel() {
    if (!_showAlbumPanel) {
      return;
    }
    _showAlbumPanel = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _onApiError(ApiException exception) {
    _errorMessage = exception.message;
  }

  @override
  Future<void> dispose() async {
    await _socketSubscription?.cancel();
    await _socketClient.dispose();
    super.dispose();
  }
}
