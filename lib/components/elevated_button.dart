import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;

  const CustomElevatedButton({required this.text, required this.onPressed, Key? key}) : super(key: key);
  // const CustomOutlinedButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          primary: Theme.of(context).accentColor,
        ),
        child: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}