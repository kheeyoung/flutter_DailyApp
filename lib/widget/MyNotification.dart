
import 'package:dailyapp/db/DbHelper.dart';

import 'package:dailyapp/month_schedule/month_schedule_controller.dart';

import 'package:dailyapp/widget/InputTextFormField.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:dailyapp/widget/showMiniSchedule.dart';
import 'package:flutter/material.dart';

import '../month_schedule/edit_month_schedule.dart/edit_month_schedule_View.dart';


class MyNotification {
  Showminischedule ss = Showminischedule();
  InputTextFormField itff = InputTextFormField();
  Mybutton mb =Mybutton();
  DBHelper db = DBHelper();
  MonthScheduleController mcon =MonthScheduleController();

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
            initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.input
        );

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
                              builder: (context) => EditMonthScheduleView(
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
