import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserProfile> userprofileList = [];
  List<UserPost> userPostList = [];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    fetchPost();
  }

  Future<void> fetchProfileData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    final res = await FirebaseFirestore.instance.collection("users").get();
    for (var doc in res.docs) {
      var profilePic = doc["profilepic"] as String?;
      var userName = doc["username"] as String?;
      if (profilePic != null && userName != null) {
        userprofileList
            .add(UserProfile(profilepic: profilePic, username: userName));
      }
    }
    setState(() {});
  }

  Future<void> fetchPost() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    final res = await FirebaseFirestore.instance.collection("posts").get();
    for (var i in res.docs) {
      var caption = i['caption'];
      var postLink = i['post'];
      var uid = i['uid'];
      var createdatTimestam = i['created_at'] as Timestamp;
      var createdat = createdatTimestam.toDate().toString();
      userPostList.add(
        UserPost(
            postCaption: caption,
            postLink: postLink,
            createdat: createdat,
            uId: uid),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (userprofileList.isEmpty)
            const CircularProgressIndicator() // Show loading indicator
          else
            Expanded(
              child: ListView.builder(
                itemCount: userprofileList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipOval(
                          child: Image.network(
                            userprofileList[index].profilepic,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons
                                  .error); // Show error icon if image loading fails
                            },
                          ),
                        ),
                      ),
                      Text(userprofileList[index].username),
                    ],
                  );
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: userPostList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipOval(
                        child: Image.network(userPostList[index].postLink),
                      ),
                    ),
                    Text(userPostList[index].postCaption),
                    Text(userPostList[index].createdat),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class UserProfile {
  final String profilepic;
  final String username;
  UserProfile({required this.profilepic, required this.username});
}

class UserPost {
  final String postCaption;
  final String postLink;
  final String uId;
  final String createdat;
  UserPost(
      {required this.postCaption,
      required this.postLink,
      required this.createdat,
      required this.uId});
}
