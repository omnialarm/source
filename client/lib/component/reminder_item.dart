part of 'component.dart';

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

  DurationDisplay(Duration dur) : duration = Dur(dur);

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

  final bool shouldShowActions;

  final ValueCallback<TimeAlarm> onDelete;

  UpcomingAlarmComp(this.alarm, this.onDelete, {this.shouldShowActions: false});

  @override
  build(BuildContext context) => div([
    clazz('alarm-box'),
    div([
      clazz('alarm-box-actions'),
      clazzIf(shouldShowActions, 'show'),
      div([
        clazz('action'),
        bgImage('url(/static/img/edit.png)'),
        onClick((_) {
          // TODO
        })
      ]),
      div([
        clazz('action'),
        bgImage('url(/static/img/delete.png)'),
        onClick((_) => onDelete(alarm))
      ]),
    ]),
    div([
      clazz('alarm-holder'),
      bgColor(Theme.values[alarm.theme].color),
      div([DurationDisplay(alarm.timeLeft()), clazz('alarm-time')]),
      div([
        alarm.name,
        clazz('alarm-details'),
        onClick((_) {
          overlay = alarm;
        })
      ]),
    ]),
  ]);
}