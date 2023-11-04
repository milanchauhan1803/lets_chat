import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/user_model.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchScreen(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Stream? streamQuery;
  TextEditingController searchController = TextEditingController();

  String searchKey = searchController.text.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() async {
                    searchKey = value;
                    streamQuery = await FirebaseFirestore.instance
                        .collection("users")
                        .where("email_address", isGreaterThan: searchKey)
                        .where("email_address", isLessThan: searchKey + "z")
                        .snapshots();
                  });
                },
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  child: Text("Search"),
                  onPressed: () {}),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: (searchKey != "" && searchKey != null)
                      ? FirebaseFirestore.,
                  builder: builder)
            ],
          ),
        ),
      ),
    );
  }
}
