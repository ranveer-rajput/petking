import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petking/auth/email/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";
  String fullName = "";
  String profilePic = '';
  String username = '';
  Future fetchData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final res =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = res.data();
      email = data!["email"] ?? "";
      fullName = data["full_name"] ?? "";
      profilePic = data["profilepic"] ?? "";
      username = data["username"] ?? "";
      setState(() {});
    }
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
    Get.off(const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: $email"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Full Name: $fullName"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Profile Pic: $profilePic"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Username: $username"),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
