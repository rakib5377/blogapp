import 'package:blogapp/screens/add_post_screen.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blogs"),centerTitle: true,
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
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}
