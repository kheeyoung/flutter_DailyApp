
import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:dailyapp/widget/showMiniSchedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class MonthScheduleController{
  DBHelper db = DBHelper();
  Showminischedule ss = Showminischedule();

  Future<List<List<DateTime>>> getMarkedSchedule(DateTime date) async{

    DateTime s=DateTime.now();
    DateTime e=DateTime.now();
    List<DateTime> eventDaysStart=[];
    List<DateTime> eventDaysEnd=[];

    List<Scheduledto> schedule= await db.getMonthSchedules(date);
    for(int i=0; i<schedule.length; i++){

      s=DateTime(schedule[i].schedule_start_year,
          schedule[i].schedule_start_month,
          schedule[i].schedule_start_day);
      eventDaysStart.add(s);
      e=DateTime(schedule[i].schedule_end_year,
          schedule[i].schedule_end_month,
          schedule[i].schedule_end_day);
      eventDaysEnd.add(e);
    }

    return [eventDaysStart, eventDaysEnd];
  }

  Future<Widget> getMiniSchedule(DateTime date) async{
    List<Scheduledto> schedule= await db.getMonthStartSchedules(date);
    return ss.MyMiniSchedule(schedule, date.month);
  }

  Future<String> getMemo(DateTime date) async{
    return db.getMemo(date);
  }

  DateTime plusMonth(DateTime date){
    if(date.month<12){
      date= DateTime(date.year, date.month+1, 1);
    }
    else{
      date= DateTime(date.year+1, 1, 1);
    }
    return date;
  }

  DateTime subMonth(DateTime date){
    if(date.month==1){
      date= DateTime(date.year-1, 12, 1);
    }
    else{
      date= DateTime(date.year, date.month-1, 1);
    }
    return date;
  }

  updateMemo(String memo, DateTime date)async {
    await db.updateMemo(memo, date);

  }



}