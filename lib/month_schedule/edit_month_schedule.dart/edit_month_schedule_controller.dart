import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/material.dart';

import '../../methods/local_push_notifications.dart';

class EditMonthScheduleController {
  DBHelper db = DBHelper();
  MyNotification mn = MyNotification();

  Future<String> insert_schedule_db(Scheduledto sd1, TimeOfDay time) async {
    Scheduledto sd = sd1;
    if (sd.schedule_name == "") {
      return "스케줄 명은 필수 입니다.";
    }
    bool check = await db.checkSchedules(sd);

    if (!check) {
      return "동일 날짜에 동일 일정이 있습니다.";
    }

    //알림 설정
    sd.schedule_alarmID = await insert_alarm_db(sd, time);

    if (sd.schedule_alarmID == 0) {
      return "알람은 과거로 설정 할 수 없습니다.";
    }

    //DB에 추가
    db.insertData(sd);

    return "등록 성공!";
  }

  Future<int> insert_alarm_db(Scheduledto sd, TimeOfDay selectedTime) async {
    int nextId = await db.getScheduleID();
    nextId = (nextId + 1) * -1;

    if (sd.schedule_alarm) {
      nextId *= -1;
      DateTime time = DateTime(sd.schedule_start_year, sd.schedule_start_month,
          sd.schedule_start_day, selectedTime!.hour, selectedTime!.minute);
      String MyID = "EndID${sd.schedule_name}";



      //시간 설정에 문제가 있는 경우
      if (DateTime.now().isAfter(time)) {
        return 0;
      }

      LocalPushNotifications.showScheduleNotification(
          title: sd.schedule_name,
          body: "월간 일정이 있습니다. \n Memo: ${sd.schedule_memo}",
          payload: "스케쥴 푸시 알림 데이터",
          setTime: time,
          MychannelID: MyID,
          MychannelName: "${sd.schedule_name}EndName",
          ID: nextId);
    }

    print(nextId);
    return nextId;
  }

}
