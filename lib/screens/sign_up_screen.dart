import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/models/user_model.dart';
import 'package:lets_chat/screens/complete_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Chat App",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email Address"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Confirm Password"),
                ),
                const SizedBox(
                  height: 10,
                ),
                CupertinoButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text("Sign Up"),
                    onPressed: () {
                      checkValues();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext) =>
                      //             const CompleteProfileScreen()));
                    }),
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
                child: Text(
                  "Log In",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = confirmPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      Fluttertoast.showToast(msg: "Please fill all fields!");
    } else if (password != cPassword) {
      Fluttertoast.showToast(msg: "Password don't match!");
    } else {
      signUp(email, password);
      // Fluttertoast.showToast(msg: "Sign Up successfully");
    }
  }

  void signUp(String email, String password) async {
    try {
      UserCredential? credential;

      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential != null) {
        String uId = credential.user!.uid;

        UserModel newUser =
            UserModel(uId: uId, email: email, fullName: "", profilePic: "");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uId)
            .set(newUser.toMap())
            .then(
              (value) => Fluttertoast.showToast(msg: "New user created!"),
            );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => CompleteProfileScreen(
                    userModel: newUser, firebaseUser: credential!.user!)));
      }
    } on FirebaseAuthException catch (e) {
      print("exception:- " + e.code.toString());
    }
  }
}
