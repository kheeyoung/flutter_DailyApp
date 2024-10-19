import 'package:dailyapp/db/scheduleDTO.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dailyPomodoroDTO.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._(); // DBHelper의 싱글톤 객체 생성
  static Database? _database; // 데이터베이스 인스턴스를 저장하는 변수

  DBHelper._(); // DBHelper 생성자(private)

  factory DBHelper() => _instance; // DBHelper 인스턴스 반환 메소드

  // 데이터베이스 인스턴스를 가져오는 메소드
  Future<Database> get database async {
    if (_database != null) {
      // 인스턴스가 이미 존재한다면
      return _database!; // 저장된 데이터베이스 인스턴스를 반환
    }
    _database = await _initDB(); // 데이터베이스 초기화
    return _database!; // 초기화된 데이터베이스 인스턴스 반환
  }

  // 데이터베이스 초기화 메소드
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // 데이터베이스 경로 가져오기
    final path = join(dbPath, 'schedule.db'); // 데이터베이스 파일 경로 생성
    return await openDatabase(
      path, // 데이터베이스 파일 경로
      version: 1, // 데이터베이스 버전
      onCreate: (db, version) async {
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          'CREATE TABLE schedule('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'schedule_name TEXT NOT NULL,'
              'schedule_start TEXT,'
              'schedule_end TEXT,'
              'schedule_time TEXT,'
              'schedule_alarm bool,'
              'schedule_memo TEXT,'
              'schedule_isOver bool,'
              'schedule_next INTEGER,'
              'schedule_alarmID INTEGER'
          ');',
        );

        //일간 용 DB table
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          'CREATE TABLE dailyPomodoro('
              'DP_id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'DP_name TEXT NOT NULL,'
              'DP_date TEXT NOT NULL,'
              'DP_startTime TEXT NOT NULL,'
              'DP_endTime TEXT NOT NULL,'
              'DP_StartAlarmID INTEGER,'
              'DP_EndAlarmID INTEGER,'
              'DP_memo TEXT,'
              'DP_isOver bool'
              ');',
        );
      },
    );



  }

  // 데이터 추가 메소드
  Future<void> insertData(Scheduledto sd) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.insert(
      'schedule', // 데이터를 추가할 테이블 이름
      {
        'schedule_name': sd.schedule_name,
        'schedule_start': sd.schedule_start,
        'schedule_end': sd.schedule_end,
        'schedule_time': sd.schedule_time,
        'schedule_alarm': sd.schedule_alarm,
        'schedule_memo': sd.schedule_memo,
        'schedule_isOver' : false,
        'schedule_next' : sd.schedule_next,
        'schedule_alarmID': sd.schedule_alarmID,
      }, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

  //특정 일의 가장 마지막 알람(가장 큰)의 ID 가져오기
  Future<int> getScheduleID() async{
    String sql = 'SELECT MAX(ABS(schedule_alarmID)) FROM schedule;';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    //절대값이라 항상 양수
    String ID= list[0]["MAX(ABS(schedule_alarmID))"].toString();
    int result=-1;
    if(ID!="null"){
      result=int.parse(ID);
    }
    print(sql);
    return result;
  }


//일정이 있는 날짜 가져오기
  Future<List<Map<String, Object?>>> getDate() async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery('SELECT schedule_start,schedule_end FROM schedule;');

    return list;
  }

  //아직 완료되지 않은 일정 다 가져 오기
  Future<List<Scheduledto>> NotOverSchedule() async {

    String sql = 'SELECT * FROM schedule WHERE schedule_isOver =false';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList=mappingSD(list,n);

    return sdList;
  }

  //해당 월의 일정 다 가져 오기
  Future<List<Scheduledto>> getMonthSchedule(int year, int month) async {
    String date = "$year $month";
    String sql = 'SELECT * FROM schedule WHERE schedule_start LIKE \'' + date + '%\' OR schedule_end LIKE \'' + date + '%\'';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList=mappingSD(list,n);
    print(sdList);

    return sdList;
  }

  //해당일의 시작 일정 다 가져 오기
  Future<List<Scheduledto>> getTodaysStartSchedules(selectedDay) async {
    String year=selectedDay.year.toString();
    String month=selectedDay.month.toString();
    String day=selectedDay.day.toString();
    String sql = 'SELECT * FROM schedule WHERE schedule_start LIKE \'' + year+" "+month+"/"+day + '%\'';
    //print(sql);
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList=mappingSD(list,n);

    return sdList;
  }

  //해당일의 끝나는 일정 다 가져 오기
  Future<List<Scheduledto>> getTodaysEndSchedules(selectedDay) async {
    String year=selectedDay.year.toString();
    String month=selectedDay.month.toString();
    String day=selectedDay.day.toString();
    String sql = 'SELECT * FROM schedule WHERE schedule_end LIKE \'' + year+" "+month+"/"+day + '%\'';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList=mappingSD(list,n);

    return sdList;
  }

  //이름, 날짜가 같은 일정 있나 확인
  Future<bool> checkSchedules(name, date) async {

    String sql = 'SELECT * FROM schedule WHERE schedule_name="$name" AND schedule_start="$date"';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    return list.isNotEmpty? true : false;
  }

  //sql 한 걸 SD(생성자)로 매핑
  List<Scheduledto> mappingSD(list,n){
    List<Scheduledto> sdList=[];

    for(int i=0; i<n; i++){

      String alarm=list[i]["schedule_alarm"].toString().toLowerCase();

      Scheduledto sd= Scheduledto(
          int.parse(list[i]["id"].toString()),
          list[i]["schedule_name"].toString(),
          list[i]["schedule_start"].toString(),
          list[i]["schedule_end"].toString(),
          list[i]["schedule_time"].toString(),
          alarm=="true"? true: false,
          list[i]["schedule_memo"].toString(),
          int.parse(list[i]["schedule_next"].toString()),
          int.parse(list[i]["schedule_alarmID"].toString())
      );
      sdList.add(sd);
    }

    return sdList;
  }

  // 데이터 수정 메소드
  Future<void> updateData(int id, Scheduledto sd) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'schedule',
      {
        'schedule_name': sd.schedule_name,
        'schedule_start': sd.schedule_start,
        'schedule_end': sd.schedule_end,
        'schedule_time': sd.schedule_time,
        'schedule_alarm': sd.schedule_alarm,
        'schedule_memo': sd.schedule_memo,
        'schedule_isOver' : false,
        'schedule_next' : sd.schedule_next
      }, // 수정할 데이터
      where: 'id = ?', // 수정할 데이터의 조건 설정
      whereArgs: [id], // 수정할 데이터의 조건 값
    );
  }

  // 데이터 삭제 메소드
  Future<void> deleteData(int id) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.delete(
      'schedule', // 삭제할 테이블 이름
      where: 'id = ?', // 삭제할 데이터의 조건 설정
      whereArgs: [id], // 삭제할 데이터의 조건 값
    );
  }


  //뽀모도로용 메소드
  Future<void> insertPomodoroData(Dailypomodorodto dpd) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.insert(
      'dailyPomodoro', // 데이터를 추가할 테이블 이름
      {
        'DP_name': dpd.DP_name,
        'DP_date': dpd.DP_date,
        'DP_startTime': dpd.DP_startTime,
        'DP_endTime': dpd.DP_endTime,
        'DP_StartAlarmID': dpd.DP_StartAlarmID,
        'DP_EndAlarmID': dpd.DP_EndAlarmID,
        'DP_memo' : dpd.DP_memo,
        'DP_isOver' : dpd.DP_isOver
      }, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

  //선택 날짜의 뽀모도로 일정 전부 가져오기
  Future<List<Dailypomodorodto>> getToadysPomodoro(String date) async {

    String sql = 'SELECT * FROM dailyPomodoro WHERE DP_date =\'$date\';';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    List<Dailypomodorodto> dpdList=[];

    for(int i=0; i<list.length; i++){

      bool DP_isOver=list[i]["DP_isOver"].toString()=="0" ? false:true;
      Dailypomodorodto dpd= Dailypomodorodto(
          int.parse(list[i]["DP_id"].toString()),
          list[i]["DP_name"].toString(),
          list[i]["DP_date"].toString(),
          list[i]["DP_startTime"].toString(),
          list[i]["DP_endTime"].toString(),
          int.parse(list[i]["DP_StartAlarmID"].toString()),
          int.parse(list[i]["DP_EndAlarmID"].toString()),
          list[i]["DP_memo"].toString(),
          DP_isOver
      );
      dpdList.add(dpd);
    }

    return dpdList;
  }

  //특정 일의 가장 마지막 알람(가장 큰)의 ID 가져오기
  Future<int> getTodayPomoStartID(String date) async{
    String sql = 'SELECT MAX(ABS(DP_StartAlarmID)) FROM dailyPomodoro WHERE DP_date =\'$date\';';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    //절대값이라 항상 양수
    String ID= list[0]["MAX(ABS(DP_StartAlarmID))"].toString();
    int result=-1;
    if(ID!="null"){
      result=int.parse(ID);
    }
    return result;
  }

  // 뽀모도로 수정 메소드
  Future<void> updatePomodoro(Dailypomodorodto dpd) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.update(
      'dailyPomodoro', // 데이터를 수정할 테이블 이름
      {
        'DP_name': dpd.DP_name,
        'DP_date': dpd.DP_date,
        'DP_startTime': dpd.DP_startTime,
        'DP_endTime': dpd.DP_endTime,
        'DP_StartAlarmID': dpd.DP_StartAlarmID,
        'DP_EndAlarmID': dpd.DP_EndAlarmID,
        'DP_memo' : dpd.DP_memo,
        'DP_isOver' : dpd.DP_isOver
      }, // 수정할 데이터
      where: 'DP_id = ?', // 수정할 데이터의 조건 설정
      whereArgs: [dpd.DP_id], // 수정할 데이터의 조건 값
    );
  }


}