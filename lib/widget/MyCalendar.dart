import 'dart:ffi';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../db/DbHelper.dart';
import '../month_schedule/scheduleDTO.dart';


class Event {
  String title;

  Event(this.title);
}

class Mycalendar {
  Mybutton but =Mybutton();
  MyNotification mn = MyNotification();
  DBHelper dbHelper=DBHelper();


  MyCal(year, month, day, context, eventDaysStart, eventDaysEnd ) {

    return Column(
      children: [


        TableCalendar(
          focusedDay: DateTime.utc(year, month, day),
          firstDay: DateTime.utc(year, 01, 01),
          lastDay: DateTime.utc(year+10, 12, 31),
          availableGestures: AvailableGestures.none,
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDay, focusedDay) async{

            List<Scheduledto> sd=await dbHelper.getTodaySchedules(selectedDay);

            mn.showDetailDialog(context,selectedDay,sd);
          },
        headerVisible: false,
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          calendarStyle: const CalendarStyle(
            // marker 여러개 일 때 cell 영역을 벗어날지 여부
            canMarkersOverflow: false,
            // 자동정렬 여부
            markersAutoAligned: true,
            // marker 크기 조절
            markerSize: 10.0,
            // marker 크기 비율 조절
            markerSizeScale: 10.0,
            // marker 의 기준점 조정
            markersAnchor: 0.7,
            // marker margin 조절
            markerMargin: const EdgeInsets.symmetric(horizontal: 0.3),
            // marker 위치 조정
            markersAlignment: Alignment.bottomCenter,
            // 한줄에 보여지는 marker 갯수
            markersMaxCount: 2,

          ),


        eventLoader: (day){
            if(eventDaysStart!=null && eventDaysEnd!=null){
              int start=0;
              int end=0;
              for(int i=0;i<eventDaysStart.length; i++){
                int sy=eventDaysStart[i].year;
                int sm=eventDaysStart[i].month;
                int sd=eventDaysStart[i].day;
                if(day.year==sy&&day.month==sm&&day.day==sd) {
                  start++;
                }
                int ey=eventDaysEnd[i].year;
                int em=eventDaysEnd[i].month;
                int ed=eventDaysEnd[i].day;

                if(day.year==ey&&day.month==em&&day.day==ed) {
                  end++;
                }
              }

              return [start,end];
            }
            else{return [];}

        },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if(events.isNotEmpty){
                int sNum=int.parse(events[0].toString());
                int eNum=int.parse(events[1].toString());
                if (sNum>0 || eNum>0) {

                  List<Row> r=[Row(
                    children: [
                      sNum>0 ? Text("+"+sNum.toString(), style: TextStyle(fontSize: 10,color: Colors.blue),):Text(""),
                      eNum>0 ? Text("+"+eNum.toString(), style: TextStyle(fontSize: 10,color: Colors.red),):Text(""),
                    ],
                  )];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: r,
                  );
                }


                return const SizedBox();
              }

            },
          ),



      ),]
    );

  }


  MyPomodoroCal(DateTime todayDate, fun){
    return CalendarTimeline(
      initialDate: DateTime(todayDate.year, todayDate.month, todayDate.day),
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(3000, 12, 31),
      onDateSelected: fun,
      leftMargin: 20,
      monthColor: Colors.blueGrey,
      dayColor: Colors.teal[200],
      activeDayColor: Colors.white,
      activeBackgroundDayColor: Colors.redAccent[100],
      selectableDayPredicate: (date) =>
      date.year < todayDate.year+11 && date.year > todayDate.year-11,
      locale: 'en_ISO',
    );
  }


}
