import 'dart:html';

import 'package:http/browser_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:server/models/models.dart';

import 'package:client/api/api.dart';

main() async {
  querySelector('#output').text = 'Your Dart app is running.';

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
      name: 'Dinner',
      message: 'Eat dinner.',
      time: new DateTime.now().add(new Duration(minutes: 10))));
      */

  /*
  await updateTimeAlarm(new TimeAlarm(
      id: '5ac275063cb32a84788d84a0',
      name: 'Dinner',
      message: 'Eat dinner.',
      time: new DateTime.now().add(new Duration(minutes: 20))));
      */

  print(await deleteTimeAlarm('5ac275063cb32a84788d84a0'));
}
