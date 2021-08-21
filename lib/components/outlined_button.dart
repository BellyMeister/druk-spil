import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;

  const CustomOutlinedButton({required this.text, required this.onPressed, Key? key}) : super(key: key);
  // const CustomOutlinedButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Theme.of(context).accentColor, width: 4)),
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20)),
        
      ),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}