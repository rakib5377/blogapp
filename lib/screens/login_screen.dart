import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/forgot_password.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/main_screen.dart';
import 'package:blogapp/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '', password = '';
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: Text("Login"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (String value) {
                        email = value;
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Email required' : null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.none,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: "Enter Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      onChanged: (String value){
                        password = value;
                      },
                      validator: (value){
                        return value!.isEmpty ? 'Password required' : null;
                      },
                    ),
                    SizedBox(height: 20,),
                    RoundButton(title: "Login", onPress: ()async{
                      if(_formkey.currentState!.validate()){
                        setState(() {
                          showSpinner = true;
                        });
                        try{
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email.toString().trim(), password: password.toString().trim());
                          if(user != null){
                            setState(() {
                              showSpinner = false;
                            });
                            print("Success");
                            toastMessage("User Logged in Successfully");
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_)=>MainScreen()));
                          }
                        }catch(e){
                          setState(() {
                            showSpinner = false;
                          });
                          print(e.toString());
                          toastMessage(e.toString());
                        }
                      }
                    }, borderSize: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>ForgotPassword()));
                        }
                      ,child: Text("Forgot Password?",style: TextStyle(color: Colors.blue,fontSize: 16,),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>SignIn()));
                        }
                      ,child: Text("Register new account",style: TextStyle(color: Colors.blue,fontSize: 16,),)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}
