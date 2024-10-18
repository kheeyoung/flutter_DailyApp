import 'package:dailyapp/screen/dailyPomodoro.dart';
import 'package:dailyapp/screen/main_screen.dart';
import 'package:dailyapp/screen/timeLine.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:flutter/material.dart';
class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  Mybutton mb=Mybutton();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MYDaily"),),
      body: Center(
        child: Column(
          children: [
            mb.myTextButton((){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>main_screen()));},
                "월간 보기"),

            mb.myTextButton((){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Dailypomodoro()));},
                "일간 보기"),

          ],
        ),
      )
    );
  }
}
