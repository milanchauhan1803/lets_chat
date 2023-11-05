import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  Timestamp? createdOn;
  bool? seen;

  MessageModel(
      {this.messageId, this.sender, this.text, this.createdOn, this.seen});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["message_id"];
    sender = map["sender"];
    text = map["text"];
    createdOn = map["createdOn"];
    seen = map["seen"];
  }

  Map<String, dynamic> toMap() {
    return {
      "message_id": messageId,
      "sender": sender,
      "text": text,
      "createdOn": createdOn,
      "seen": seen
    };
  }
}
