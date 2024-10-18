
import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/db/dailyPomodoroDTO.dart';
import 'package:dailyapp/screen/dailyPomodoro.dart';
import 'package:dailyapp/widget/InputTextFormField.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:dailyapp/widget/showMiniSchedule.dart';
import 'package:flutter/material.dart';

import '../methods/local_push_notifications.dart';
import '../screen/date_schedule.dart';

class MyNotification {
  Showminischedule ss = Showminischedule();
  InputTextFormField itff = InputTextFormField();
  Mybutton mb =Mybutton();
  DBHelper db = DBHelper();

  snackbarBasic(context, textContents) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(textContents), backgroundColor: Colors.black54));
  }

  DialogBasic(context,text) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text(text),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      },
    );
  }



  dialogPickTime(context, timepick) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                timepick,
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future TimePicker(context, [otherTime]) async {
    TimeOfDay? selectedTime= TimeOfDay.now();
    selectedTime =
        await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now()
        );

    if(otherTime!=null){
      if(otherTime.hour>selectedTime!.hour ||
          (otherTime.minute>selectedTime.minute && otherTime.hour>=selectedTime.hour)){
        DialogBasic(context, "알람은 괴거로 설정 할 수 없으며, \n종료시간은 시작 시간 이후로 설정해주세요.");
        return TimeOfDay.now();
      }
    }
    return selectedTime;
  }

  showDetailDialog(context, DateTime selectedDay, ssd, esd) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text("${selectedDay.month}월 ${selectedDay.day}일"),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(width: 500, child: Divider(thickness: 2.0)),
                const SizedBox(
                  height: 20,
                ),
                Text("시작 일정"),
                ss.MyFullSchedule(ssd),
                Container(width: 500, child: Divider(thickness: 2.0)),
                Text("종료 일정"),
                ss.MyFullSchedule(esd),
                OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DateSchedule(
                                  year: selectedDay.year,
                                  month: selectedDay.month,
                                  day: selectedDay.day)));
                    },
                    child: Text("일정추가")),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
        );
      },
    );
  }





}
