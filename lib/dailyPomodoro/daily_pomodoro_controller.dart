import 'package:dailyapp/dailyPomodoro/daily_pomodoroDTO.dart';
import 'package:dailyapp/dailyPomodoro/pomodoroEdit.dart';
import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:flutter/material.dart';

class DailyPomodoroController{
  DBHelper db = DBHelper();
  Future <List<Scheduledto>> getTodaySchedule(DateTime todayDate) {
    return db.getTodaySchedules(todayDate);
  }

  Future <List<Dailypomodorodto>> getTodayPomodoroSchedule(DateTime todayDate) {
    return db.getToadysPomodoro(todayDate);
  }

  List<Widget> showMonthSchedule(List<Scheduledto> sdList){
    List<Widget> topBar=[];
    topBar.add(Text("이번 달의 일정"));

    //월간 스케줄 보이기
    for(int i=0; i<sdList.length; i++){
      Scheduledto sd = sdList[i];
      topBar.add(Text(sd.schedule_name));
    }

    return topBar;
  }

  showPomodoro(List<Dailypomodorodto> ddlist, context, fun){
    //열
    List<DataColumn> dataColumn = [
      DataColumn(label: Text("일정명")),
      DataColumn(label: Text("시작 시간")),
      DataColumn(label: Text("종료 시간")),
    ];
    //행
    List<DataRow> _getRows() {
      List<DataRow> dataRow = [];
      for (int i=0; i<ddlist.length; i++)  {
        Dailypomodorodto dpd=ddlist[i];
        List<DataCell> cells = [
          DataCell(Text(dpd.DP_name, style: TextStyle(color: Colors.redAccent[100]),)),
          DataCell(Text(dpd.DP_startTime, style: TextStyle(color: Colors.black87),)),
          DataCell(Text(dpd.DP_endTime, style: TextStyle(color: Colors.black87),)),
        ];

        dataRow.add(
            DataRow(
                onSelectChanged: (newValue) { //일정 수정
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      Pomodoroedit(dpd: dpd))).then((value){
                    fun();
                  });
                },
                cells: cells
            )
        );
      }
      return dataRow;
    }
    return DataTable(
      showCheckboxColumn: false,
      horizontalMargin: 10.0,
      columnSpacing: 20.0,

      columns: dataColumn,
      rows: _getRows(),
    );
  }

}