import 'package:blogapp/screens/add_post_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Posts").child("Post List");
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blogs"),centerTitle: true,
      leading: Text("${_auth.currentUser!.email}",overflow: TextOverflow.ellipsis,),
      automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPostScreen()));
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          )
        ],
      ),
      body: FirebaseAnimatedList(query: dbRef, itemBuilder: (context, snapshot, animation, index) {
        Map post = snapshot.value as Map;
        return Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                      imageUrl:  post['pImage'],
                    placeholder: (context, url)=> Center(child: CircularProgressIndicator(),),//Image.asset('assets/empty.jpg'),
                    errorWidget: (context,url, error) => Icon(Icons.error),
                    httpHeaders: {
                        "Accept" : "image/*",
                      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                          "AppleWebKit/537.36 (KHTML, like Gecko) "
                          "Chrome/91.0.4472.124 Safari/537.36",

                    },
                  ),

                ),
                Text(post['pTitle'],style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 15,),
                Text(post['pDescription'],style: TextStyle(color: Colors.grey, fontSize: 16,fontStyle: FontStyle.italic),),
                SizedBox(height: 15,),

              ],
            ),
          ),
        );
      },
      ),

    );
  }
}
