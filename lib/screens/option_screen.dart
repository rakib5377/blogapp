import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/welcome.json'),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  RoundButton(title: "Login", onPress: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                  }, borderSize: 5.0,),
                  SizedBox(height: 30,),
                  RoundButton(title: "Registration", onPress: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context)=> SignIn()));
                  }, borderSize: 5.0,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
