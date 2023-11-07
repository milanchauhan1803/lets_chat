import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/main.dart';
import 'package:lets_chat/models/chat_room_model.dart';
import 'package:lets_chat/models/message_model.dart';
import 'package:lets_chat/models/user_model.dart';
import 'package:lets_chat/screens/targeted_user_profile_screen.dart';
import 'package:lets_chat/screens/update_profile_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomScreen(
      {super.key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String message = messageController.text.trim();
    messageController.clear();

    if (message != "") {
      //send message
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uId,
        createdOn: Timestamp.now(),
        text: message,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(widget.chatRoom.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = message;
      FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(widget.chatRoom.chatRoomId)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext) => TargetedUserProfileScreen(
                    targetedUser: widget.firebaseUser,
                    userModel: widget.targetUser),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    NetworkImage(widget.targetUser.profilePic.toString()),
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.targetUser.fullName.toString())
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatRooms")
                          .doc(widget.chatRoom.chatRoomId)
                          .collection("messages")
                          .orderBy("createdOn", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                                snapshot.data as QuerySnapshot;

                            return ListView.builder(
                              reverse: true,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                MessageModel currentMessage =
                                    MessageModel.fromMap(
                                        dataSnapshot.docs[index].data()
                                            as Map<String, dynamic>);
                                return Row(
                                  mainAxisAlignment: (currentMessage.sender ==
                                          widget.userModel.uId)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: (currentMessage.sender ==
                                                  widget.userModel.uId)
                                              ? Colors.grey
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                  "An error occured! Please check your internet connection."),
                            );
                          } else {
                            return Center(
                              child: Text("Say Hii, to your new friend!"),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                        maxLines: null,
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Enter Message",
                            border: InputBorder.none),
                      )),
                      IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(Icons.send),
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
