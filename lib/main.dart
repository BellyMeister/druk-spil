import 'package:druk_spil/components/outlined_button.dart';
import 'package:druk_spil/mayer/mayer.dart';
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
        primaryColor: HexColor.fromHex("#0D0106"),
        accentColor: HexColor.fromHex("#ED217C"),
        backgroundColor: HexColor.fromHex("#0D0106"),
        scaffoldBackgroundColor: HexColor.fromHex("#0D0106"),
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white), button: TextStyle(color: Colors.white))
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Center(
                child: Text("øl.", style: TextStyle(fontSize: 35)),
              ),
              SizedBox(height: 100),
              CustomOutlinedButton(text: "Mayer", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MayerPage())
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
