import 'dart:html';

import 'package:http/browser_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:server/models/models.dart';
import 'package:domino/html_view.dart';
import 'package:client/component/component.dart';

import 'package:client/api/api.dart';

main() async {
  globalClient = new http.BrowserClient();
  /*
  await signup(new UserCreateModel(
      username: 'tejainece',
      email: 'tejainece@gmail.com',
      password: '1234as#'));
      */

  /*
  await login('tejainece@gmail.com', '1234as#');
  */

  /*
  await addTimeAlarm(new TimeAlarm(
      name: 'Dusha',
      message: 'Take a bath you dirty bast**d.',
      time: new DateTime.now().add(new Duration(days: 105, hours: 2))));
      */

  /*
  await updateTimeAlarm(new TimeAlarm(
      id: '5ac2726e9413e95b43fe6352',
      name: 'Dinner',
      message: 'Eat dinner.',
      time: new DateTime.now().add(new Duration(days: 5, hours: 2))));
      */

  List<TimeAlarm> alarms = await getAllTimeAlarms();

  registerHtmlView(querySelector('#output'), new TimedAlarmListComp(alarms));
}
