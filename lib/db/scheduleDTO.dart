class Scheduledto{
  int _schedule_id;
  String _schedule_name;
  String _schedule_start;
  String _schedule_end;
  String _schedule_time;
  bool _schedule_alarm;
  String _schedule_memo;
  int _schedule_next;

  int get schedule_next => _schedule_next;

  set schedule_next(int value) {
    _schedule_next = value;
  }

  String get schedule_name => _schedule_name;

  set schedule_name(String value) {
    _schedule_name = value;
  }

  Scheduledto(this._schedule_id, this._schedule_name, this._schedule_start, this._schedule_end,
      this._schedule_time, this._schedule_alarm, this._schedule_memo,this._schedule_next);


  int get schedule_id => _schedule_id;

  set schedule_id(int value) {
    _schedule_id = value;
  }


  String get schedule_start => _schedule_start;

  set schedule_start(String value) {
    _schedule_start = value;
  }

  String get schedule_end => _schedule_end;

  set schedule_end(String value) {
    _schedule_end = value;
  }

  String get schedule_time => _schedule_time;

  set schedule_time(String value) {
    _schedule_time = value;
  }

  bool get schedule_alarm => _schedule_alarm;

  set schedule_alarm(bool value) {
    _schedule_alarm = value;
  }

  String get schedule_memo => _schedule_memo;

  set schedule_memo(String value) {
    _schedule_memo = value;
  }


}