import 'package:flutter/material.dart';
import 'package:petking/view/home/hoepage.dart';
import 'package:petking/view/profile/create_profile.dart';
import 'package:petking/view/profile/profile_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
    const HomePage(),
    const CreateProfile(),
    const ProfileStorePage(),
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
