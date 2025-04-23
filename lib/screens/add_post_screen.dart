import 'dart:io';

import 'package:blogapp/components/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  File? _image;
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String title='', description='';

  final picker = ImagePicker();
  Future getImageCamera() async{
    final pickedFile =await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      _image = File(pickedFile.path);
    }else{
      print("No image is picked");
    }
  }
  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      _image = File(pickedFile.path);
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
    return Scaffold(
      appBar: AppBar(title: Text("Add New Post")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                dialog(context);
              },
              child: Container(
                child:
                    _image != null
                        ? ClipRect(
                          child: Image.file(
                            _image!.absolute,
                            width: 100,
                            height: 100,
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
                RoundButton(title: "Upload Post", onPress: (){}, borderSize: 10)
              ],
            )
            )
          ],
        ),
      ),
    );
  }
}
