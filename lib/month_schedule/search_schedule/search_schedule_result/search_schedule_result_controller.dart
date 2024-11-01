import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchScheduleResultController{
  DBHelper db = DBHelper();

  Future<List<Scheduledto>> getSearchWord(String word)async{
    return await db.findSearchByWord(word);
  }

  DataTable showResultSchedule(List<Scheduledto> list) {
    //열
    List<DataColumn> dataColumn = [
      DataColumn(label: Text("일정명")),
      DataColumn(label: Text("시작 기간")),
      DataColumn(label: Text("종료 기간")),
      DataColumn(label: Text("알림")),
      DataColumn(label: Text("메모")),
    ];
    //행
    List<DataRow> _getRows() {
      List<DataRow> dataRow = [];
      for (Scheduledto i in list)  {
        String alarm = i.schedule_alarm==0 ? "OFF" : "ON";
        List<DataCell> cells = [
          DataCell(Text(i.schedule_name, style: TextStyle(color: Colors.redAccent[100]),)),
          DataCell(Text("${i.schedule_start_month}/${i.schedule_start_day}", style: TextStyle(color: Colors.black87),)),
          DataCell(Text("${i.schedule_end_month}/${i.schedule_end_day}", style: TextStyle(color: Colors.black87),)),
          DataCell(Text(i.schedule_memo, style: TextStyle(color: Colors.black87),)),
          DataCell(Text(alarm, style: TextStyle(color: Colors.black87),)),
        ];

        dataRow.add(
            DataRow(
                onSelectChanged: (newValue) { //일정 수정
                  //일정 수정하게 하기
                },
                cells: cells
            )
        );
      }
      return dataRow;
    }
    print("ashdhashd");
    return DataTable(
      showCheckboxColumn: false,
      horizontalMargin: 10.0,
      columnSpacing: 20.0,

      columns: dataColumn,
      rows: _getRows(),
    );
  }
}