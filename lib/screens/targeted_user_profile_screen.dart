import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/user_model.dart';

class TargetedUserProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  final User? targetedUser;

  const TargetedUserProfileScreen(
      {super.key, this.userModel, this.targetedUser});

  @override
  State<TargetedUserProfileScreen> createState() =>
      _TargetedUserProfileScreenState();
}

class _TargetedUserProfileScreenState extends State<TargetedUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: MediaQuery.of(context).size.height / 2.7,
        title: Center(
          child: Column(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      widget.userModel!.profilePic.toString(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.userModel!.fullName.toString(),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.userModel!.email.toString(),
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.phone),
                        ),
                        const Text(
                          "Audio",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.video_camera_back),
                        ),
                        const Text(
                          "Video",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.currency_rupee),
                        ),
                        const Text(
                          "Pay",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                        const Text(
                          "Search",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Share",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem(
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem(
                child: Text(
                  "View in address book",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem(
                child: Text(
                  "Verify security code",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            offset: Offset(0,50),

          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
