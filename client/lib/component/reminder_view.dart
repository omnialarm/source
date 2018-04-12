part of 'component.dart';

class ReminderView implements Component {
  final TimeAlarm alarm;

  ReminderView(this.alarm);

  @override
  build(BuildContext context) {
    return div(
        clazz('reminderview'),
        UpcomingAlarmComp(alarm, (_) async {
          List<TimeAlarm> alarms = await deleteTimeAlarm(alarm.id);
          splitAlarms(alarms, upcoming, expired);
          await refreshAlarms();
          view.invalidate();
        }, shouldShowActions: true),
        div(
          clazz('buttons'),
          div(clazz('button', 'blue'), 'Back', onClick((_) => refreshAlarms())),
        ));
  }
}
