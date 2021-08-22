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