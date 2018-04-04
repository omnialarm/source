import 'dart:html' as html;
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:server/models/models.dart';
import 'package:client/api/api.dart';

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
        clazz('alarm-box'),
        div([
          clazz('alarm-box-actions'),
          div([
            clazz('action'),
            bgImage('url(/static/img/edit.png)'),
            onClick((_) {
              // TODO edit
            })
          ]),
          div([
            clazz('action'),
            bgImage('url(/static/img/delete.png)'),
            onClick((_) {
              deleteTimeAlarm(alarm.id);
              // TODO animate on delete
              // TODO refresh view
            })
          ]),
        ]),
        div([
          clazz('alarm-holder'),
          div([new DurationDisplay(alarm.timeLeft()), clazz('alarm-time')]),
          div([alarm.name, clazz('alarm-details')]),
        ]),
      ]);
}

class UpcomingAlarmListComp implements Component {
  final List<TimeAlarm> alarms;

  UpcomingAlarmListComp(this.alarms);

  @override
  build(BuildContext context) => div([
        clazz('alarms'),
        div([clazz('alarms-title'), "Upcoming"]),
        div([
          clazz('alarms-list'),
          alarms.map((alarm) => new UpcomingAlarmComp(alarm)),
        ]),
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
      ]),
      div([
        clazz('topbar-actions'),
        div(clazz('topbar-action'), '+', onClick((_) => overlay = 'create')),
      ]),
    ]);
  }
}

class CreateAlarmComp implements StatefulComponent {
  String _name = '';

  final TwoDigitEditor _hourC = new TwoDigitEditor(1, max: 24);

  final TwoDigitEditor _minuteC = new TwoDigitEditor(0, max: 59);

  @override
  build(BuildContext context) {
    return div([
      clazz('overlay'),
      div(clazz('overlay-titlebar'), span('Create reminder')),
      div([
        clazz('overlay-content'),
        div(
            clazz('overlay-row'),
            div(clazz('overlay-label'), 'Do'),
            textInput(clazz('overlay-text-input'), #name, onKeyPress((Event e) {
              _name = (e.element as html.TextInputElement).value;
            }))),
        div(
            clazz('overlay-row'),
            div(clazz('overlay-label'), 'In'),
            div(clazz('duration-composite'), _hourC,
                div(clazz('twodigitedit-holder'), span(':')), _minuteC)),
        div(
          clazz('buttons'),
          div(clazz('button', 'green'), 'Create', onClick(
            (_) async {
              await addTimeAlarm(new TimeAlarm(
                  name: _name,
                  time: new DateTime.now().add(new Duration(
                      hours: _hourC.value, minutes: _minuteC.value))));
            },
          )),
          div(clazz('button', 'red'), 'Close', onClick(
            (_) {
              overlay = null;
            },
          )),
        )
      ]),
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is CreateAlarmComp) {
      _name = previous._name;
    }
    return null;
  }
}

class TwoDigitEditor implements StatefulComponent {
  int value = 0;

  final int max;

  TwoDigitEditor(this.value, {this.max: 100});

  @override
  build(BuildContext context) {
    return div(clazz('twodigitedit-holder'), attr('tabIndex', '0'),
        onKeyDown((Event e) {
      html.KeyboardEvent ke = e.event;
      if (ke.keyCode >= 48 && ke.keyCode <= 57) {
        value = value * 10 + (ke.keyCode - 48);
        value %= 100;

        if (value > max) value %= 10;
      } else if (ke.keyCode == html.KeyCode.UP) {
        value++;
        value %= 100;

        if (value > max) value %= 10;
      } else if (ke.keyCode == html.KeyCode.DOWN) {
        if (value > 0) value--;
        value %= 100;

        if (value > max) value %= 10;
      }
    }), span(clazz('number'), _1(value)), span(clazz('number'), _0(value)));
  }

  @override
  Component restoreState(Component previous) {
    if (previous is TwoDigitEditor) value = previous.value;
    return this;
  }
}

String _0(int value) => (value % 10).toString();

String _1(int value) => ((value ~/ 10) % 10).toString();
