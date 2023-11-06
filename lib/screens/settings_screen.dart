import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/user_model.dart';
import 'package:lets_chat/screens/update_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const SettingsScreen({super.key, this.userModel, this.firebaseUser});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext) => UpdateProfileScreen(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                      ),
                    ),
                  );
                },
                leading: Container(
                  height: 100,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          NetworkImage(widget.userModel!.profilePic.toString()),
                    ),
                  ),
                ),
                title: Text(
                  widget.userModel!.fullName.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  "Hey, I'm using Let's Chat",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: Colors.grey[300],
              height: 0.7,
              width: MediaQuery.of(context).size.width,
            ),
            ListTile(
              leading: Icon(Icons.key_outlined),
              title: Text("Account"),
              subtitle: Text(
                "Security notification, change number",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Privacy"),
              subtitle: Text(
                "Block contancts, disappearing messages",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Avatar"),
              subtitle: Text(
                "Create, edit, profile photo",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Chats"),
              subtitle: Text(
                "Theme, wallpapers, chat history",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              subtitle: Text(
                "Message, group & call tones",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text("Storage and data"),
              subtitle: Text(
                "Network usage, auto-download",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("App Language"),
              subtitle: Text(
                "English [device's language]",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Help"),
              subtitle: Text(
                "Help center, contact us, pravacy policy",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Invite a Friend"),
              subtitle: Text(
                "Security notification, change number",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                children: [
                  Text("From"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.language), Text("Lets Chat")],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
