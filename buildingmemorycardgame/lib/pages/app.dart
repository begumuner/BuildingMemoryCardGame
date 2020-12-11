import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

int level = 8;

class App extends StatefulWidget {
  final int size;
  const App({Key key, this.size = 8}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<GlobalKey<FlipCardState>> cardStateKey = [];
  List<bool> cardFlips = [];
  List<String> data = [];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      cardStateKey.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      data.add(i.toString());
    }
    for (var i = 0; i < widget.size ~/ 2; i++) {
      data.add(i.toString());
    }
    startTimer();
    data.shuffle();
  }

  //yukaridaki sure sayaci
  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //baslik
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  //sure sayacini yukari yazdirdik
                  "$time",
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              //kareler
              Theme(
                data: ThemeData.dark(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  //Çok Sutunlu kaydırılabilir listeler oluşturmak için kullanlır.GridView
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) => FlipCard(
                      key: cardStateKey[index],
                      onFlip: () {
                        if (!flip) {
                          flip = true;
                          previousIndex = index;
                        } else {
                          flip = false;
                          if (previousIndex != index) {
                            if (data[previousIndex] != data[index]) {
                              cardStateKey[previousIndex]
                                  .currentState
                                  .toggleCard();
                              previousIndex = index;
                            } else {
                              cardFlips[previousIndex] = false;
                              cardFlips[index] = false;
                              print(cardFlips);

                              if (cardFlips.every((t) => t == false)) {
                                print("matched");
                                showResult();
                              }
                            }
                          }
                        }
                      },
                      direction: FlipDirection.HORIZONTAL,
                      flipOnTouch: cardFlips[index],
                      front: Container(
                        margin: EdgeInsets.all(4.0),
                        color: Colors.deepOrange.withOpacity(0.3),
                      ),
                      back: Container(
                        margin: EdgeInsets.all(4.0),
                        color: Colors.deepOrange,
                        child: Center(
                          child: Text(
                            "${data[index]}",
                            style: Theme.of(context).textTheme.display2,
                          ),
                        ),
                      ),
                    ),
                    //kare sayisi
                    itemCount: data.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showResult() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("won"),
              content: Text(
                "Time $time",
                style: Theme.of(context).textTheme.display2,
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => App(
                          size: level,
                        )),
                      );

                      level *= 2;
                    },
                    child: Text("Next")),
              ],
            ));
  }
}
