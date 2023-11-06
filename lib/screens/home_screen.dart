import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/chat_room_model.dart';
import 'package:lets_chat/models/firebase_helper.dart';
import 'package:lets_chat/models/ui_helper.dart';
import 'package:lets_chat/models/user_model.dart';
import 'package:lets_chat/screens/chat_room_screen.dart';
import 'package:lets_chat/screens/login_screen.dart';
import 'package:lets_chat/screens/search_screen.dart';
import 'package:lets_chat/screens/settings_screen.dart';
import 'package:lets_chat/screens/update_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomeScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lets Chat"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("New group"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: Center(
                  child: Text("New broadcast"),
                ),
              ),
              PopupMenuItem(
                child: Center(
                  child: Text("Linked device"),
                ),
              ),
              PopupMenuItem(
                child: Center(
                  child: Text("Stared messages"),
                ),
              ),
              PopupMenuItem(
                child: Center(
                  child: Text("Payments"),
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext) => SettingsScreen(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                      ),
                    ),
                  );
                },
                child: const Center(
                  child: Text("Settings"),
                ),
              )
            ],
            offset: const Offset(0, 50),
            elevation: 5,
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatRooms")
              .where("users", arrayContains: widget.userModel.uId)
              .orderBy("createdOn")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);

                    Map<String, dynamic> participants =
                        chatRoomModel.participants!;

                    List<String> participantsKeys = participants.keys.toList();
                    participantsKeys.remove(widget.userModel.uId);
                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelById(participantsKeys[0]),
                      builder: (context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            UserModel targetUser = userData.data as UserModel;

                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext) => ChatRoomScreen(
                                        targetUser: targetUser,
                                        chatRoom: chatRoomModel,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    targetUser.profilePic.toString()),
                              ),
                              title: Text(targetUser.fullName.toString()),
                              subtitle: (chatRoomModel.lastMessage.toString() !=
                                      "")
                                  ? Text(chatRoomModel.lastMessage.toString())
                                  : Text(
                                      "Say hii to your new friend!",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: Text("No Chats"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext) => SearchScreen(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
            ),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
