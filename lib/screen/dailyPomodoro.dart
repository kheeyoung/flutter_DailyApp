import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/db/dailyPomodoroDTO.dart';
import 'package:dailyapp/widget/MyCalendar.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:dailyapp/screen/pomodoroEdit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/time_controller.dart';
import '../db/scheduleDTO.dart';

class Dailypomodoro extends StatefulWidget {
  const Dailypomodoro({super.key});

  @override
  State<Dailypomodoro> createState() => _DailypomodoroState();
}

class _DailypomodoroState extends State<Dailypomodoro> {
  Mycalendar mc =Mycalendar();
  DBHelper dbHelper= DBHelper();
  MyNotification mn =MyNotification();
  TimeController timeController = TimeController();

  int year = DateTime.now().year;
  int month =DateTime.now().month;
  int day = DateTime.now().day;
  DateTime todayDate=DateTime.now();

  Widget pomodoroTable=Text("loading");

  String state="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("일간"),),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CalendarTimeline(
                initialDate: DateTime(todayDate.year, todayDate.month, todayDate.day),
                firstDate: DateTime(2000, 1, 1),
                lastDate: DateTime(3000, 12, 31),
                onDateSelected: (date) => setState(() {
                  year=date.year;
                  month=date.month;
                  day=date.day;
                  todayDate=date;
                }),
                leftMargin: 20,
                monthColor: Colors.blueGrey,
                dayColor: Colors.teal[200],
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.redAccent[100],
                selectableDayPredicate: (date) =>
                date.year < todayDate.year+11 && date.year > todayDate.year-11,
                locale: 'en_ISO',
              ),
              const SizedBox(width: 400,
                  child: Divider(color: Colors.black87, thickness: 1.0)),
              FutureBuilder(
                  future: Future.wait([
                    dbHelper.getTodaysStartSchedules(todayDate),
                    dbHelper.getTodaysEndSchedules(todayDate),
                    dbHelper.getToadysPomodoro("$year $month/$day"),
                  ]),
                  builder: (BuildContext context, AsyncSnapshot<List<List>> snapshot){
                    List<Widget> startWidget=[];
                    List<Widget> endWidget=[];


                    //월간 일정 보여주는 놈
                    List<Widget> topBar=[];

                    //월간 일정
                    if(snapshot.hasData && (snapshot.data![0].isNotEmpty || snapshot.data![1].isNotEmpty)){
                        //월간 스케줄 보이기
                        for(int i=0; i<snapshot.data![0].length; i++){
                          Scheduledto sd = snapshot.data![0][i];
                          startWidget.add(Text(sd.schedule_name));
                        }
                        for(int i=0; i<snapshot.data![1].length; i++){
                          Scheduledto sd = snapshot.data![1][i];
                          endWidget.add(Text(sd.schedule_name));
                        }
                        topBar.add(Text("시작 일정"));
                        topBar.add(Column(children: startWidget,));
                        topBar.add(Text("종료 일정"));
                        topBar.add(Column(children: endWidget,));
                      }
                      else{topBar.add(Text("오늘은 월간 일정이 없습니다."));}

                      //뽀모도로 스케줄 보이기
                      if(snapshot.hasData && snapshot.data![2].isNotEmpty){
                        //열
                        List<DataColumn> dataColumn = [
                          DataColumn(label: Text("일정명")),
                          DataColumn(label: Text("시작 시간")),
                          DataColumn(label: Text("종료 시간")),
                        ];
                        //행
                        List<DataRow> _getRows() {
                          List<DataRow> dataRow = [];
                          for (int i=0; i<snapshot.data![2].length; i++)  {
                            Dailypomodorodto dpd=snapshot.data![2][i];
                            List<DataCell> cells = [
                              DataCell(Text(dpd.DP_name, style: TextStyle(color: Colors.redAccent[100]),)),
                              DataCell(Text(dpd.DP_startTime, style: TextStyle(color: Colors.black87),)),
                              DataCell(Text(dpd.DP_endTime, style: TextStyle(color: Colors.black87),)),
                            ];

                            dataRow.add(
                                DataRow(
                                    onSelectChanged: (newValue) { //일정 수정
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Pomodoroedit(selectedDay: todayDate, dpd: dpd))).then((value){
                                        setState(() {
                                          state = value;
                                        });

                                      });
                                    },
                                    cells: cells
                                )
                            );
                          }
                          return dataRow;
                        }
                        pomodoroTable=DataTable(
                          showCheckboxColumn: false,
                          horizontalMargin: 10.0,
                          columnSpacing: 20.0,

                          columns: dataColumn,
                          rows: _getRows(),
                        );
                      }
                      else{
                        pomodoroTable=Text("일간 일정이 없습니다!");
                      }



                    return Column(
                      children: [
                        Column(children: topBar,),

                        Container(width: 400,
                            child: Divider(color: Colors.black87, thickness: 1.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$year $month/$day"),
                            const Text("   일정 추가"),
                            //일정 추가 버튼
                            IconButton(onPressed: () async{
                              Dailypomodorodto dpd=Dailypomodorodto(-1,
                                  "",
                                  "$year $month/$day",
                                  TimeOfDay.now().toString().substring(10,15),
                                  TimeOfDay.now().toString().substring(10,15),
                                  0,
                                  0,
                                  "",
                                  false);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>Pomodoroedit(selectedDay: todayDate, dpd: dpd))
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
                        const SizedBox(width: 400,
                            child: Divider(color: Colors.black87, thickness: 1.0)),
                        SingleChildScrollView(child: pomodoroTable),
                      ],
                    );
                  }
              ),



            ],
          ),
        ),
      ),
    );
  }


}
