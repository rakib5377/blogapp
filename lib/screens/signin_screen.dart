import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email='', password='';
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: Text("Create Account"),),
        body: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text("Register",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()
                        ),
                        onChanged: (String value){
                          email = value;
                        },
                        validator: (value){
                          return value!.isEmpty? 'Email required' : null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.none,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder()
                        ),
                        onChanged: (String value){
                          password = value;
                        },
                        validator: (value){
                          return value!.isEmpty? 'Password required' : null;
                        },
                      ),
                      SizedBox(height: 20,),
                      RoundButton(title: "Register", onPress: ()async{
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            showSpinner = true;
                          });
                          try{
                            final user = await _auth.createUserWithEmailAndPassword(
                                email: email.toString().trim(),
                                password: password.toString().trim());
                            if(user != null){
                              setState(() {
                                showSpinner = false;
                              });
                              print("Success");
                              toastMessage("User Successfully Created");
                            }
                          }catch(e){
                            print(e.toString());
                            toastMessage(e.toString());
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      }, borderSize: 10.0,)
                    ],
                  ),
                )
            )
          ],
        ),


      ),
    );
  }
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
}
