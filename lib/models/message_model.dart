class MessageModel {
  String? sender;
  String? text;
  DateTime? createdOn;
  bool? seen;

  MessageModel({this.sender, this.text, this.createdOn, this.seen});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    createdOn = map["createdOn"];
    seen = map["seen"];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "createdOn": createdOn,
      "seen": seen
    };
  }
}
