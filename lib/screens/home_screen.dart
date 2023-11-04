import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/user_model.dart';
import 'package:lets_chat/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomeScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lets Chat"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) => SearchScreen(
                      userModel: userModel, firebaseUser: firebaseUser)));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
