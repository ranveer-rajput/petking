import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String email = "";
  // String fullName = "";
  String profilePic = '';
  String username = '';
  Future fetchData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final res =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = res.data();
      // email = data!["email"] ?? "";
      // fullName = data["full_name"] ?? "";
      profilePic = data!["profilepic"] ?? "";
      username = data["username"] ?? "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = 0;
    return Scaffold(
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FutureBuilder(
          //   future: fetchData(),
          //   builder: (context, snapshot) {
          //     return Row(
          //       children: [
          //         Container(
          //           height: 40,
          //           width: 40,
          //           decoration: const BoxDecoration(
          //               shape: BoxShape.circle, color: Colors.amber),
          //           child: ClipOval(
          //               child: Image.network(
          //             profilePic,
          //             fit: BoxFit.cover,
          //           )),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         Text(" $username"),
          //       ],
          //     );
          //   },
          // ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 39, 39, 46), // Color of navigation bar
        buttonBackgroundColor: const Color.fromARGB(
            255, 62, 40, 30), // Color of the navigation bar button
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
