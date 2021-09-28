


import 'package:confetti/confetti.dart';
import 'package:quiz/views/quiz_play.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;
  Results(
      { this.incorrect,
       this.total,
       this.correct,
       this.notattempted});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
   ConfettiController _controllerCenter;
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 4));
    super.initState();
  }

  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: VxAppBar(
        title: "Results".text.make(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (widget.correct) == (widget.total) ? buildButton() : VxBox(
            child: TextButton(
            onPressed: () {

      },
        child: "Well Done!You want to try again?".text.bold.xl2.red700.makeCentered(),
      ),
    ).height(80).width(context.screenWidth).make(),
              // ConfettiWidget(
              //   confettiController: _controllerCenter,
              //   blastDirectionality: BlastDirectionality.explosive,
              //   shouldLoop: false,
              //   blastDirection: -pi / 2,
              //   emissionFrequency: 0.01,
              //   numberOfParticles: 30,
              //   maxBlastForce: 100,
              //   minBlastForce: 80,
              //   //gravity: 0.3,

              //   colors: const [
              //     Colors.green,
              //     Colors.blue,
              //     Colors.pink,
              //     Colors.black,
              //     Colors.purple,
              //     Colors.red,
              //     Colors.white,
              //   ],
              // ),
              20.heightBox,
              Text(
                "Score : ${widget.correct}/ ${widget.total}",
                style: TextStyle(fontSize: 25),
              ),
              5.heightBox,
              "Correct - ${widget.correct}".text.lg.make().p4(),
              "Wrong - ${widget.incorrect}".text.lg.make().p4(),

           24.heightBox,
              GestureDetector(
                onTap: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizPlay()),
            );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Go to home",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align buildButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: VxBox(
        child: TextButton(
          onPressed: () {
            _controllerCenter.play();
          },
          child: "Congratulations!".text.bold.xl5.letterSpacing(0.2).makeCentered(),
        ),
      ).height(80).width(context.screenWidth*0.70).red500.make(),
    );
  }
}