import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:server/models/models.dart';

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
