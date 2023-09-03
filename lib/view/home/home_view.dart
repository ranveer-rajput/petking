import 'package:flutter/material.dart';
import 'package:petking/view/home/hoepage.dart';
import 'package:petking/view/profile/add_post_caption.dart';
import 'package:petking/view/profile/profile_page.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
   Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentIndex = 0;
  var navBarItems = [
    const BottomNavigationBarItem(
      label: "Home",
      icon: Icon(
        Icons.home,
      ),
    ),
    const BottomNavigationBarItem(
      label: "Add post",
      icon: Icon(
        Icons.add,
      ),
    ),
    const BottomNavigationBarItem(
      label: "Profile",
      icon: Icon(
        Icons.person,
      ),
    ),
  ];
  var navBody = [
     HomePage(),
     AddPostAndCaption(),
     ProfileStorePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: navBody.elementAt(currentIndex)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
