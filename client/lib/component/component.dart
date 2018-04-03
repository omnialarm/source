import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:server/models/models.dart';

String _digits(int data, int digits) {
  final String ret = data.toString();
  if (ret.length < digits) return '0' * (digits - ret.length) + ret;
  return ret;
}

class Dur {
  Duration duration;

  Dur(this.duration);

  int get seconds => duration.inSeconds % 60;

  int get minutes => duration.inMinutes % 60;

  int get hours => duration.inHours % 24;

  int get days => duration.inDays;

  String get sAsStr => _digits(seconds, 2);

  String get mAsStr => _digits(minutes, 2);

  String get hAsStr => _digits(hours, 2);
}

class DurationDisplay implements Component {
  final Dur duration;

  DurationDisplay(Duration dur) : duration = new Dur(dur);

  @override
  build(BuildContext context) {
    if (duration.days > 5) {
      return div([
        clazz('dur-holder'),
        div([clazz('dur-fig'), duration.days]),
        div([
          clazz('dur-sub'),
          div([clazz('dur-fig'), duration.hAsStr]),
          div([clazz('dur-sep'), ':']),
          div([clazz('dur-fig'), duration.mAsStr]),
        ]),
      ]);
    }

    return div([
      clazz('dur-holder'),
      when(duration.days > 0, [
        div([clazz('dur-fig'), duration.days]),
        div([clazz('dur-sep'), ':'])
      ]),
      div([clazz('dur-fig'), duration.hAsStr]),
      div([clazz('dur-sep'), ':']),
      div([clazz('dur-fig'), duration.mAsStr]),
    ]);
  }
}

class TimedAlarmComp implements Component {
  final TimeAlarm alarm;

  TimedAlarmComp(this.alarm);

  @override
  build(BuildContext context) => div([
        clazz('alarm-holder'),
        div([alarm.name, clazz('alarm-name')]),
        div([new DurationDisplay(alarm.timeLeft()), clazz('alarm-time')]),
      ]);
}

class TimedAlarmListComp implements Component {
  final List<TimeAlarm> alarms;

  TimedAlarmListComp(this.alarms);

  @override
  build(BuildContext context) => div([
        clazz('alarms'),
        alarms.map((alarm) => new TimedAlarmComp(alarm)),
      ]);
}
