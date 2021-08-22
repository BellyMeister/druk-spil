import 'dart:math';
import 'package:flutter/material.dart';

class MayerPage extends StatefulWidget {
  const MayerPage({ Key? key }) : super(key: key);

  @override
  _MayerPageState createState() => _MayerPageState();
}

class _MayerPageState extends State<MayerPage> {
  Random rng = Random();
  int n1 = 0;
  int n2 = 0;
  String output = "00";
  List<Widget> buttons = [];
  States state = States.initial;
  List<Player> playersList = [];
  @override
  Widget build(BuildContext context) {
    switch (state) {
      case States.initial:
        buttons = [
          _mayerOutlinedButton(topText: "Stik mig nogle tal", onPressed: () {
            rollDice();
            setState(() {
              output = "00";
              state = States.shown;
            });
          })
        ];
        break;
      case States.shown:
        output = n2 > n1 ? "$n2$n1" : "$n1$n2";
        buttons = [
          _mayerOutlinedButton(topText: "Gem tallene", bottomText: "Du har slået det samme eller over det du har modtaget", onPressed: (){
            setState(() {
              state = States.hidden;
            });
          }),
          _mayerOutlinedButton(topText: "Gem tallene og rul igen",bottomText: "Du kunne ikke slå højere end det du har fået", onPressed: (){
            rollDice();
            setState(() {
              state = States.hidden;
            });
          }),
          _mayerOutlinedButton(topText: "Rul igen",bottomText: "Der var nogen som drak, og nu starter en ny runde", onPressed: (){
            setState(() {
              rollDice();
            });
          })
        ];
        break;
      case States.hidden:
        output = "??";
        buttons = [
          _mayerOutlinedButton(topText: "Vis tallene",bottomText: "Du tror ikke på ham", onPressed: (){
            setState(() {
              state = States.shown;
            });
          }),
          _mayerOutlinedButton(topText: "Rul igen og vis tallene", bottomText: "Du tror på ham / du kan slå højere", onPressed: (){
            rollDice();
            setState(() {
              state = States.shown;
            });
          })
        ];
        break;
      default:
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.all(15),
          child: Column(
            children: [
              Center(child: Text("Mayer", style: TextStyle(fontSize: 35))),
              SizedBox(height: 60),
              Center(child: 
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Text(output, style: TextStyle(fontSize: 35)),
                )
              ),
              Column(children: buttons),
              players()
            ],
          ),
        ),
      ),
    );
  }

  void rollDice(){
    n1 = rng.nextInt(6) + 1;
    n2 = rng.nextInt(6) + 1;
  }

  Widget players(){
    
    List<Widget> widgets = playersList.map((e) => playerWidget(e)).toList();

    TextEditingController controller = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 1,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Skriv spillerens navn",
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white
                ),
                controller: controller,
                onSubmitted: (_){
                  if(controller.text != ""){
                    setState(() {
                      playersList.add(Player(name: controller.text));
                    });
                  }
                },
              ),
            ),
          ],
        ),
        Column(children: widgets,)
      ],
    );
  }

  Widget playerWidget(Player player){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          children: [
            Text(player.name),
          ],
        ),
        Expanded(child: Container()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Theme.of(context).accentColor),
                  onPressed: () {
                    setState(() {
                      if(player.nLives > 0) player.nLives -= 1;
                    });
                  }, 
                ),
                Text("${player.nLives}"),
                IconButton(
                  icon: Icon(Icons.add, color: Theme.of(context).accentColor),
                  onPressed: () {
                    setState(() {
                      if(player.nLives < 6) player.nLives += 1;
                    });
                  }, 
                ),
              ]
            ),
          ],
        )
      ],
    );
  }

  Widget _mayerOutlinedButton({String topText = "", String bottomText = "", required GestureTapCallback onPressed}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          minimumSize: Size(double.infinity, 75),
          backgroundColor: Theme.of(context).primaryColor,
          side: BorderSide(color: Theme.of(context).accentColor, width: 4),
          textStyle: TextStyle(fontSize: 20),
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
enum States{
  initial,
  shown,
  hidden,
}

class Player {
  final String name;
  int nLives = 6;

  Player({required this.name});
}
