import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:flutter/material.dart';


class SearchScheduleResultController{
  DBHelper db = DBHelper();

  Future<List<Scheduledto>> getSearchWord(String word)async{
    return await db.findSearchByWord(word);
  }


}