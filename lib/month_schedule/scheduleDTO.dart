class Scheduledto{
  int _schedule_id;
  String _schedule_name;
  int _schedule_start_year;
  int _schedule_start_month;
  int _schedule_start_day;
  int _schedule_end_year;
  int _schedule_end_month;
  int _schedule_end_day;
  int _schedule_alarm_hour;
  int _schedule_alarm_minute;
  bool _schedule_alarm;
  String _schedule_memo;
  int _schedule_alarmID;

  Scheduledto(
      this._schedule_id,
      this._schedule_name,
      this._schedule_start_year,
      this._schedule_start_month,
      this._schedule_start_day,
      this._schedule_end_year,
      this._schedule_end_month,
      this._schedule_end_day,
      this._schedule_alarm_hour,
      this._schedule_alarm_minute,
      this._schedule_alarm,
      this._schedule_memo,
      this._schedule_alarmID);

  int get schedule_id => _schedule_id;

  set schedule_id(int value) {
    _schedule_id = value;
  }

  String get schedule_name => _schedule_name;

  int get schedule_alarmID => _schedule_alarmID;

  set schedule_alarmID(int value) {
    _schedule_alarmID = value;
  }


  String get schedule_memo => _schedule_memo;

  set schedule_memo(String value) {
    _schedule_memo = value;
  }

  bool get schedule_alarm => _schedule_alarm;

  set schedule_alarm(bool value) {
    _schedule_alarm = value;
  }

  int get schedule_alarm_minute => _schedule_alarm_minute;

  set schedule_alarm_minute(int value) {
    _schedule_alarm_minute = value;
  }

  int get schedule_alarm_hour => _schedule_alarm_hour;

  set schedule_alarm_hour(int value) {
    _schedule_alarm_hour = value;
  }

  int get schedule_end_day => _schedule_end_day;

  set schedule_end_day(int value) {
    _schedule_end_day = value;
  }

  int get schedule_end_month => _schedule_end_month;

  set schedule_end_month(int value) {
    _schedule_end_month = value;
  }

  int get schedule_end_year => _schedule_end_year;

  set schedule_end_year(int value) {
    _schedule_end_year = value;
  }

  int get schedule_start_day => _schedule_start_day;

  set schedule_start_day(int value) {
    _schedule_start_day = value;
  }

  int get schedule_start_month => _schedule_start_month;

  set schedule_start_month(int value) {
    _schedule_start_month = value;
  }

  int get schedule_start_year => _schedule_start_year;

  set schedule_start_year(int value) {
    _schedule_start_year = value;
  }

  set schedule_name(String value) {
    _schedule_name = value;
  }
}