class ChatContactModel {
  final String name;
  final String profilePic;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String contactId;

  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.contactId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'contactId': contactId,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime']),
      contactId: map['contactId'] ?? '',
    );
  }
}
