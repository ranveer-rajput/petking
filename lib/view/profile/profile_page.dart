import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petking/auth/email/login_page.dart';

// ignore: must_be_immutable
class ProfileStorePage extends StatefulWidget {
  ProfileStorePage({Key? key}) : super(key: key);

  @override
  State<ProfileStorePage> createState() => _ProfileStorePageState();
}

class _ProfileStorePageState extends State<ProfileStorePage> {
  List<String?> postPic = [];
  List<String?> postCaption = [];

  Future<Map<String, dynamic>> fetchProfileData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return {};
    }
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final res =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final data = res.data();
    String profilePic = data?["profilepic"] ?? "";
    String userName = data?["username"] ?? "";
    return {
      "profilepic": profilePic,
      "username": userName,
    };
  }

  Future<List<String?>> fetchPostData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return [];
    }
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .get();
    postPic.clear();
    postCaption.clear();
    for (var doc in querySnapshot.docs) {
      var post = doc["post"];
      var caption = doc["caption"];
      postPic.add(post ?? "");
      postCaption.add(caption ?? "");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(LoginPage());
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          FutureBuilder(
            future: fetchProfileData(),
            builder: (context, snapshot) {
              String? profilePic;
              String? userName;

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text("Error loading profile data");
                } else {
                  profilePic = snapshot.data?["profilepic"];
                  userName = snapshot.data?["username"];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              profilePic ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          " $userName",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchPostData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: postPic.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            postPic[index]!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            postCaption[index] ?? "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Text("");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
