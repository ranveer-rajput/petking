import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File? pickedFile;
  TextEditingController captionController = TextEditingController();
  void selectPost() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = File(result.files.single.path!);
      });
    }
  }

  Future<String?> sendFile() async {
    if (pickedFile == null) {
      return null;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final path = "file/${user.uid}.img.png";
    final file = File(pickedFile!.path);
    final sndtoFirestore = FirebaseStorage.instance.ref().child(path);

    UploadTask? uploadTask = sndtoFirestore.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  void createProfile(String postLink) async {
    String caption = captionController.text;
    captionController.clear();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance.collection("posts").doc(user.uid).set({
      "caption": caption,
      "post": postLink,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  selectPost();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.amber,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
            pickedFile != null
                ? Image.file(pickedFile!)
                : const Text("Add post"),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(hintText: "Add caption"),
            ),
            ElevatedButton(
              onPressed: () async {
                final postPic = await sendFile();
                if (postPic != null) {
                  createProfile(postPic);
                }
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
