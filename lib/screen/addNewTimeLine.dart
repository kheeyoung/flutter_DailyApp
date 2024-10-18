/*import 'package:dailyapp/db/DbHelper.dart';

import '../widget/InputTextFormField.dart';
import '../widget/MyButton.dart';
import 'package:flutter/material.dart';


class Addnewtimeline extends StatefulWidget {
  const Addnewtimeline({super.key});

  @override
  State<Addnewtimeline> createState() => _AddnewtimelineState();
}

class _AddnewtimelineState extends State<Addnewtimeline> {
  InputTextFormField itff = InputTextFormField();
  String preSchedule="";
  DBHelper db= DBHelper();
  bool isFristSche=false;
  String TimeLineName="";
  String Memo="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Future.wait([db.NotOverSchedule()]),
        builder: (BuildContext context, AsyncSnapshot<List<List<Map<String, Object?>>>> snapshot) {
          if (snapshot.hasData) {
            List<String> scheduleNames=[];
            List<Map> scheduleData=snapshot.data![0];
            for(int i=0; i<scheduleData.length;i++){
              if(scheduleData[i]['schedule_name'] ==null){continue;}
              String name=(i+1).toString()+") "
                  +scheduleData[i]['schedule_name']
                  +" / 시작일: "+scheduleData[i]['schedule_start'];
              scheduleNames.add(name);
            }

            return GestureDetector(
              onTap: (){FocusScope.of(context).unfocus();},
              child: SingleChildScrollView(
                child: Center(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      const Text("새 타임라인 설정"),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("타임라인 명 : "),
                          SizedBox(
                            height: 30,
                            width: 160,
                            child: TextFormField(
                              key: const ValueKey(1),
                              onSaved: (value) {
                                setState(() {TimeLineName = value!;});
                              },
                              onChanged: (value) {
                                setState(() {TimeLineName = value;});
                              },
                              decoration: itff.basicFormDeco("타임라인 명"),
                              style: const TextStyle(fontSize: 15),
                            ),
                          )
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("기존 일정에 붙이기 : "),
                          SizedBox(
                            height: 50,
                            width: 250,
                            child: DropdownButton<String>(
                              value: preSchedule.isNotEmpty ? preSchedule : null,
                              items: scheduleNames
                                  .map((e) => DropdownMenuItem(
                                value: e.toString(),
                                child: Text(e.toString(),style: const TextStyle(color: Colors.black),),
                              ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  preSchedule = newValue!;
                                });

                              },
                              dropdownColor: Colors.white,
                              iconSize: 50,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("첫번째 일정으로 시작하기"),
                          Checkbox(
                              value: isFristSche,
                              onChanged: (value){
                                setState(() {
                                  isFristSche=value!;
                                });
                              }
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 170,
                        width: 300,
                        child: TextFormField(
                          key: const ValueKey(2),
                          onSaved: (value) {
                            setState(() {Memo = value!;});
                          },
                          onChanged: (value) {
                            setState(() {Memo = value;});
                          },
                          decoration: itff.basicFormDeco("Memo"),
                          style: const TextStyle(fontSize: 15),
                          maxLength: 200,
                          maxLines: 6,
                        ),
                      ),
                      OutlinedButton(
                          onPressed: (){},
                          child: Text("타임라인 등록")
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          else{return const Text("로딩중");};}
      )
    );
  }
}
*/