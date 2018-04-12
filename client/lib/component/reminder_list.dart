part of 'component.dart';

class UpcomingAlarmListComp implements Component {
  final String title;

  final List<TimeAlarm> alarms;

  UpcomingAlarmListComp(this.alarms, this.title);

  @override
  build(BuildContext context) => div([
        clazz('alarms'),
        div([clazz('alarms-title'), title]),
        div([
          clazz('alarms-list'),
          alarms.map((alarm) => UpcomingAlarmComp(alarm, (_) async {
                List<TimeAlarm> alarms = await deleteTimeAlarm(alarm.id);
                splitAlarms(alarms, upcoming, expired);
                // TODO animate on delete
                view.invalidate();
              })),
        ]),
      ]);
}
