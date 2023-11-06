import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/models/ui_helper.dart';
import 'package:lets_chat/models/user_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const UpdateProfileScreen({super.key, this.userModel, this.firebaseUser});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool show = false;
  bool showUpdateName = false;
  File? imageFile;

  TextEditingController nameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      croppedImage(pickedFile);
    }
  }

  void croppedImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper.platform.cropImage(
      sourcePath: file.path,
      compressQuality: 20,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
        updateProfile();
      });
    }
  }

  void updateFullName() async {
    UIHelper.showLoadingDialog(context, "Updating your full name....");

    String? fullName = nameController.text.trim();
    widget.userModel!.fullName = fullName;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel!.uId)
        .set(widget.userModel!.toMap())
        .then((value) => Fluttertoast.showToast(msg: "Updated successfully!"));

    Navigator.pop(context);
  }

  void updateProfile() async {
    UIHelper.showLoadingDialog(context, "Updating profile...");

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePictures")
        .child(widget.userModel!.profilePic.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    widget.userModel!.profilePic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel!.uId)
        .set(widget.userModel!.toMap())
        .then((value) => Fluttertoast.showToast(msg: "Data updated!"));
    Navigator.pop(context);
  }

  Widget? showUpdateProfileBottomSheet() {
    if (show) {
      return BottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.secondary),
            height: MediaQuery.of(context).size.height / 4.5,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: 50,
                    height: 5,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile Photo",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                )),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  show = false;
                                  selectImage(ImageSource.camera);
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                )),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  show = false;
                                  selectImage(ImageSource.gallery);
                                },
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                )),
                            child: Center(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text(
                            "Avtar",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (showUpdateName) {
      return BottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.secondary),
            height: MediaQuery.of(context).size.height / 4.5,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    width: 50,
                    height: 5,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Enter your name",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: widget.userModel!.fullName,
                  ),
                ),
                SizedBox(
                  height: 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            updateFullName();
                            showUpdateName=false;
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(
                children: [
                  (imageFile != null)
                      ? Container(
                          height: 165,
                          width: 165,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(
                                imageFile!,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 165,
                          width: 165,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                widget.userModel!.profilePic.toString(),
                              ),
                            ),
                          ),
                        ),
                  Positioned(
                    top: 115,
                    left: 115,
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: Theme.of(context).colorScheme.secondary),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                show = true;
                              });
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    showUpdateName = true;
                    showUpdateProfileBottomSheet();
                  });
                },
                icon: const Icon(Icons.edit),
              ),
              leading: const Icon(Icons.person),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  Text(widget.userModel!.fullName.toString()),
                ],
              ),
              subtitle: Text(
                "This is not username or pin, This name will be visible to your Let's Chat contancts.",
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50),
              color: Colors.grey.shade500,
              height: 0.7,
              width: MediaQuery.of(context).size.width,
            ),
            ListTile(
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () {
                  setState(
                    () {},
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              leading: const Icon(Icons.info_outline),
              title: Text("About"),
              subtitle: const Text(
                "Hey, I'm using Let's Chat.",
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50),
              color: Colors.grey.shade500,
              height: 0.7,
              width: MediaQuery.of(context).size.width,
            ),
            ListTile(
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
              leading: const Icon(Icons.email),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  Text(widget.userModel!.email.toString()),
                ],
              ),
              subtitle: const Text(
                "",
              ),
            ),
          ],
        ),
      ),
      bottomSheet: showUpdateProfileBottomSheet(),
    );
  }
}
