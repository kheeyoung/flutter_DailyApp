import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/widget/InputTextFormField.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/material.dart';
import 'package:dailyapp/methods/local_push_notifications.dart';
import '../dailyPomodoro/daily_pomodoroDTO.dart';

class Pomodoroedit extends StatefulWidget {
 
  final Dailypomodorodto dpd;
  const Pomodoroedit({super.key, required this.dpd});

  @override
  State<Pomodoroedit> createState() => _PomodoroeditState();
}

class _PomodoroeditState extends State<Pomodoroedit> {

  MyNotification mn= MyNotification();
  Mybutton mb =Mybutton();
  InputTextFormField itff =InputTextFormField();
  DBHelper db =DBHelper();

  DateTime selectedDay = DateTime.now();

  String scheduleName="";
  TimeOfDay selectedTimeStart= TimeOfDay.now();
  TimeOfDay selectedTimeEnd=TimeOfDay.now();
  int StartalarmID=-1;
  int EndalarmID=-1;
  bool StartalarmOn=false;
  bool EndalarmOn=false;
  String memo="";
  int id=-1;

  bool isNew=false;

  @override
  void initState() {
    Dailypomodorodto dpd=widget.dpd;
    selectedDay=DateTime(dpd.DP_date_year, dpd.DP_date_month, dpd.DP_date_day);
    scheduleName= dpd.DP_name;
    selectedTimeStart=TimeOfDay(hour: int.parse(dpd.DP_startTime.substring(0,2)), minute: int.parse(dpd.DP_startTime.substring(3,5)));
    selectedTimeEnd=TimeOfDay(hour: int.parse(dpd.DP_endTime.substring(0,2)), minute: int.parse(dpd.DP_endTime.substring(3,5)));
    StartalarmID=dpd.DP_StartAlarmID;
    EndalarmID=dpd.DP_EndAlarmID;
    memo=dpd.DP_memo;
    id=dpd.DP_id;

    if(StartalarmID>0){
      StartalarmOn=true;
    }
    if(EndalarmID>0){
      EndalarmOn=true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: (){FocusScope.of(context).unfocus();},
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text("${selectedDay.month}월 ${selectedDay.day}일"),
            
                const SizedBox(width: 500, child: Divider(thickness: 2.0)),
                //일정명 입력
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("일정명 : "),
                  SizedBox(
                    width: 180,
                    height: 25,
                    child: TextFormField(
                      key: const ValueKey(1),
                      initialValue: scheduleName,
                      onSaved: (value) {
                        setState(() {
                          scheduleName = value!;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          scheduleName = value;
                        });
                      },
                      decoration: itff.basicFormDeco("일정명"),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ]),
                //시작시간
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("시작 시간 :"),
                    const SizedBox(width: 10,),
                    mb.myOutLinedButton(()async{
                      selectedTimeStart=await mn.TimePicker(context, TimeOfDay.now());
                      setState(() {});
            
                    },
                        selectedTimeStart==null?"시간 설정":selectedTimeStart!.hour.toString()+":"+selectedTimeStart!.minute.toString()
                    ),
                    Switch(
                      value: StartalarmOn,
                      onChanged: (value) async {
                        if(selectedTimeStart!=null){
                          setState(() {StartalarmOn = value;});
                        }
                        else{
                          selectedTimeStart=await mn.TimePicker(context, TimeOfDay.now());
                          setState(() {});
                        }
            
                      },
                    )
                  ],),
            
                //종료시간
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("종료 시간 :"),
                    const SizedBox(width: 10,),
                    mb.myOutLinedButton(()async{
                      selectedTimeEnd=await mn.TimePicker(context, selectedTimeStart);
                      setState(() {});
                    },
                        selectedTimeEnd==null?"시간 설정":selectedTimeEnd!.hour.toString()+":"+selectedTimeEnd!.minute.toString()
                    ),
                    Switch(
                      value: EndalarmOn,
                      onChanged: (value) async {
                        if(selectedTimeEnd!=null){
                          setState(() {EndalarmOn = value;});
                        }
                        else{
                          selectedTimeEnd=await mn.TimePicker(context, selectedTimeStart);
                          setState(() {});
                        }
                      },
                    )
                  ],),
                //빠른 종료 시간 설정
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mb.myOutLinedButton((){
                      selectedTimeEnd=remakeTime(selectedTimeEnd, 5);
                      setState(() {});}, "5분 후"),
                    mb.myOutLinedButton((){
                      selectedTimeEnd=remakeTime(selectedTimeEnd, 10);
                      setState(() {});}, "10분 후"),
                    mb.myOutLinedButton((){
                      selectedTimeEnd=remakeTime(selectedTimeEnd, 30);
                      setState(() {});}, "30분 후"),
                    mb.myOutLinedButton((){
                      selectedTimeEnd=remakeTime(selectedTimeEnd, 60);
                      setState(() {});}, "1시간 후"),

                  ],
                ),
                //메모 입력
                const Text("Memo"),
                SizedBox(
                  width: 280,
                  height: 100,
            
                  child: TextFormField(
                    key: const ValueKey(2),
                    initialValue: memo,
                    onSaved: (value) {
                      setState(() {memo = value!;});
                    },
                    onChanged: (value) {
                      setState(() {memo = value;});
                    },
                    decoration: itff.basicFormDeco("memo"),
                    style: const TextStyle(fontSize: 15),
                    maxLines: 4,
                    maxLength: 100,
                  ),
                ),
            
            
                OutlinedButton(
                    onPressed: () async {
                      //일정 명이 없는 경우
                      if(scheduleName.isEmpty ) {
                        mn.snackbarBasic(context, "일정 명은 필수 입니다.");
                        return;
                      }
                      //시간 설정에 문제가 있는 경우
                      if(selectedTimeStart.hour>selectedTimeEnd!.hour ||
                          (selectedTimeStart.minute>selectedTimeEnd.minute && selectedTimeStart.hour>=selectedTimeEnd.hour)){
                        mn.DialogBasic(context, "알람은 과거로 설정 할 수 없으며, \n종료시간은 시작 시간 이후로 설정해주세요.");
                        return;
                      }
            

                      //알림 설정
                      //만약 신규 등록의 경우 가장 최근 알림의 ID 받아오기
                      if(StartalarmID==0){
                        int AlarmID = await db.getTodayPomoStartID(selectedDay);
                        //각자 2,3씩 더해서 각자의 사용 가능한 알림 아이디로 만들기
                        StartalarmID=AlarmID+2;
                        EndalarmID=AlarmID+3;
                      }
            
                      //시작 알림
                      if(StartalarmOn){
                        DateTime time =DateTime(DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            selectedTimeStart.hour,selectedTimeStart.minute);
                        String MyID="StartID$scheduleName";
            
                        if(StartalarmID<0){ StartalarmID*=-1;}
                        if(!time.isBefore(DateTime.now())){
                          LocalPushNotifications.showScheduleNotification(
                              title: scheduleName,
                              body: "일정 시작 시간입니다. \n Memo: $memo",
                              payload: "스케쥴 푸시 알림 데이터",
                              setTime: time,
                              MychannelID: MyID,
                              MychannelName: scheduleName+"StartName",
                              ID: StartalarmID
                          );
                        }
            
                      }
                      //만약 알림 설정을 안 한경우 알림 아이디를 음수로 설정
                      else {
                        if(StartalarmID>0){ StartalarmID*=-1;}
                      }
                      if(EndalarmOn){
                        DateTime time =DateTime(selectedDay.year,
                            selectedDay.month,
                            selectedDay.day,
                            selectedTimeEnd.hour,selectedTimeEnd.minute);
                        String MyID="EndID"+scheduleName;
            
                        if(EndalarmID<0){ EndalarmID*=-1;}
                        if(!time.isBefore(selectedDay)){
                          LocalPushNotifications.showScheduleNotification(
                              title: scheduleName,
                              body: "일정 종료 시간입니다. \n Memo: "+memo,
                              payload: "스케쥴 푸시 알림 데이터",
                              setTime: time,
                              MychannelID: MyID,
                              MychannelName: scheduleName+"EndName",
                              ID: EndalarmID
                          );
                        }
            
                      }
                      else {if(EndalarmID>0){ EndalarmID*=-1;}}
            
                      try{
                        Dailypomodorodto dpd = Dailypomodorodto(
                            id,
                            scheduleName,
                            selectedDay.year,
                            selectedDay.month,
                            selectedDay.day,
                            selectedTimeStart.toString().substring(10,15),
                            selectedTimeEnd.toString().substring(10,15),
                            StartalarmID,
                            EndalarmID,
                            memo,
                            false
                        );
                        if(id==-1){ //새로 등록인 경우
                          await db.insertPomodoroData(dpd);
                          mn.snackbarBasic(context, "등록 성공");
                        }
                        else{  //수정인 경우
                          await db.updatePomodoro(dpd);
                          mn.snackbarBasic(context, "수정 성공");
                          print(EndalarmID);
                        }
                      }
                      catch(e){
                        mn.snackbarBasic(context, "오류!!");
                      }
                      Navigator.pop(context,'EXIT');
            
                    },
            
                    child: id==-1 ? Text("일정추가"): Text("일정 수정")),
            
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop("EXIT");
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
        ),
      );
  }

  TimeOfDay remakeTime(TimeOfDay selectedTimeEnd, int i) {
    if(selectedTimeEnd!=null){
      int m = selectedTimeEnd.minute+i;
      int h = selectedTimeEnd.hour;
      if(m>=60){
        h++;
        m-=60;
      }
      if(h>=24){mn.DialogBasic(context, "시간은 자정을 넘길 수 없습니다.");}
      else{
        selectedTimeEnd= TimeOfDay(hour: h, minute: m);
      }
    }
    return selectedTimeEnd;
  }
}
