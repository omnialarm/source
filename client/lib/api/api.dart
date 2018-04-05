import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:server/models/models.dart';
import 'package:domino/html_view.dart';

Future signup(UserCreateModel user) async {
  await post('http://localhost:10000', '/api/auth').json(user).fetchResponse;
}

Future login(String username, String password) async {
  await post('http://localhost:10000', '/api/auth/login')
      .json({'username': username, 'password': password}).fetchResponse;
}

Future<TimeAlarm> addTimeAlarm(TimeAlarm alarm) async {
  return await post('http://localhost:10000', '/api/alarm/time')
      .json(alarm)
      .fetch(TimeAlarm.fromMap);
}

Future<List<TimeAlarm>> getAllTimeAlarms() async {
  return await get('http://localhost:10000', '/api/alarm/time')
      .fetchList(TimeAlarm.fromMap);
}

Future<TimeAlarm> updateTimeAlarm(TimeAlarm alarm) async {
  return await put('http://localhost:10000', '/api/alarm/time/${alarm.id}')
      .json(alarm)
      .fetch(TimeAlarm.fromMap);
}

Future<List<TimeAlarm>> deleteTimeAlarm(String id) async {
  return await delete('http://localhost:10000', '/api/alarm/time/${id}')
      .fetchList(TimeAlarm.fromMap);
}

View view;

dynamic overlay;

List<TimeAlarm> upcoming = <TimeAlarm>[];
List<TimeAlarm> expired = <TimeAlarm>[];

void splitAlarms(
    List<TimeAlarm> alarms, List<TimeAlarm> upcoming, List<TimeAlarm> expired) {
  upcoming.clear();
  expired.clear();

  for (TimeAlarm alarm in alarms) {
    if (alarm.hasExpired)
      expired.add(alarm);
    else
      upcoming.add(alarm);
  }
}

void start() {
  final timer = Timer.periodic(Duration(seconds: 30), (_) async {
    List<TimeAlarm> alarms = await getAllTimeAlarms();
    splitAlarms(alarms, upcoming, expired);
    view?.invalidate();
  });
}
