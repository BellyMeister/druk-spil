import 'package:flutter/material.dart';

class MayerPage extends StatefulWidget {
  const MayerPage({ Key? key }) : super(key: key);

  @override
  _MayerPageState createState() => _MayerPageState();
}

class _MayerPageState extends State<MayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

  Widget _mayerOutlinedButton({String topText = "", String bottomText = "", required GestureTapCallback onPressed}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 75)),
          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Theme.of(context).accentColor, width: 4)),
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20)),
          
        ),
        child: SafeArea(
          child: ListTile(
            title: Text(topText, style: TextStyle(color: Colors.white)),
            subtitle: Text(bottomText, style: TextStyle(color: Colors.grey))
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}