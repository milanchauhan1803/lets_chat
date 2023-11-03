import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {


  void showPhotoOptions(){
      showDialog(context: context, builder: (context){
        return AlertDialog(title: Text("Upload Profile picture"),);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Complete Profile")),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              const SizedBox(
                height: 25,
              ),
              CupertinoButton(
                onPressed: (){
                  showPhotoOptions();
                },
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      size: 60,
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Full Name"),
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text("Submit"),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
