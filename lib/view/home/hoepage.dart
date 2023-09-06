import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Future<List<UserAllDetail>> fetchAllDetails() async {
    List<UserAllDetail> userAllDetails = [];
    if (FirebaseAuth.instance.currentUser == null) {
      return userAllDetails;
    }

    final res = await FirebaseFirestore.instance.collection("posts").get();
    for (var doc in res.docs) {
      UserAllDetail userAllDetail = UserAllDetail(
        profilepic: doc['profilepic'],
        username: doc['username'],
        postCaption: doc['caption'],
        postLink: doc['post'],
      );
      userAllDetails.add(userAllDetail);
    }
    return userAllDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Posts"),
      ),
      body: FutureBuilder<List<UserAllDetail>>(
        future: fetchAllDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available."));
          } else {
            List<UserAllDetail> userAllDetails = snapshot.data!;
            return ListView.builder(
              itemCount: userAllDetails.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userAllDetails[index].profilepic),
                        ),
                        title: Text(userAllDetails[index].username),
                      ),
                      Image.network(userAllDetails[index].postLink),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(userAllDetails[index].postCaption),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class UserAllDetail {
  final String profilepic;
  final String username;
  final String postCaption;
  final String postLink;

  UserAllDetail({
    required this.profilepic,
    required this.username,
    required this.postCaption,
    required this.postLink,
  });
}
