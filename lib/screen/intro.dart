import 'package:dailyapp/dailyPomodoro/daily_pomodoro_view.dart';
import 'package:dailyapp/month_schedule/month_schedule_View.dart';

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
            IconButton
              (onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MonthScheduleView()));
                },
              icon: Icon(Icons.calendar_month), 
              iconSize: 50,
              tooltip: "월간 보기",
            ),
            Text("캘린더"),
            IconButton
              (onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DailypomodoroView()));
            },
              icon: Icon(Icons.access_alarm),
              iconSize: 50,
              tooltip: "월간 보기",
            ),
            Text("뽀모도로"),


          ],
        ),
      )
    );
  }
}
