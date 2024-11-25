import 'package:dailyapp/month_schedule/scheduleDTO.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../dailyPomodoro/daily_pomodoroDTO.dart';

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
          'schedule_start_year INTEGER,'
          'schedule_start_month INTEGER,'
          'schedule_start_day INTEGER,'
          'schedule_end_year INTEGER,'
          'schedule_end_month INTEGER,'
          'schedule_end_day INTEGER,'
          'schedule_alarm_hour INTEGER,'
          'schedule_alarm_minute INTEGER,'
          'schedule_alarm bool,'
          'schedule_memo TEXT,'
          'schedule_isOver bool,'
          'schedule_alarmID INTEGER'
          ');',
        );

        //일간 용 DB table
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          'CREATE TABLE dailyPomodoro('
          'DP_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'DP_name TEXT NOT NULL,'
          'DP_date_year TEXT NOT NULL,'
          'DP_date_month TEXT NOT NULL,'
          'DP_date_day TEXT NOT NULL,'
          'DP_startTime TEXT NOT NULL,'
          'DP_endTime TEXT NOT NULL,'
          'DP_StartAlarmID INTEGER,'
          'DP_EndAlarmID INTEGER,'
          'DP_memo TEXT,'
          'DP_isOver bool'
          ');',
        );

        //메모 용 DB table
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          'CREATE TABLE memo('
          'M_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'M_txt TEXT,'
          'M_year TEXT NOT NULL,'
          'M_month TEXT NOT NULL'
          ');',
        );

        //일정 검색 용 DB table
        await db.execute(
          // SQL 쿼리를 실행하여 데이터베이스 테이블 생성
          'CREATE TABLE search('
              'S_id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'S_txt TEXT'
              ');',
        );
      },
    );
  }

  //월간 용-------------------------------------------------------------------------------------------------
  // 데이터 추가 메소드
  Future<void> insertData(Scheduledto sd) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.insert(
      'schedule', // 데이터를 추가할 테이블 이름
      {
        'schedule_name': sd.schedule_name,
        'schedule_start_year': sd.schedule_start_year,
        'schedule_start_month': sd.schedule_start_month,
        'schedule_start_day': sd.schedule_start_day,
        'schedule_end_year': sd.schedule_end_year,
        'schedule_end_month': sd.schedule_end_month,
        'schedule_end_day': sd.schedule_end_day,
        'schedule_alarm_hour': sd.schedule_alarm_hour,
        'schedule_alarm_minute': sd.schedule_alarm_minute,
        'schedule_alarm': sd.schedule_alarm,
        'schedule_memo': sd.schedule_memo,
        'schedule_isOver': false,
        'schedule_alarmID': sd.schedule_alarmID,
      }, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

  //특정 일의 가장 마지막 알람(가장 큰)의 ID 가져오기
  Future<int> getScheduleID() async {
    String sql = 'SELECT MAX(ABS(schedule_alarmID)) FROM schedule;';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    //절대값이라 항상 양수
    String ID = list[0]["MAX(ABS(schedule_alarmID))"].toString();
    int result = 0;
    if (ID != "null") {
      result = int.parse(ID);
    }

    return result;
  }

  //아직 완료되지 않은 일정 다 가져 오기
  Future<List<Scheduledto>> NotOverSchedule() async {
    String sql = 'SELECT * FROM schedule WHERE schedule_isOver =false';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList = mappingSD(list, n);

    return sdList;
  }

  //해당 월의 시작 일정 다 가져 오기
  Future<List<Scheduledto>> getMonthStartSchedules(selectedDay) async {
    String year = selectedDay.year.toString();
    String month = selectedDay.month.toString();
    String sql =
        'SELECT * FROM schedule WHERE schedule_start_year=${year} AND schedule_start_month=$month;';

    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList = mappingSD(list, n);

    return sdList;
  }

  //해당 월의 일정 다 가져 오기
  Future<List<Scheduledto>> getMonthSchedules(selectedDay) async {
    String year = selectedDay.year.toString();
    String month = selectedDay.month.toString();

    String sql =
        'SELECT * FROM schedule WHERE '
        '(schedule_start_year=$year AND schedule_start_month= $month) OR  '
        '(schedule_end_year=$year AND schedule_end_month= $month);';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList = mappingSD(list, n);

    return sdList;
  }

  //특정 일의 시작, 종료 일정 다 가져오기
  Future<List<Scheduledto>> getTodaySchedules(selectedDay) async {
    String year = selectedDay.year.toString();
    String month = selectedDay.month.toString();
    String day = selectedDay.day.toString();
    String sql = 'SELECT * FROM schedule WHERE '
        '(schedule_start_year=$year AND schedule_start_month=$month AND schedule_start_day= $day) OR  '
        '(schedule_end_year=$year AND schedule_end_month=$month AND schedule_end_day= $day);';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList = mappingSD(list, n);

    return sdList;
  }

  //이름, 날짜가 같은 일정 있나 확인
  Future<bool> checkSchedules(Scheduledto sd) async {
    String sql =
        'SELECT * FROM schedule WHERE schedule_name="${sd.schedule_name}" '
        'AND schedule_start_year="${sd.schedule_start_year}" '
        'AND schedule_start_month="${sd.schedule_start_month}" '
        'AND schedule_start_day="${sd.schedule_start_day}"';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    return list.isEmpty ? true : false;
  }

  //일정 단어로 찾기
  Future<List<Scheduledto>> findSearchByWord(String word) async {
    String sql = 'SELECT * FROM schedule WHERE schedule_name like "%$word%"';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    int n = list.length;
    List<Scheduledto> sdList = mappingSD(list, n);

    return sdList;
  }

  //sql 한 걸 SD(생성자)로 매핑
  List<Scheduledto> mappingSD(list, n) {
    List<Scheduledto> sdList = [];

    for (int i = 0; i < n; i++) {
      String alarm = list[i]["schedule_alarm"].toString().toLowerCase();

      Scheduledto sd = Scheduledto(
          int.parse(list[i]["id"].toString()),
          list[i]["schedule_name"].toString(),
          list[i]["schedule_start_year"].toInt(),
          list[i]["schedule_start_month"].toInt(),
          list[i]["schedule_start_day"].toInt(),
          list[i]["schedule_end_year"].toInt(),
          list[i]["schedule_end_month"].toInt(),
          list[i]["schedule_end_day"].toInt(),
          list[i]["schedule_alarm_hour"].toInt(),
          list[i]["schedule_alarm_minute"].toInt(),
          alarm == "true" ? true : false,
          list[i]["schedule_memo"].toString(),
          int.parse(list[i]["schedule_alarmID"].toString()));
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
        'schedule_start_year': sd.schedule_start_year,
        'schedule_start_month': sd.schedule_start_month,
        'schedule_start_day': sd.schedule_start_day,
        'schedule_end_year': sd.schedule_end_year,
        'schedule_end_month': sd.schedule_end_month,
        'schedule_end_day': sd.schedule_end_day,
        'schedule_alarm_hour': sd.schedule_alarm_hour,
        'schedule_alarm_minute': sd.schedule_alarm_minute,
        'schedule_alarm': sd.schedule_alarm,
        'schedule_memo': sd.schedule_memo,
        'schedule_isOver': false,

        'schedule_alarmID': sd.schedule_alarmID,
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

  //뽀모도로용------------------------------------------------------------------------------------------------
  //데이터 추가
  Future<void> insertPomodoroData(Dailypomodorodto dpd) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.insert(
      'dailyPomodoro', // 데이터를 추가할 테이블 이름
      {
        'DP_name': dpd.DP_name,
        'DP_date_year': dpd.DP_date_year,
        'DP_date_month': dpd.DP_date_month,
        'DP_date_day': dpd.DP_date_day,
        'DP_startTime': dpd.DP_startTime,
        'DP_endTime': dpd.DP_endTime,
        'DP_StartAlarmID': dpd.DP_StartAlarmID,
        'DP_EndAlarmID': dpd.DP_EndAlarmID,
        'DP_memo': dpd.DP_memo,
        'DP_isOver': dpd.DP_isOver
      }, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

  //선택 날짜의 뽀모도로 일정 전부 가져오기
  Future<List<Dailypomodorodto>> getToadysPomodoro(DateTime date) async {
    String sql = 'SELECT * FROM dailyPomodoro WHERE '
        'DP_date_year =${date.year} AND '
        'DP_date_month =${date.month} AND '
        'DP_date_day =${date.day};';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    List<Dailypomodorodto> dpdList = [];

    for (int i = 0; i < list.length; i++) {
      bool DP_isOver = list[i]["DP_isOver"].toString() == "0" ? false : true;
      Dailypomodorodto dpd = Dailypomodorodto(
          int.parse(list[i]["DP_id"].toString()),
          list[i]["DP_name"].toString(),
          int.parse(list[i]["DP_date_year"].toString()),
          int.parse(list[i]["DP_date_month"].toString()),
          int.parse(list[i]["DP_date_day"].toString()),
          list[i]["DP_startTime"].toString(),
          list[i]["DP_endTime"].toString(),
          int.parse(list[i]["DP_StartAlarmID"].toString()),
          int.parse(list[i]["DP_EndAlarmID"].toString()),
          list[i]["DP_memo"].toString(),
          DP_isOver);
      dpdList.add(dpd);
    }

    return dpdList;
  }

  //특정 일의 가장 마지막 알람(가장 큰)의 ID 가져오기
  Future<int> getTodayPomoStartID(DateTime date) async {
    String sql =
        'SELECT MAX(ABS(DP_StartAlarmID)) FROM dailyPomodoro WHERE '
        'DP_date_year =${date.year} AND '
        'DP_date_month =${date.month} AND '
        'DP_date_day =${date.day};';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    //절대값이라 항상 양수
    String ID = list[0]["MAX(ABS(DP_StartAlarmID))"].toString();
    int result = 0;
    if (ID != "null") {
      result = int.parse(ID);
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
        'DP_date_year': dpd.DP_date_year,
        'DP_date_month': dpd.DP_date_month,
        'DP_date_day': dpd.DP_date_day,
        'DP_startTime': dpd.DP_startTime,
        'DP_endTime': dpd.DP_endTime,
        'DP_StartAlarmID': dpd.DP_StartAlarmID,
        'DP_EndAlarmID': dpd.DP_EndAlarmID,
        'DP_memo': dpd.DP_memo,
        'DP_isOver': dpd.DP_isOver
      }, // 수정할 데이터
      where: 'DP_id = ?', // 수정할 데이터의 조건 설정
      whereArgs: [dpd.DP_id], // 수정할 데이터의 조건 값
    );
  }

  //메모용--------------------------------------------------------------------------------------------------
  //데이터 추가
  Future<void> insertMemo(String txt, DateTime date) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.insert(
      'memo', // 데이터를 추가할 테이블 이름
      {'M_txt': txt, 'M_year': date.year, 'M_month': date.month}, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

  //선택 달의 메모 가져오기
  Future<String> getMemo(DateTime date) async {
    String sql =
        'SELECT M_txt FROM memo WHERE M_year=${date.year} AND M_month =${date.month};';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);

    return list[0]["M_txt"].toString();
  }

  Future<void> updateMemo(String memo, DateTime date) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    //만약 이미 데이터가 있으면 삭제
    await deleteMemo(date);

    await db.insert(
      'memo', // 데이터를 추가할 테이블 이름
      {
        'M_txt': memo,
        'M_year': "${date.year}",
        'M_month': "${date.month}"
      }, // 추가할 데이터
      conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
    );
  }

  // 메모 삭제 메소드
  Future<void> deleteMemo(DateTime date) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    String sql =
        'delete FROM memo WHERE M_year=${date.year} AND M_month =${date.month};';
    await db.rawQuery(sql);
  }


  //검색용--------------------------------------------------------------------------------------------------
  //데이터 추가
  Future<void> insertSearch(String txt) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    if(await checkSearch(txt)){
      await db.insert(
        'search', // 데이터를 추가할 테이블 이름
        {'S_txt': txt}, // 추가할 데이터
        conflictAlgorithm: ConflictAlgorithm.replace, // 중복 데이터 처리 방법 설정
      );
    }

  }
  //검색 존재 유무
  Future<bool> checkSearch(String txt) async {
    String sql = 'SELECT * FROM search where S_txt=\'$txt\';';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    return list.isEmpty;
  }

  Future<List<String>> getSearch() async {
    List<String> result=[];
    String sql = 'SELECT S_txt FROM search;';
    final db = await database; // 데이터베이스 인스턴스 가져오기
    var list = await db.rawQuery(sql);
    for(Map m in list){
      result.add(m["S_txt"].toString());
    }
    return result;
  }

  // 검색 삭제 메소드
  Future<void> deleteSearch(String txt) async {
    final db = await database; // 데이터베이스 인스턴스 가져오기
    await db.delete(
      'search', // 삭제할 테이블 이름
      where: 'S_txt = ?', // 삭제할 데이터의 조건 설정
      whereArgs: [txt], // 삭제할 데이터의 조건 값
    );
  }


}
