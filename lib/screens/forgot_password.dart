import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}
  FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool showSpinner = false;
class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter Email here",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder()
                          ),
                          validator: (value){
                            return value!.isEmpty ? 'Email required': null;
                          },
                        ),
                      )
                    ],
                  )

              ),
              RoundButton(title: "Recover Password", onPress: (){
                setState(() {
                  showSpinner = true;
                });
                if(_formkey.currentState!.validate()){
                  try{
                    _auth.sendPasswordResetEmail(email: emailController.text.toString().trim()).then(
                        (value){
                          toastMessage('Reset mail sent to your E-mail.');
                          setState(() {
                            showSpinner = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                        }
                    ).onError((error, stackTrace){
                      toastMessage(error.toString());
                    });
                    setState(() {
                      showSpinner = false;
                    });
                  }catch(e){
                    toastMessage(e.toString());
                  }
                }
              }, borderSize: 10)
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
