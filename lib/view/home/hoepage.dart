import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserProfile> userprofileList = [];

  Future<void> fetchProfileData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final res = await FirebaseFirestore.instance.collection("users").get();
    for (var doc in res.docs) {
      var profilePic = doc["profilepic"];
      var userName = doc["username"];
      userprofileList
          .add(UserProfile(profilepic: profilePic, username: userName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: fetchProfileData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("loading");
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: userprofileList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: ClipOval(
                              child: Image.network(userprofileList[index]
                                  .profilepic!
                                  .toString()),
                            ),
                          ),
                          Text(userprofileList[index].username.toString()),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class UserProfile {
  final String? profilepic;
  final String? username;
  UserProfile({this.profilepic, this.username});
}
