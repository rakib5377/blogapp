import 'dart:io';
import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/services/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child('Posts');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title='', description='';


  File? _image;
  final picker = ImagePicker();
  Future getImageCamera() async{
    final pickedFile =await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);

      });
    }else{
      print("No image is picked");
    }
  }
  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }else{
      print("No image is picked");
    }
  }
  void dialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  getImageCamera();
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                ),
              ),
              InkWell(
                child: ListTile(
                  onTap: (){
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.photo),
                  title: Text("Gallery"),
                ),
              )
            ],
          ),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: Text("Add New Post")),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    dialog(context);

                  });
                },
                child: Container(
                  child:
                      _image != null
                          ? ClipRect(
                            child: Image.file(
                              _image!.absolute,
                              width: 300,
                              height: 150,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300,
                            ),
                            height: mediaQuery.height * .25,
                            width: mediaQuery.width * .96,
                        child: Icon(Icons.camera_alt_outlined,color: Colors.deepPurple,),
                          ),
                ),
              ),
              SizedBox(height: 20,),
              Form(
                  key: _formkey,
                  child: Column(
                children: [

                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter Post Title here',
                      border: OutlineInputBorder()
                    ),
                    onChanged: (String value){
                      title = value;
                    },
                    validator: (value){
                      return value!.isEmpty ? 'Title is required' : null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter Description Here',
                      border: OutlineInputBorder()
                    ),
                    onChanged: (String value){
                      description = value;
                    },
                    validator: (value){
                      return value!.isEmpty ? 'Description required' : null;
                    },
                  ),
                  SizedBox(height: 20,),
                  RoundButton(title: "Upload Post", onPress: () async {
                    // if (_image == null) {
                    //   toastMessage("Please select an image first.");
                    //   return;
                    // }

                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      int date = DateTime.now().microsecondsSinceEpoch;

                      // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('blogapp/$date.jpg');
                      // UploadTask uploadTask = ref.putFile(_image!.absolute);
                      // TaskSnapshot snapshot = await uploadTask;
                      // if (snapshot.state == TaskState.success) {
                      //   var newUrl = await snapshot.ref.getDownloadURL();


                        if (_image != null && _image!.existsSync()){
                          String? imageUrl = await uploadImage(_image!);

                          print('Image uploaded successfully: $imageUrl');
                        final User? user = _auth.currentUser;
                        postRef.child("Post List").child(date.toString()).set({
                          "pId": date.toString(),
                          "pImage": imageUrl ?? " ",
                          "pTime": date.toString(),
                          "pTitle": titleController.text.toString(),
                          "pDescription": descriptionController.text.toString(),
                          "pEmail": user!.email.toString(),
                          "pUid": user.uid.toString(),
                        }).then((value) {
                          setState(() {
                            showSpinner = false;
                          });
                          toastMessage("Post Published");
                        }).onError((onError, stackTrace) {
                          setState(() {
                            showSpinner = false;
                          });
                          toastMessage(onError.toString());
                        });
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        toastMessage("Upload failed.");
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      toastMessage(e.toString());
                    }
                  }
                      , borderSize: 10)
                ],
              )
              )
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
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
