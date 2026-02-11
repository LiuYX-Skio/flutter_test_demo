import 'dart:convert';

import '../../../../navigation/utils/app_data_utils.dart';

class ChatMessageEntity {
  ChatMessageEntity({
    this.sendId,
    this.recvId,
    this.id,
    this.type,
    this.content,
    this.sendTime,
    this.status,
    this.viewType,
  });

  final String? sendId;
  final String? recvId;
  final String? id;
  final int? type;
  final String? content;
  final String? sendTime;
  final String? status;
  final int? viewType;

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      sendId: AppDataUtils.toStringValue(json['sendId']),
      recvId: AppDataUtils.toStringValue(json['recvId']),
      id: AppDataUtils.toStringValue(json['id']),
      type: AppDataUtils.toInt(json['type']),
      content: AppDataUtils.toStringValue(json['content']),
      sendTime: AppDataUtils.toStringValue(json['sendTime']),
      status: AppDataUtils.toStringValue(json['status']),
      viewType: AppDataUtils.toInt(json['viewType']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sendId': sendId,
      'recvId': recvId,
      'id': id,
      'type': type,
      'content': content,
      'sendTime': sendTime,
      'status': status,
      'viewType': viewType,
    };
  }

  ChatMessageEntity copyWith({
    String? sendId,
    String? recvId,
    String? id,
    int? type,
    String? content,
    String? sendTime,
    String? status,
    int? viewType,
  }) {
    return ChatMessageEntity(
      sendId: sendId ?? this.sendId,
      recvId: recvId ?? this.recvId,
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      sendTime: sendTime ?? this.sendTime,
      status: status ?? this.status,
      viewType: viewType ?? this.viewType,
    );
  }

  String? resolvedImageUrl() {
    if (type != 1 || (content ?? '').isEmpty) {
      return null;
    }
    try {
      final dynamic jsonValue = jsonDecode(content!);
      if (jsonValue is! Map<String, dynamic>) {
        return null;
      }
      final String? originUrl = AppDataUtils.toStringValue(jsonValue['originUrl']);
      if ((originUrl ?? '').isEmpty) {
        return null;
      }
      return _fixUrl(originUrl!);
    } catch (_) {
      return null;
    }
  }

  String _fixUrl(String originUrl) {
    const List<String> protocols = <String>['https://', 'http://'];
    for (final String protocol in protocols) {
      final int firstIndex = originUrl.indexOf(protocol);
      if (firstIndex == -1) {
        continue;
      }
      final int secondIndex =
          originUrl.indexOf(protocol, firstIndex + protocol.length);
      if (secondIndex != -1) {
        return '$protocol${originUrl.substring(secondIndex + protocol.length)}';
      }
      return originUrl;
    }
    return originUrl;
  }
}

class ChatUploadEntity {
  ChatUploadEntity({this.url});

  final String? url;

  factory ChatUploadEntity.fromJson(Map<String, dynamic> json) {
    return ChatUploadEntity(url: AppDataUtils.toStringValue(json['url']));
  }
}

class ChatSocketPushEvent {
  ChatSocketPushEvent({
    required this.cmd,
    required this.data,
  });

  final int cmd;
  final ChatMessageEntity data;

  factory ChatSocketPushEvent.fromJson(Map<String, dynamic> json) {
    return ChatSocketPushEvent(
      cmd: AppDataUtils.toInt(json['cmd']) ?? -1,
      data: ChatMessageEntity.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }
}

class ChatViewTypes {
  static const int leftText = 0;
  static const int leftImage = 1;
  static const int rightText = 2;
  static const int rightImage = 3;
}
