import 'dart:math';
import 'package:druk_spil/components/outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeyerPage extends StatefulWidget {
  const MeyerPage({ Key? key }) : super(key: key);

  @override
  _MeyerPageState createState() => _MeyerPageState();
}

class _MeyerPageState extends State<MeyerPage> {
  Random rng = Random();
  int n1 = 0;
  int n2 = 0;
  String output = "00";
  String helperTextOutput = "";
  List<Widget> buttons = [];
  States? state;
  List<Player> playersList = [];
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    if(MediaQuery.of(context).viewInsets.bottom == 0) focusNode.unfocus();

    switch (state) {
      case States.shown:
        output = n2 > n1 ? "$n2$n1" : "$n1$n2";
        switch (output) {
          case "21":
            helperTextOutput = "\"Meyer\"";
            break;
          case "31":
            helperTextOutput = "\"Lille meyer\"";
            break;
          case "32":
            helperTextOutput = "\"Fælles skål\" \n(Starter en ny runde, ingen mister liv)";
            break;
          default:
            if (n1 == n2) {
              helperTextOutput = "\"Par $n1\"";
            } else {
              helperTextOutput = "";
            }
        }
        buttons = [
          _meyerOutlinedButton(
            topText: "Skjul tallene", 
            bottomText: "Du har slået det samme eller over det du har modtaget", 
            suffix: Text("🔒"),
            onPressed: (){
            setState(() {
              state = States.hidden;
            });
          }),
          _meyerOutlinedButton(
            topText: "Skjul tallene og rul igen",
            bottomText: "Du kunne ikke slå højere end det du har fået", 
            suffix: Text("🔒🎲"),
            onPressed: (){
            rollDice();
            setState(() {
              state = States.hidden;
            });
          }),
          _meyerOutlinedButton(
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
        helperTextOutput = "";
        buttons = [
          _meyerOutlinedButton(
            topText: "Vis tallene",
            bottomText: "Du tror ikke på ham", 
            suffix: Text("👀"),
            onPressed: (){
            setState(() {
              state = States.shown;
            });
          }),
          _meyerOutlinedButton(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                primary: Theme.of(context).accentColor,
                textStyle: TextStyle(fontSize: 20, color: Colors.white)
              ),
              child: Text("Stik mig nogle tal"), 
              onPressed: () async {
                if (playersList.length > 1 || await notEnoughPlayersWarning()) {
                  rollDice();
                  setState(() {
                    output = "00";
                    state = States.shown;
                  });
                }
              }
            ),
          )
        ];
        break;
    }
    
    // MAIN BUILD FUNCTION
    return WillPopScope(
      onWillPop: () => showExitPopup(),
      child: GestureDetector(
        onTap: () => focusNode.unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: AppBar(
                    title: Text("Meyer", style: TextStyle(fontSize: 35)),
                    centerTitle: true,
                    shadowColor: Colors.transparent,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: Column(
                              children: [
                                Text(output, style: TextStyle(fontSize: 35)),
                                Text(helperTextOutput, textAlign: TextAlign.center,)
                              ],
                            ),
                          )
                        ),
                        Column(children: buttons),
                        state == null || playersList.length > 0 ? playerListWidget() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  Future<bool> showExitPopup() async {
    if(playersList.length == 0 && state == null) return true;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Er du sikker?'),
        content: Text('Spillet vil blive nulstillet. Alle navne og liv skal tilføjes forfra.'),
        actions:[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Naj', style: TextStyle(color: Theme.of(context).accentColor)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ja', style: TextStyle(color: Theme.of(context).accentColor)),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> notEnoughPlayersWarning() async {
    return await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Ikke nok spillere"),
        content: Text("Sikker på du vil fortsætte til spillet?\nDu kan ikke tilføje flere spillere når spillet er i gang"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Naj', style: TextStyle(color: Theme.of(context).accentColor)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ja', style: TextStyle(color: Theme.of(context).accentColor)),
          ),
        ],
      )
    ) ?? false;
  }

  Widget _addPlayersWidget(List<Widget> playersWidget){
    return Padding(


      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
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
        Column(children: playersWidget)
      ]),
    );
  }

  Widget _healPlayersWidget(List<Widget> playersWidget){
    return Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: true,
          collapsedIconColor: Colors.grey,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text("Gamere", style: TextStyle(color: Colors.grey)),
              Container(width: 5),
              Expanded(child: Divider(color: Colors.grey, height: 10)),
            ],
          ),
          children: [
            Column(children: playersWidget),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text("Giv alle spillere fuldt liv", style: TextStyle(color: Theme.of(context).accentColor),), 
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).accentColor)
                ),
                onPressed: () {
                  setState(() {
                    playersList.forEach((p) {
                      p.nLives = 6;
                      p.hasRerolled = false;
                    });
                  });
                }, 
              ),
            ),
          ]
        ),
      ],
    );
  }

  Widget playerListWidget(){
    List<Widget> playersWidget = playersList.map((e) => individualPlayerWidget(e)).toList();
    
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: state == null ? _addPlayersWidget(playersWidget) : _healPlayersWidget(playersWidget)
    );
  }

  Widget individualPlayerWidget(Player player){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        state == null ? Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.close, color: Theme.of(context).accentColor),
            onPressed: () {
              setState(() {
                playersList.remove(player);
              });
            }
          ),
        )
        : Container(),
        Expanded(child: Text(player.name, overflow: TextOverflow.ellipsis)),
        state != null ? Row(
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
            GestureDetector(
              child: Icon(Icons.change_circle, color: !player.hasRerolled ? Theme.of(context).accentColor : Colors.grey),
                onTap: () {
                  if(!player.hasRerolled) {
                    setState(() {
                      player.nLives = rng.nextInt(6) + 1;
                      player.hasRerolled = true;
                    });
                  }
                },
                onLongPress: () {
                  setState(() {
                    player.hasRerolled = false;
                  });
                }, 
            ),
          ]
        ) : Container()
      ],
    );
  }

  Widget _meyerOutlinedButton({String topText = "", String bottomText = "", required GestureTapCallback onPressed, Widget? suffix}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          minimumSize: Size(double.infinity, 75),
          onPrimary: Theme.of(context).accentColor,
          side: BorderSide(color: Theme.of(context).accentColor),
          textStyle: TextStyle(fontSize: 20),
        ),
        child: SafeArea(
          child: ListTile(
            title: Text(topText, style: TextStyle(color: Theme.of(context).accentColor)),
            subtitle: Text(bottomText, style: TextStyle(color: Colors.white)),
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
  bool hasRerolled = false;

  Player({required this.name});
}
