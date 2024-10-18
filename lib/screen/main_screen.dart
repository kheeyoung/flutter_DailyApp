import 'package:dailyapp/controller/time_controller.dart';
import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/db/scheduleDTO.dart';

import 'package:dailyapp/widget/MyCalendar.dart';
import 'package:dailyapp/widget/showMiniSchedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/MyButton.dart';
import '../widget/MyCalendar.dart';

class main_screen extends StatefulWidget {
  const main_screen({super.key});

  @override
  State<main_screen> createState() => _mainState();
}

class _mainState extends State<main_screen> {
  DBHelper db = DBHelper();
  Mycalendar mc = Mycalendar();
  Showminischedule ss = Showminischedule();
  Mybutton but = Mybutton();

  TimeController timeController = TimeController();
  int year = 0;
  int month = 0;
  int day = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    year = timeController.getCurrentTime("Y");
    month = timeController.getCurrentTime("M");
    day = timeController.getCurrentTime("D");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("월간")),
        body: FutureBuilder(
            future: Future.wait([db.getMonthSchedule(year, month)]),
            builder: (BuildContext context, AsyncSnapshot<List<List<Scheduledto>>> snapshot) {
              String date="$year 년    $month 월";
              if (snapshot.hasData) {
                List<Scheduledto> marked;
                DateTime s=DateTime.now();
                DateTime e=DateTime.now();
                List<DateTime> eventDaysStart=[];
                List<DateTime> eventDaysEnd=[];

                if(snapshot.data!=null){
                  marked=snapshot.data![0];
                  DateFormat format = new DateFormat("yyyy M/d");

                  for(int i=0; i<marked.length; i++){
                    s=format.parse(marked[i].schedule_start);
                    eventDaysStart.add(s);
                  }
                  for(int i=0; i<marked.length; i++){
                    e=format.parse(marked[i].schedule_end);

                    eventDaysEnd.add(e);
                  }
                }


                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            but.myTextButton((){setState(() {
                              if(month>1){month--;}
                              else{month=12;}

                            });}, "<"),
                            Text(date,style: TextStyle(fontSize: 20)),
                            but.myTextButton((){
                              setState(() {
                                if(month<12){month++;}
                                else{month=1;}

                              });
                            }, ">"),
                          ]),
                      mc.MyCal(year, month, day, context,eventDaysStart,eventDaysEnd,CalendarFormat.month),
                      SizedBox(height: 20,),
                      Text(month.toString()+"월의 일정"),
                      SizedBox(height: 20,),

                      snapshot.data![0].isEmpty? Text("일정이 없습니다!"):ss.MyMiniSchedule(snapshot.data![0], month)
                    ],
                  ),
                );
              }
              else {

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            but.myTextButton((){setState(() {
                              if(month>1){month--;}
                              else{month=12;}

                            });}, "<"),
                            Text(date,style: TextStyle(fontSize: 20)),
                            but.myTextButton((){
                              setState(() {
                                if(month<12){month++;}
                                else{month=1;}

                              });
                            }, ">"),
                          ]),
                      mc.MyCal(year, month, day, context,null,null,CalendarFormat.month), //로딩중 화면 하나 만들어서 돌려막기 해야할듯
                      SizedBox(height: 20,),
                      Text(month.toString()+"월의 일정"),
                      SizedBox(height: 20,),

                      Text("일정이 없습니다!")
                    ],
                  ),
                );

              }
            },
        )
    );
  }
}
