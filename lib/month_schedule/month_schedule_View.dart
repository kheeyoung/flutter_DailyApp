import 'package:dailyapp/controller/time_controller.dart';
import 'package:dailyapp/month_schedule/month_schedule_controller.dart';
import 'package:dailyapp/dailyPomodoro/daily_pomodoro_view.dart';
import 'package:dailyapp/screen/intro.dart';
import 'package:dailyapp/widget/InputTextFormField.dart';
import 'package:dailyapp/widget/MyCalendar.dart';
import 'package:dailyapp/widget/MyNotification.dart';
import 'package:flutter/material.dart';
import '../widget/MyButton.dart';

class MonthScheduleView extends StatefulWidget {
  const MonthScheduleView({super.key});

  @override
  State<MonthScheduleView> createState() => _MonthScheduleViewState();
}

class _MonthScheduleViewState extends State<MonthScheduleView> {
  MonthScheduleController mcon = MonthScheduleController();
  Mycalendar mc = Mycalendar();
  Mybutton but = Mybutton();
  MyNotification mn = MyNotification();
  InputTextFormField itff = InputTextFormField();
  TimeController timeController = TimeController();
  DateTime date = DateTime.now();
  bool showMemoEdit = false;
  String memo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("월간 일정"),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Intro()));
              },
              icon: Icon(Icons.backspace)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DailypomodoroView()));
                },
                icon: Icon(Icons.access_alarm))
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                //상단바
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  but.myTextButton(() {
                    setState(() {
                      date = mcon.subMonth(date);
                    });
                  }, "<"),
                  Text("${date.year}년 ${date.month}월",
                      style: const TextStyle(fontSize: 20)),
                  but.myTextButton(() {
                    setState(() {
                      date = mcon.plusMonth(date);
                    });
                  }, ">"),
                ]),
                //달력
                FutureBuilder(
                  future: mcon.getMarkedSchedule(date),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      return mc.MyCal(date.year, date.month, date.day, context,
                          snapshot.data![0], snapshot.data![1]);
                    }
                    return mc.MyCal(
                        date.year, date.month, date.day, context, null, null);
                  },
                ),
                Container(
                  height: 1,
                  color: Colors.black87,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                ),
                //미니 일정
                const Text("이 달의 일정"),
                Container(
                  height: 10,
                ),
                FutureBuilder(
                  future: mcon.getMiniSchedule(date),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return const Text("일정이 없습니다");
                  },
                ),
                Container(
                  height: 1,
                  color: Colors.black87,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                ),
                //메모

                FutureBuilder(
                    future: mcon.getMemo(date),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!showMemoEdit) {
                        if (snapshot.hasData) {
                          memo = snapshot.data!;
                        } else {
                          memo = "";
                        }
                      }

                      Widget memoEdit = Text(memo);
                      if (showMemoEdit) {
                        memoEdit = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("메모 수정"),
                            TextFormField(
                              key: const ValueKey(1),
                              initialValue: memo,
                              onSaved: (value) {
                                setState(() {
                                  memo = value!;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  memo = value!;
                                });
                              },
                              decoration: itff.basicFormDeco("memo"),
                              style: const TextStyle(fontSize: 15),
                              maxLines: 4,
                              maxLength: 100,
                            ),
                            but.myOutLinedButton(() async {
                              await mcon.updateMemo(memo, date);
                              setState(() {
                                showMemoEdit = false;
                              });
                            }, "메모 등록"),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showMemoEdit = false;
                                });
                              },
                              icon: const Icon(Icons.close),
                            )
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Memo"),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showMemoEdit = true;
                                    });
                                  },
                                  icon: Icon(Icons.add))
                            ],
                          ),
                          memoEdit
                        ],
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
