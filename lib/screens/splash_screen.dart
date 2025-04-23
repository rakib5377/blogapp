import 'dart:async';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = auth.currentUser;
    if(user !=  null){
      Timer(Duration(seconds: 3), 
              ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> HomeScreen()))
      );
    }
    else{
      Timer(Duration(seconds: 3),() => Navigator.push(context, MaterialPageRoute(builder: (_)=> OptionScreen())),);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Lottie.asset(
                'assets/splash_screen.json',
                fit: BoxFit.cover
              )
          ),
          Center(child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .74),
              child: Text('Blogs Here',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w600),)),)
        ],
      )
    );
  }
}
