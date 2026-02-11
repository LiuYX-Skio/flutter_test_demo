import '../../../../network/network.dart';
import '../models/chat_models.dart';

class ChatApi {
  static Future<List<ChatMessageEntity>?> messageHistory({
    required String friendId,
    required int page,
    int size = 60,
    bool showLoading = false,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<List<ChatMessageEntity>>(
      '/api/app/im/message/history',
      queryParameters: <String, dynamic>{
        'friendId': friendId,
        'page': page,
        'size': size,
      },
      showLoading: showLoading,
      fromJsonT: (dynamic json) {
        final List<dynamic> list = (json as List<dynamic>? ?? <dynamic>[]);
        return list
            .whereType<Map>()
            .map((dynamic item) => ChatMessageEntity.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList();
      },
      onError: onError,
    );
  }

  static Future<ChatMessageEntity?> sendMessage({
    required String content,
    required int type,
    required String recvId,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.post<ChatMessageEntity>(
      '/api/app/im/message/send',
      data: <String, dynamic>{
        'content': content,
        'recvId': recvId,
        'type': type.toString(),
      },
      showLoading: false,
      fromJsonT: (dynamic json) {
        return ChatMessageEntity.fromJson(
          Map<String, dynamic>.from(json as Map),
        );
      },
      onError: onError,
    );
  }

  static Future<String?> readMessage({
    required String friendId,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.get<String>(
      '/api/app/im/message/readed',
      queryParameters: <String, dynamic>{
        'friendId': friendId,
      },
      showLoading: false,
      onError: onError,
    );
  }

  static Future<ChatUploadEntity?> uploadImage({
    required String filePath,
    void Function(ApiException exception)? onError,
  }) {
    return HttpClient.instance.upload<ChatUploadEntity>(
      '/api/app/user/upload/image',
      filePath,
      data: <String, dynamic>{'model': 'user'},
      fromJsonT: (dynamic json) {
        return ChatUploadEntity.fromJson(
          Map<String, dynamic>.from(json as Map),
        );
      },
      onError: onError,
    );
  }
}
