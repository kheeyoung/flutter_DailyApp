import 'package:dailyapp/db/DbHelper.dart';
import 'package:dailyapp/month_schedule/search_schedule/search_schedule_controller.dart';
import 'package:dailyapp/month_schedule/search_schedule/search_schedule_result/search_schedule_result_view.dart';
import 'package:dailyapp/widget/InputTextFormField.dart';
import 'package:dailyapp/widget/MyButton.dart';
import 'package:flutter/material.dart';

class SearchScheduleView extends StatefulWidget {
  const SearchScheduleView({super.key});

  @override
  State<SearchScheduleView> createState() => _SearchScheduleViewState();
}

class _SearchScheduleViewState extends State<SearchScheduleView> {
  InputTextFormField itff = InputTextFormField();
  Mybutton but = Mybutton();
  SearchScheduleController ssc = SearchScheduleController();

  DBHelper db = DBHelper();

  String searchWord = "";
  Widget words = Column();
  Widget result = Text("");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("일정 검색"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.backspace)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    width: 350,
                    height: 25,
                    child: TextFormField(
                      key: const ValueKey(1),
                      onSaved: (value) {
                        setState(() {
                          searchWord = value!;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          searchWord = value;
                        });
                      },
                      decoration: itff.basicFormDeco("검색어를 입력해주세요"),
                      style: const TextStyle(fontSize: 15),
                      maxLines: 30,
                    ),
                  ),
                  but.myOutLinedButton(() async {
                    await ssc.addWords(searchWord);
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchScheduleResultView(searchWord: searchWord)));
                  }, "검색")
                ],
              ),
              FutureBuilder(
                  future: db.getSearch(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.hasData) {
                      words = ssc.getSearchWords(snapshot.data!, context);
                    }
                    return words;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
