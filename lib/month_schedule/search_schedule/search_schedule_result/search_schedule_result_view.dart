import 'package:dailyapp/month_schedule/search_schedule/search_schedule_result/search_schedule_result_controller.dart';
import 'package:dailyapp/widget/showMiniSchedule.dart';
import 'package:flutter/material.dart';

import '../../scheduleDTO.dart';

class SearchScheduleResultView extends StatefulWidget {
  const SearchScheduleResultView({super.key, required this.searchWord});

  final String searchWord;

  @override
  State<SearchScheduleResultView> createState() =>
      _SearchScheduleResultViewState();
}

class _SearchScheduleResultViewState extends State<SearchScheduleResultView> {
  SearchScheduleResultController ssrc = SearchScheduleResultController();
  Showminischedule ss =Showminischedule();

  @override
  Widget build(BuildContext context) {
    String word=widget.searchWord;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("$word검색 결과"),

            FutureBuilder(
                future: ssrc.getSearchWord(word),
                builder: (BuildContext context, AsyncSnapshot<List<Scheduledto>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ss.showScheduleTable(snapshot.data!, context);
                  }
                  else {
                    return Text("검색 결과가 없습니다.");
                  }
                })
          ],
        ),
      ),
    );
  }
}
