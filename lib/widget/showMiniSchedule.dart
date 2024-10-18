import 'package:flutter/material.dart';

import '../db/scheduleDTO.dart';
class Showminischedule{

  MyMiniSchedule(List<Scheduledto> sd, int month){
    List<Row> w=[];
    for(int i=0; i<sd.length;i++){
      String s= sd[i].schedule_name;
      String start= sd[i].schedule_start;
      String end= sd[i].schedule_end;
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
          Column(children: w,)
        ],
      ),
    );
  }

  MyFullSchedule(List<Scheduledto> sd){
    List<Column> w=[];
    for(int i=0; i<sd.length;i++){
      String start= sd[i].schedule_start;
      String end= sd[i].schedule_end;
      String name= sd[i].schedule_name;
      String time= sd[i].schedule_time;
      String alarm= sd[i].schedule_alarm.toString();
      String memo= sd[i].schedule_memo;

      time=time=="시간 설정" ? "":time;
      alarm=alarm=="0"?"OFF":"ON";
      w.add(Column(
        children: [
          Text(name),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("$start ~ $end"),
              ]
          ),
          Text(time),
          Text(alarm),
          Text(memo),
          SizedBox(height: 20,),
          Container(width: 500,
              child: Divider(thickness: 1.0)),
        ],
      ));
    }
    return Center(
      child: SingleChildScrollView(child: Column(children: w,))
    );
  }

}