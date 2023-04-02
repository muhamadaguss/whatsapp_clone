import 'package:whatsapp_cl/utils/message_enum.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeStamp;
  final String messageId;
  final bool isSeen;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeStamp,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type == MessageEnum.text
          ? 'text'
          : type == MessageEnum.image
              ? 'image'
              : type == MessageEnum.video
                  ? 'video'
                  : type == MessageEnum.audio
                      ? 'audio'
                      : type == MessageEnum.gif
                          ? 'gif'
                          : 'text',
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] == 'text'
          ? MessageEnum.text
          : map['type'] == 'image'
              ? MessageEnum.image
              : map['type'] == 'video'
                  ? MessageEnum.video
                  : map['type'] == 'audio'
                      ? MessageEnum.audio
                      : map['type'] == 'gif'
                          ? MessageEnum.gif
                          : MessageEnum.text,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    );
  }
}
