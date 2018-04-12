import 'dart:html';
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

  AudioElement audio = querySelector('#alarm-sound');

  if (expired.length > 0) {
    if (audio.paused) audio.play();

    for (TimeAlarm al in expired) {
      final notification =
          new Notification('OmniAlarm', body: al.name, tag: al.id); // TODO icon
      notification.onClick.listen((e) {
        print(e.type);
        // TODO window.focus();
      });
      // TODO action to delete notification?
    }
  } else {
    audio.pause();
    audio.currentTime = 0;
  }
}

void start() {
  final timer = Timer.periodic(Duration(seconds: 15), (_) async {
    List<TimeAlarm> alarms = await getAllTimeAlarms();
    splitAlarms(alarms, upcoming, expired);
    view?.invalidate();
  });
}

Future refreshAlarms() async {
  List<TimeAlarm> alarms = await getAllTimeAlarms();
  splitAlarms(alarms, upcoming, expired);
  overlay = null;
}
