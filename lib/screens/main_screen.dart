import 'package:blogapp/screens/add_post_screen.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/utils/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List screens = [
    HomeScreen(),
    AddPostScreen(),
    Settings()
  ];
  int _currentIndex = 0;
  void changeIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(_currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        height: 45,
        color: Colors.grey,
        animationDuration: Duration(milliseconds: 250),
        items:
      [
        Icon(Icons.home),
        Icon(Icons.add_a_photo),
        Icon(Icons.settings),
      ],
        onTap: changeIndex,
        index: _currentIndex,
      ),
    );
  }
}
