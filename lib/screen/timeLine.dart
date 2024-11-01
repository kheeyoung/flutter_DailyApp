import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/screen/addNewTimeLine.dart';
import 'package:flutter/material.dart';

import '../month_schedule/scheduleDTO.dart';

class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  DBHelper db =DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("타임라인"),
        centerTitle: true,
        elevation: 0.0,
        actions:<Widget>[ IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>Addnewtimeline()));
            },
        )]
      ),
      body: FutureBuilder(
          future: db.NotOverSchedule(),
          builder: (BuildContext context, AsyncSnapshot<List<Scheduledto>> snapshot){
            if(snapshot.hasData){
              Map<int,int> link={};
              Map<int,int> pos={};
              for(int i=0; i<snapshot.data!.length; i++){
                link[i]=snapshot.data![i].schedule_next;
                pos[snapshot.data![i].schedule_id]=i;
              }



              List<Widget> w=[];
              for(int i=0; i<snapshot.data!.length; i++){
                int num= -1;
                if(link[i]!=null && pos[link[i]]!=null){
                  num=pos[link[i]]!;
                }

                if(num!=-1){
                  w.add(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: (){},
                            child: Text(snapshot.data![num].schedule_name)
                        ),
                        Text(" > "),
                        OutlinedButton(
                            onPressed: (){},
                            child: Text(snapshot.data![i].schedule_name)
                        ),
                      ],
                    )
                  );

                }


              }

              return Column(
                children: w,
              );
            }
            else{return Text("일정이 없습니다.");}
          }
      ),
    );
  }
}
