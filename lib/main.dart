import 'package:druk_spil/components/outlined_button.dart';
import 'package:druk_spil/meyer/meyer.dart';
import 'package:flutter/services.dart';
import 'extensions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Druk Spil',
      theme: ThemeData(
        primaryColor: HexColor.fromHex("#202020"),
        accentColor: HexColor.fromHex("#ED217C"),
        backgroundColor: HexColor.fromHex("#0D0106"),
        scaffoldBackgroundColor: HexColor.fromHex("#202020"),
        dialogBackgroundColor: HexColor.fromHex("#202020"),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white), 
          button: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.grey), 
          subtitle1: TextStyle(color: Colors.white), 
        )
      ),
    home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("øl.", style: TextStyle(fontSize: 35)),
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 100),
              CustomOutlinedButton(text: "Meyer", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeyerPage())
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
