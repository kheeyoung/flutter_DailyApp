import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/search_schedule/search_schedule_result/search_schedule_result_view.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:flutter/material.dart';

class SearchScheduleController {
  Mybutton but = Mybutton();
  DBHelper db = DBHelper();

  Widget getSearchWords(List<String> list, context) {
    List<Widget> words = [];
    for (String i in list) {
      words.add(
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: but.MySearchButton(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchScheduleResultView(searchWord: i)));
          }, i),
        ),
      );
    }

    return Wrap(
        direction: Axis.horizontal, // 나열 방향
        spacing: 0, // 좌우 간격
        runSpacing: 0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: words
    );
  }

  Future addWords(String searchWord) async {
    if (searchWord.isNotEmpty) {
      await db.insertSearch(searchWord);
    }
  }
}
