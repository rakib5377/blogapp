import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final double borderSize;
  const RoundButton({super.key, required this.title, required this.onPress, required this.borderSize});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderSize),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
          height: 60,
          minWidth: double.infinity,
          color: Colors.deepPurple.shade300,
          child: Text(title,style: TextStyle(color: Colors.white),),
          onPressed: onPress),
    );
  }
}
