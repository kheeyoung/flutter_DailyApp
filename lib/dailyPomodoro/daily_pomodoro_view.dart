import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dailyapp/dailyPomodoro/daily_pomodoro_controller.dart';
import 'package:dailyapp/dailyPomodoro/pomodoroEdit.dart';
import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/dailyPomodoro/daily_pomodoroDTO.dart';
import 'package:dailyapp/month_schedule/month_schedule_View.dart';
import 'package:dailyapp/widget/MyCalendar.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/time_controller.dart';
import '../month_schedule/scheduleDTO.dart';
import '../screen/intro.dart';

class DailypomodoroView extends StatefulWidget {
  const DailypomodoroView({super.key});

  @override
  State<DailypomodoroView> createState() => _DailypomodoroViewState();
}

class _DailypomodoroViewState extends State<DailypomodoroView> {
  Mycalendar mc =Mycalendar();
  DBHelper dbHelper= DBHelper();
  MyNotification mn =MyNotification();
  TimeController timeController = TimeController();
  DailyPomodoroController dpc =DailyPomodoroController();

  DateTime selectedDate=DateTime.now();

  Widget pomodoroTable=Text("loading");

  String state="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("일간"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: Icon(Icons.backspace)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MonthScheduleView()));
              },
              icon: Icon(Icons.calendar_month))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //상단 달력
              mc.MyPomodoroCal(selectedDate,
                      (date) => setState(() {
                        selectedDate=date;
                  })
              ),

              const SizedBox(width: 400,
                  child: Divider(color: Colors.black87, thickness: 1.0)),

              //월간 일정
              FutureBuilder(
                  future: dpc.getTodaySchedule(selectedDate),
                  builder: (BuildContext context, AsyncSnapshot<List<Scheduledto>> snapshot){

                    //월간 일정 보여주는 놈
                    List<Widget> topBar=[];

                    //월간 일정
                    if(snapshot.hasData){
                      topBar=dpc.showMonthSchedule(snapshot.data!);
                    }
                    else{topBar.add(Text("오늘은 월간 일정이 없습니다."));}

                    return Column(
                      children: topBar,
                    );
                  }
              ),
              const SizedBox(width: 400,
                  child: Divider(color: Colors.black87, thickness: 1.0)),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("${selectedDate.year} ${selectedDate.month}/${selectedDate.day}"),
                  const Text("   일정 추가"),
                  //일정 추가 버튼
                  IconButton(onPressed: () async{
                    Dailypomodorodto dpd=Dailypomodorodto(-1,
                        "",
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        TimeOfDay.now().toString().substring(10,15),
                        TimeOfDay.now().toString().substring(10,15),
                        0,
                        0,
                        "",
                        false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>Pomodoroedit(dpd: dpd))
                    ).then((value){
                      setState(() {
                        state = value;
                      });

                    });
                    //var data=await mn.addPomodoroSchedule(context, todayDate);
                    setState(() {});
                  }, icon: Icon(Icons.add))
                ],
              ),
              //뽀모도로
              FutureBuilder(
                  future: dpc.getTodayPomodoroSchedule(selectedDate),
                  builder: (BuildContext context, AsyncSnapshot<List<Dailypomodorodto>> snapshot){

                    //월간 일정
                    if(snapshot.hasData){
                      pomodoroTable=dpc.showPomodoro(snapshot.data!, context,
                          (){
                            setState(() {

                            });
                          }

                      );
                    }
                    return pomodoroTable;
                  }
              ),


            ],
          ),
        ),
      ),
    );
  }


}
