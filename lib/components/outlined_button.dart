import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;

  const CustomOutlinedButton({required this.text, required this.onPressed, Key? key}) : super(key: key);
  // const CustomOutlinedButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Theme.of(context).primaryColor,
          side: BorderSide(color: Theme.of(context).accentColor, width: 4),
        ),
        child: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}