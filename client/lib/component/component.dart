import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:server/models/models.dart';

class TimedAlarmComp implements Component {
  final TimeAlarm alarm;

  TimedAlarmComp(this.alarm);

  @override
  build(BuildContext context) => div([
        clazz('alarm-holder'),
        div([alarm.name, clazz('alarm-name')]),
        div([alarm.time, clazz('alarm-time')]),
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
