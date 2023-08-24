import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileStorePage extends StatefulWidget {
  const ProfileStorePage({super.key});

  @override
  State<ProfileStorePage> createState() => _ProfileStorePageState();
}

class _ProfileStorePageState extends State<ProfileStorePage> {
  String profilePic = '';
  String? username;
  // String? postPic;
  Future fetchData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final res =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    final data = res.data();
    profilePic = data!["profilepic"] ?? "";
    username = data["username"] ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
          ),
          FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const CircularProgressIndicator(); // Show loading indicator if still fetching data
                } else if (snapshot.hasError) {
                  return const Text(
                      "Error loading profile data"); // Display an error message if there's an error
                } else {
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
                              profilePic,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Icon(Icons
                                    .error); // Display an error icon if the image loading fails
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          " $username",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
