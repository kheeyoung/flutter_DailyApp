import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/db/scheduleDTO.dart';
import 'package:dailyapp/methods/local_push_notifications.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/material.dart';
import 'package:dailyapp/widget/InputTextFormField.dart';

class DateSchedule extends StatefulWidget {
  const DateSchedule({super.key, required this.year, required this.month, required this.day});
  final int year;
  final int month;
  final int day;


  @override
  State<DateSchedule> createState() => _DateScheduleState();
}

class _DateScheduleState extends State<DateSchedule> {
  //DB 생성자
  DBHelper dbHelper=DBHelper();
  //위젯 생성자
  InputTextFormField itff = InputTextFormField();
  MyNotification mn=MyNotification();
  Mybutton mb = Mybutton();
  LocalPushNotifications ln= LocalPushNotifications();
  //변수
  String scheduleName="";
  int? startYear=0;
  int? startMonth=0;
  int? startDay=0;
  int? endYear=0;
  int? endMonth=0;
  int? endDay=0;
  TimeOfDay? selectedTime;
  bool alarm=false;
  String memo="";
  int schedule_nextID=0;
  String preSchedule="";

  @override
  Widget build(BuildContext context) {
    int year=widget.year;
    int month=widget.month;
    int day=widget.day;

    //아직 일정의 기간이 설정되지 않았다면 선택 날짜로
    if(startDay==0){
      startYear=widget.year;
      startMonth=widget.month;
      startDay=widget.day;
    }
    if(endDay==0){
      endYear=widget.year;
      endMonth=widget.month;
      endDay=widget.day;
    }

    String date= "$year\n$month/$day";



    return Scaffold(
      appBar: AppBar(title:const Text("date schedule")),
      body: SingleChildScrollView(
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){FocusScope.of(context).unfocus();},
            child: Column(
              children: [
                Text(date),
                const SizedBox(height: 20,),
                //일정명 입력
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("일정명 : "),
                      SizedBox(
                        width: 180,
                        height: 25,

                        child: TextFormField(
                          key: const ValueKey(1),
                          onSaved: (value) {
                            setState(() {scheduleName = value!;});
                          },
                          onChanged: (value) {
                            setState(() {scheduleName = value;});
                          },
                          decoration: itff.basicFormDeco("일정명"),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ]
                ),
                const SizedBox(height: 15,),
                //기간 입력
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("기간 : "),
                    mb.myOutLinedButton(()async{
                      DateTime? start=await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(3000));
                      setState(() {
                        startYear=start!.year;
                        startMonth=start!.month;
                        startDay=start!.day;
                      });
                    },
                        startDay==0?"시작일":"$startMonth/$startDay" ),

                    const Text("~"),
                    mb.myOutLinedButton (()async{
                      DateTime? end=await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(3000));
                      setState(() {
                        endYear=end!.year;
                        endMonth=end!.month;
                        endDay=end!.day;
                      });
                    },
                        endDay==0?"종료일":"$endMonth/$endDay"),

                  ],
                ),
                const SizedBox(height: 15,),
                //알림 입력
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("알림"),

                    const SizedBox(width: 10,),
                    mb.myOutLinedButton(()async{
                      selectedTime=await mn.TimePicker(context);
                      setState(() {});
                    },

                        selectedTime==null?"시간 설정":selectedTime!.hour.toString()+":"+selectedTime!.minute.toString()
                    ),
                    Switch(
                      value: alarm,
                      onChanged: (value) async {
                        if(selectedTime!=null){
                          setState(() {alarm = value;});
                        }
                        else{
                          selectedTime=await mn.TimePicker(context);
                          setState(() {});
                        }

                      },
                    )
                  ],
                ),
                //선행 일정 입력
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("선행 일정 : "),

                    FutureBuilder(
                        future: dbHelper.NotOverSchedule(),
                        builder: (BuildContext context, AsyncSnapshot<List<Scheduledto>> snapshot){

                          if(snapshot.hasData){

                            List<String> notOverScheduleNames=[];
                            Map<String,int> map={};
                            for(int i=0; i<snapshot.data!.length; i++){
                              String scheduleName= snapshot.data![i].schedule_name+" : "+snapshot.data![i].schedule_start;
                              notOverScheduleNames.add(scheduleName);
                              int num =snapshot.data![i].schedule_id;
                              map[scheduleName]=num;
                            }
                            return DropdownButton(
                              value: preSchedule.isNotEmpty ? preSchedule : null,
                              items: notOverScheduleNames
                                  .map((e) => DropdownMenuItem(
                                value: e.toString(),
                                child: Text(e.toString(),style: const TextStyle(color: Colors.black),),
                              ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                print(map[preSchedule]);
                                setState(() {
                                  preSchedule = newValue!;
                                  schedule_nextID=map[preSchedule]!;
                                });

                              },
                              dropdownColor: Colors.white,
                              iconSize: 50,
                            );
                          }
                          else{return Text("선행 일정으로 설정 가능한 일정이 없습니다.");}
                        }
                    )


                  ],
                ),

                //메모 입력
                const Text("Memo"),
                SizedBox(
                  width: 280,
                  height: 250,

                  child: TextFormField(
                    key: const ValueKey(2),
                    onSaved: (value) {
                      setState(() {memo = value!;});
                    },
                    onChanged: (value) {
                      setState(() {memo = value;});
                    },
                    decoration: itff.basicFormDeco("memo"),
                    style: const TextStyle(fontSize: 15),
                    maxLines: 30,
                  ),
                ),
                //확인 버튼
                OutlinedButton(
                    onPressed: ()async{
                      if(scheduleName!=""){
                        bool check= await dbHelper.checkSchedules(scheduleName, "$startYear $startMonth/$startDay");
                        
                        if(!check){
                          //알림 추가
                          int nextId= await dbHelper.getScheduleID();
                          print(nextId);
                          nextId=(nextId+1)*-1;
                          print("------------");
                          print(nextId);
                          if(alarm){
                            
                            nextId*=-1;
                            DateTime time =DateTime(startYear!,
                                startMonth!,
                                startDay!,
                                selectedTime!.hour,selectedTime!.minute);
                            String MyID="EndID"+scheduleName;

                            //시간 설정에 문제가 있는 경우
                            if(DateTime.now().hour>selectedTime!.hour ||
                                (DateTime.now().minute>=selectedTime!.minute && DateTime.now().hour>=selectedTime!.hour)){
                              mn.DialogBasic(context, "알람은 과거로 설정 할 수 없습니다.");
                              return;
                            }

                            LocalPushNotifications.showScheduleNotification(
                                title: scheduleName,
                                body: "월간 일정이 있습니다. \n Memo: "+memo,
                                payload: "스케쥴 푸시 알림 데이터",
                                setTime: time,
                                MychannelID: MyID,
                                MychannelName: scheduleName+"EndName",
                                ID: nextId);
                          }

                          //DB에 추가
                          Scheduledto sd =Scheduledto(
                              0,
                              scheduleName,
                              "$startYear $startMonth/$startDay",
                              "$endYear $endMonth/$endDay",
                              selectedTime==null?"시간 설정":"${selectedTime!.hour}:${selectedTime!.minute}",
                              alarm,
                              memo,
                              schedule_nextID,
                              nextId
                          );
                          dbHelper.insertData(sd);


                          mn.snackbarBasic(context, "일정 추가 성공!");

                        }
                        else{mn.snackbarBasic(context, "동일 날짜에 동일 일정이 있습니다.");}
                        
                      }
                      else{mn.snackbarBasic(context, "일정명을 입력해주세요!");}
                      
                      
                    },
                    child: const Text("일정 추가")
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
