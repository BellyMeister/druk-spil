import 'dart:math';
import 'package:druk_spil/components/outlined_button.dart';
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
          CustomOutlinedButton(text: "Stik mig nogle tal", onPressed: () {
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
          _mayerOutlinedButton(
            topText: "Gem tallene", 
            bottomText: "Du har slået det samme eller over det du har modtaget", 
            suffix: Text("🔒"),
            onPressed: (){
            setState(() {
              state = States.hidden;
            });
          }),
          _mayerOutlinedButton(
            topText: "Gem tallene og rul igen",
            bottomText: "Du kunne ikke slå højere end det du har fået", 
            suffix: Text("🔒🎲"),
            onPressed: (){
            rollDice();
            setState(() {
              state = States.hidden;
            });
          }),
          _mayerOutlinedButton(
            topText: "Rul igen",
            bottomText: "Der var nogen som drak, og nu starter en ny runde", 
            suffix: Text("🎲"),
            onPressed: (){
            setState(() {
              rollDice();
            });
          })
        ];
        break;
      case States.hidden:
        output = "??";
        buttons = [
          _mayerOutlinedButton(
            topText: "Vis tallene",
            bottomText: "Du tror ikke på ham", 
            suffix: Text("👀"),
            onPressed: (){
            setState(() {
              state = States.shown;
            });
          }),
          _mayerOutlinedButton(
            topText: "Rul igen og vis tallene", 
            bottomText: "Du tror på ham / du kan slå højere", 
            suffix: Text("🎲👀"),
            onPressed: (){
            rollDice();
            setState(() {
              state = States.shown;
            });
          })
        ];
        break;
      default:
        buttons = [
          CustomOutlinedButton(text: "Stik mig nogle tal", onPressed: () {
            rollDice();
            setState(() {
              output = "00";
              state = States.shown;
            });
          })
        ];
        break;
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

  void addPlayer(){
    if(controller.text != "") {
      setState(() {
        playersList.insert((0), Player(name: controller.text));
      });
      controller.clear();
      focusNode.requestFocus();
    }
  }
  Widget players(){
    
    List<Widget> widgets = playersList.map((e) => playerWidget(e)).toList();

    TextEditingController controller = TextEditingController();
    FocusNode _focusNode = FocusNode();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 1,
                style: TextStyle(color: Colors.white),
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)),
                  hintText: "Tryk for at tilføje spiller",
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  suffix: IconButton(
                    icon: Icon(Icons.add, color: Theme.of(context).accentColor),
                    onPressed: () => addPlayer(),
                  )
                ),
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => addPlayer(),
              ),
            ),
          ],
        ),
                      playersList.insert(0, Player(name: controller.text));
                    });
                    controller.clear();
                    _focusNode.requestFocus();
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
                      if(player.nLives == 0){
                        setState(() {
                          playersList.remove(player);
                          playersList.add(player);
                        });
                      } 
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

  Widget _mayerOutlinedButton({String topText = "", String bottomText = "", required GestureTapCallback onPressed, Widget? suffix}){
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
            subtitle: Text(bottomText, style: TextStyle(color: Colors.grey)),
            trailing: suffix,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
enum States{
  shown,
  hidden,
}

class Player {
  final String name;
  int nLives = 6;

  Player({required this.name});
}
