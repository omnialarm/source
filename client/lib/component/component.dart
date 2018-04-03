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

class UpcomingAlarmComp implements Component {
  final TimeAlarm alarm;

  UpcomingAlarmComp(this.alarm);

  @override
  build(BuildContext context) => div([
        clazz('alarm-holder'),
        div([new DurationDisplay(alarm.timeLeft()), clazz('alarm-time')]),
        div([alarm.name, clazz('alarm-name')]),
      ]);
}

class UpcomingAlarmListComp implements Component {
  final List<TimeAlarm> alarms;

  UpcomingAlarmListComp(this.alarms);

  @override
  build(BuildContext context) => div([
        clazz('alarms'),
        alarms.map((alarm) => new UpcomingAlarmComp(alarm)),
      ]);
}

class TopBar implements Component {
  @override
  build(BuildContext context) {
    return div([
      clazz('topbar'),
      div([
        clazz('topbar-title-holder'),
        div([clazz('topbar-title-icon')]),
        div([
          clazz('topbar-title'),
          span([clazz('title-omni'), 'Omni']),
          span([clazz('title-alarm'), 'Alarm'])
        ]),
      ])
    ]);
  }
}
