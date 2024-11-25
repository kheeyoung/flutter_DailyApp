import 'package:dailyapp/month_schedule/edit_month_schedule.dart/edit_month_schedule_View.dart';
import 'package:flutter/material.dart';
import '../month_schedule/scheduleDTO.dart';
class Showminischedule{

  MyMiniSchedule(List<Scheduledto> sd, int month){
    List<Row> w=[];
    for(int i=0; i<sd.length;i++){
      String s= sd[i].schedule_name;
      String start= "${sd[i].schedule_start_year} ${sd[i].schedule_start_month}/${sd[i].schedule_start_day}";
      String end= "${sd[i].schedule_end_year} ${sd[i].schedule_end_month}/${sd[i].schedule_end_day}";
      w.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[

            Text(s),
            SizedBox(width: 20,),
            Text("$start ~ $end")
          ]
      ));
    }
    return Center(
      child: Column(
        children: [

          SizedBox(height: 70,
            child: SingleChildScrollView(child: Column(children: w,))
          )

        ],
      ),
    );
  }


  DataTable showScheduleTable(List<Scheduledto> list, context) {
    //열
    List<DataColumn> dataColumn = [
      const DataColumn(label: Text("일정명")),
      const DataColumn(label: Text("시작 기간")),
      const DataColumn(label: Text("종료 기간")),
      const DataColumn(label: Text("알림")),
      const DataColumn(label: Text("메모")),
    ];
    //행
    List<DataRow> _getRows() {
      List<DataRow> dataRow = [];
      for (Scheduledto i in list)  {
        String alarm = i.schedule_alarm==0 ? "OFF" : "ON";
        String memo = i.schedule_memo.isNotEmpty ? i.schedule_memo : "-";
        String name=i.schedule_name;
        if(name.length>10){name="${name.substring(0,8)}...";}
        List<DataCell> cells = [
          DataCell(Text(name, style: TextStyle(color: Colors.redAccent[100]),)),
          DataCell(Text("${i.schedule_start_month}/${i.schedule_start_day}", style: TextStyle(color: Colors.black87),)),
          DataCell(Text("${i.schedule_end_month}/${i.schedule_end_day}", style: TextStyle(color: Colors.black87),)),
          DataCell(Text(alarm, style: TextStyle(color: Colors.black87),)),
          DataCell(Text(memo, style: TextStyle(color: Colors.black87),)),
        ];

        dataRow.add(
            DataRow(
                onSelectChanged: (newValue) { //일정 수정
                  //일정 수정으로 가기
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditMonthScheduleView(
                    year: i.schedule_start_year,
                    month: i.schedule_start_month,
                    day:i.schedule_start_day,
                    sd: i,
                  )));
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