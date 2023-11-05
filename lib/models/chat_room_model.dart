class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  List<dynamic>? users;
  DateTime? createOn;

  ChatRoomModel(
      {this.chatRoomId,
      this.participants,
      this.lastMessage,
      this.users,
      this.createOn});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["chatRoomId"];
    participants = map["participants"];
    lastMessage = map["last_message"];
    users = map["users"];
    createOn = map["createdOn"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomId": chatRoomId,
      "participants": participants,
      "last_message": lastMessage,
      "users": users,
      "createdOn": createOn
    };
  }
}
