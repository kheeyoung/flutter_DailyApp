class Dailypomodorodto{

  int _DP_id;
  String _DP_name;
  String _DP_date;
  String _DP_startTime;
  String _DP_endTime;
  //알림 설정이 안되어 있으면 -1, 되어 있으면 양수
  int _DP_StartAlarmID;
  int _DP_EndAlarmID;
  String _DP_memo;
  bool _DP_isOver;

  int get DP_id => _DP_id;

  set DP_id(int value) {
    _DP_id = value;
  }

  Dailypomodorodto(
      this._DP_id,
      this._DP_name,
      this._DP_date,
      this._DP_startTime,
      this._DP_endTime,
      this._DP_StartAlarmID,
      this._DP_EndAlarmID,
      this._DP_memo,
      this._DP_isOver);

  String get DP_name => _DP_name;

  bool get DP_isOver => _DP_isOver;

  set DP_isOver(bool value) {
    _DP_isOver = value;
  }

  String get DP_memo => _DP_memo;

  set DP_memo(String value) {
    _DP_memo = value;
  }

  int get DP_EndAlarmID => _DP_EndAlarmID;

  set DP_EndAlarmID(int value) {
    _DP_EndAlarmID = value;
  }

  int get DP_StartAlarmID => _DP_StartAlarmID;

  set DP_StartAlarmID(int value) {
    _DP_StartAlarmID = value;
  }

  String get DP_endTime => _DP_endTime;

  set DP_endTime(String value) {
    _DP_endTime = value;
  }

  String get DP_startTime => _DP_startTime;

  set DP_startTime(String value) {
    _DP_startTime = value;
  }

  String get DP_date => _DP_date;

  set DP_date(String value) {
    _DP_date = value;
  }

  set DP_name(String value) {
    _DP_name = value;
  }
}