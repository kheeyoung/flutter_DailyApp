import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:dailyapp/methods/local_push_notifications.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/material.dart';
import 'package:dailyapp/widget/InputTextFormField.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'edit_month_schedule_controller.dart';

class EditMonthScheduleView extends StatefulWidget {
  const EditMonthScheduleView(
      {super.key,
      required this.year,
      required this.month,
      required this.day,
      this.sd});

  final int year;
  final int month;
  final int day;
  final Scheduledto? sd;

  @override
  State<EditMonthScheduleView> createState() => _EditMonthScheduleViewState();
}

class _EditMonthScheduleViewState extends State<EditMonthScheduleView> {
  //DB 생성자
  DBHelper dbHelper = DBHelper();

  //위젯 생성자
  InputTextFormField itff = InputTextFormField();
  MyNotification mn = MyNotification();
  Mybutton mb = Mybutton();
  LocalPushNotifications ln = LocalPushNotifications();
  EditMonthScheduleController emsc = EditMonthScheduleController();

  //변수
  late Scheduledto sd;

  @override
  void initState() {
    // TODO: implement initState
    sd = new Scheduledto(
        0,
        "",
        widget.year,
        widget.month,
        widget.day,
        widget.year,
        widget.month,
        widget.day,
        TimeOfDay.now().hour,
        TimeOfDay.now().minute,
        false,
        "",
        0);
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    //만약 수정의 경우 (sd가 있으면)
    if (widget.sd != null) {
      sd = widget.sd!;
    }
    String formalName = sd.schedule_name;

    return Scaffold(
        appBar: AppBar(title: const Text("date schedule")),
        body: SingleChildScrollView(
          child: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Text("${widget.year}\n${widget.month}/${widget.day}"),
                  const SizedBox(
                    height: 20,
                  ),
                  //일정명 입력
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("일정명 : "),
                    SizedBox(
                      width: 180,
                      height: 25,
                      child: TextFormField(
                        initialValue: sd.schedule_name,
                        key: const ValueKey(1),
                        onSaved: (value) {
                          setState(() {
                            sd.schedule_name = value!;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            sd.schedule_name = value;
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
                  const SizedBox(
                    height: 15,
                  ),
                  //기간 입력
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("기간 : "),
                      mb.myOutLinedButton(() async {
                        DateTime? start = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000));
                        setState(() {
                          sd.schedule_start_year = start!.year;
                          sd.schedule_start_month = start!.month;
                          sd.schedule_start_day = start!.day;
                        });
                      }, "${sd.schedule_start_month}/${sd.schedule_start_day}"),
                      const Text("~"),
                      mb.myOutLinedButton(() async {
                        DateTime? end = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000));
                        setState(() {
                          sd.schedule_end_year = end!.year;
                          sd.schedule_end_month = end!.month;
                          sd.schedule_end_day = end!.day;
                        });
                      }, "${sd.schedule_end_month}/${sd.schedule_end_day}"),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //알림 입력
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("알림"),
                      const SizedBox(
                        width: 10,
                      ),
                      mb.myOutLinedButton(() async {
                        selectedTime = await mn.TimePicker(context);
                        sd.schedule_alarm_hour = selectedTime.hour;
                        sd.schedule_alarm_minute = selectedTime.minute;
                        setState(() {});
                      }, "${sd.schedule_alarm_hour}:${sd.schedule_alarm_minute}"),
                      Switch(
                        value: sd.schedule_alarm,
                        onChanged: (value) async {
                          if (selectedTime != null) {
                            setState(() {
                              sd.schedule_alarm = value;
                            });
                          } else {
                            selectedTime = await mn.TimePicker(context);
                            setState(() {});
                          }
                        },
                      )
                    ],
                  ),

                  //메모 입력
                  const Text("Memo"),
                  SizedBox(
                    width: 280,
                    height: 250,
                    child: TextFormField(
                      initialValue: sd.schedule_memo,
                      key: const ValueKey(2),
                      onSaved: (value) {
                        setState(() {
                          sd.schedule_memo = value!;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          sd.schedule_memo = value;
                        });
                      },
                      decoration: itff.basicFormDeco("memo"),
                      style: const TextStyle(fontSize: 15),
                      maxLines: 30,
                    ),
                  ),
                  //확인 버튼
                  OutlinedButton(
                      onPressed: () async {
                        String result = "";
                        //신규등록
                        if (sd.schedule_id == 0) {
                          result =
                              await emsc.insert_schedule_db(sd, selectedTime!);
                          mn.snackbarBasic(context, result);
                          if (result.substring(3) == "성공!") {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/MonthScheduleView', (route) => false);
                          }
                        }
                        //수정
                        else {
                          String result = await emsc.update_schedule_db(
                              sd, selectedTime!, formalName);
                          mn.snackbarBasic(context, result);
                          if (result.substring(3) == "성공!") {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/MonthScheduleView', (route) => false);
                          }
                        }
                      },
                      child: Text(sd.schedule_id == 0 ? "일정 추가" : "일정 업데이트"))
                ],
              ),
            ),
          ),
        ));
  }
}
