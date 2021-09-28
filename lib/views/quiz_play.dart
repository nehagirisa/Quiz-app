

import 'package:quiz/model/question_model.dart';
import 'package:quiz/services/database.dart';
import 'package:quiz/views/results.dart';
import 'package:quiz/widgets/quiz_play_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizPlay extends StatefulWidget {
  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;


class _QuizPlayState extends State<QuizPlay> {
   QuerySnapshot questionSnaphot;
  DatabaseService databaseService = new DatabaseService();
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;
  bool isLoading = true;

  @override
  void initState() {
    databaseService.getQuestionData().then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot.documents.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnaphot.documents.length;
      setState(() {});
      
    });

  
    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];

    List<String> options = [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
   
    questionModel.correctOption = questionSnapshot.data["option1"];
    questionModel.answered = false;

 

    return questionModel;
  }

  @override
  void dispose() {
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[100],
      appBar: VxAppBar(
        title: "Lets play Quiz!".text.make(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
          body: isLoading
          ? SingleChildScrollView(
            child: Container(
                child: Center(child: CircularProgressIndicator()),
              ),
          )
          : Column(
              children: [
               
                questionSnaphot.documents == null
                    ? Container(
                        child: Center(
                          child: Text("No Data"),
                        ),
                      )
                    : Container(
                        height: context.screenHeight * 0.60,
                        width: context.screenWidth * 0.95,
                        child: PageView.builder(
                            onPageChanged: (index) {
                              setState(() {
                                pageChanged = index;
                              });
                            },
                            controller: pageController,
                            itemCount: questionSnaphot.documents.length,

                           
                            itemBuilder: (context, index) {
                              return VxBox(
                                child: Column(
                                  children: [
                                    QuizPlayTile(
                                      questionModel:
                                          getQuestionModelFromDatasnapshot(
                                              questionSnaphot.documents[index]),
                                      index: index,
                                    ),
                                  ],
                                ),
                              )
                                  .height(context.screenHeight * 0.50)
                                  .width(context.screenWidth * 0.50)
                                  .make();
                            }),
                      ).centered(),
               
              

               
              ],
            ).scrollVertical(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        total: total,
                        notattempted: _notAttempted,
                      )));
        },
        icon: Icon(Icons.check),
        label: "Quiz Completed".text.make(),
        backgroundColor: Colors.amber,
      ),
    );
  }
}



class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({ this.questionModel,  this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VxBox(
            // margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Q${widget.index + 1}: ${widget.questionModel.question}",
              style:
                  TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ).centered(),
          ).make().capsule(
                width: context.screenWidth,
                height: 80,
                backgroundColor: Colors.white,
              ),
          20.heightBox,
          VxBox(
                  child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel.answered) {
                    ///correct
                    if (widget.questionModel.option1 ==
                        widget.questionModel.correctOption) {

                        final snackBar =
                        SnackBar(content: 'Right Answer!'.text.white.make(),
                          duration: const Duration(seconds: 5),
                          backgroundColor: Colors.lightGreen,
                          );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      setState(() {
                        optionSelected = widget.questionModel.option1;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted + 1;
                      });
                    } else {
                      final snackBar =
                      SnackBar(content: 'Oops! Wrong Answer'.text.white.make(),
                        duration: const Duration(seconds: 5),
                      backgroundColor: Colors.redAccent,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        optionSelected = widget.questionModel.option1;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                      });
                    }
                  }
                },
                child: OptionTile(
                  option: "A",
                  description: "${widget.questionModel.option1}",
                  correctAnswer: widget.questionModel.correctOption,
                  optionSelected: optionSelected,
                ),
              ),
              4.heightBox,
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel.answered) {
                   
                    if (widget.questionModel.option2 ==
                        widget.questionModel.correctOption) {
                      setState(() {
                        optionSelected = widget.questionModel.option2;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted + 1;
                      });
                    } else {
                      setState(() {
                        optionSelected = widget.questionModel.option2;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                      });
                    }
                  }
                },
                child: OptionTile(
                  option: "B",
                  description: "${widget.questionModel.option2}",
                  correctAnswer: widget.questionModel.correctOption,
                  optionSelected: optionSelected,
                ),
              ),
              4.heightBox,
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel.answered) {
                    ///correct
                    if (widget.questionModel.option3 ==
                        widget.questionModel.correctOption) {
                      setState(() {
                        optionSelected = widget.questionModel.option3;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted + 1;
                      });
                    } else {
                      setState(() {
                        optionSelected = widget.questionModel.option3;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                      });
                    }
                  }
                },
                child: OptionTile(
                  option: "C",
                  description: "${widget.questionModel.option3}",
                  correctAnswer: widget.questionModel.correctOption,
                  optionSelected: optionSelected,
                ),
              ),
              4.heightBox,
              GestureDetector(
                onTap: () {
                  if (!widget.questionModel.answered) {
                    ///correct
                    if (widget.questionModel.option4 ==
                        widget.questionModel.correctOption) {
                      setState(() {
                        optionSelected = widget.questionModel.option4;
                        widget.questionModel.answered = true;
                        _correct = _correct + 1;
                        _notAttempted = _notAttempted + 1;
                      });
                    } else {
                      setState(() {
                        optionSelected = widget.questionModel.option4;
                        widget.questionModel.answered = true;
                        _incorrect = _incorrect + 1;
                        _notAttempted = _notAttempted - 1;
                      });
                    }
                  }
                },
                child: OptionTile(
                  option: "D",
                  description: "${widget.questionModel.option4}",
                  correctAnswer: widget.questionModel.correctOption,
                  optionSelected: optionSelected,
                ),
              ),
              20.heightBox,
            ],
          ).scrollVertical().p8())
              .height(context.screenHeight * 0.40)
              .width(context.screenWidth)
              .make()
              .box
              .alignCenter
              .roundedLg
              .color(Colors.white)
              .height(context.screenHeight * 0.40)
              .width(context.screenWidth)
              .makeCentered(),
        ],
      ),
    ).p12();
  }
}
