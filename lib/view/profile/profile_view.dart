import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petking/view/profile/profile_page.dart';

// ignore: must_be_immutable
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController userFullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  File? pickedFile;

  void selectProfile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      pickedFile = File(result.files.single.path!);
      setState(() {});
    }
  }

  Future<String?> uploadPic() async {
    if (pickedFile == null) {
      return null;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final path = "profile_pic/${user.uid}.img.png";
    final file = File(pickedFile!.path);
    final actualFireStrorage = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = actualFireStrorage.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  void createProfile(String profilePicLink) async {
    String userFullName = userFullNameController.text.trim();
    String userName = userNameController.text.trim();

    if (userName == "" || userFullName == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All Information are required"),
        ),
      );
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "email": user.email,
        "full_name": userFullName,
        "username": userName,
        "profilepic": profilePicLink,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const Center(
            child: Text(
              "Create petking profile",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          InkWell(
            onTap: () {
              selectProfile();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 100,
                    maxWidth: 100,
                  ),
                  child: pickedFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            pickedFile!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 228, 162, 157),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const Center(
              child: Text(
            "Select profile pic",
            style: TextStyle(color: Colors.blue),
          )),
          const SizedBox(
            height: 30,
          ),
          const Text("full name"),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: TextField(
              controller: userFullNameController,
              decoration: const InputDecoration(
                hintText: " full name",
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 11, 12, 11)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("username"),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                hintText: "username",
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 11, 12, 11)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 228, 162, 157),
                minimumSize: const Size(400, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () async {
              log("Profile");
              final profilepic = await uploadPic();
              log("Profile uploadded");
              if (profilepic != null) {
                createProfile(profilepic);
                Get.off(() => const ProfileStorePage());
              }
            },
            child: const Text(
              'Create profile ',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          )
        ]),
      ),
    );
  }
}
