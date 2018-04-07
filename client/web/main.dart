import 'dart:html';
import 'dart:async';

import 'package:http/browser_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:server/models/models.dart';
import 'package:domino/html_view.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/component/component.dart';

import 'package:client/api/api.dart';

main() async {
  globalClient = http.BrowserClient();
  /*
  await signup(UserCreateModel(
      username: 'tejainece',
      email: 'tejainece@gmail.com',
      password: '1234as#'));
      */

  /*
  await login('tejainece@gmail.com', '1234as#');
  */

  /*
  await addTimeAlarm(TimeAlarm(
      name: 'Dusha',
      message: 'Take a bath you dirty bast**d.',
      time: DateTime.now().add(Duration(days: 105, hours: 2))));
      */

  /*
  await updateTimeAlarm(TimeAlarm(
      id: '5ac2726e9413e95b43fe6352',
      name: 'Dinner',
      message: 'Eat dinner.',
      time: DateTime.now().add(Duration(days: 5, hours: 2))));
      */

  (querySelector('#alarm-sound') as AudioElement).onEnded.listen((_) {
    print('here');
    if(expired.length > 0) {
      (querySelector('#alarm-sound') as AudioElement).currentTime = 0;
      (querySelector('#alarm-sound') as AudioElement).play();
    }
  });

  {
    List<TimeAlarm> alarms = await getAllTimeAlarms();
    splitAlarms(alarms, upcoming, expired);
  }

  start();

  view = registerHtmlView(querySelector('#output'), (_) {
    if (overlay == 'create') {
      return CreateAlarmComp();
    } else if (overlay is TimeAlarm) {
      return [TopBar(), ReminderView(overlay)];
    }
    return [
      TopBar(),
      div([
        clazz('content'),
        UpcomingAlarmListComp(upcoming),
        UpcomingAlarmListComp(upcoming)
      ])
    ];
  });
}
