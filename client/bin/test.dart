import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:server/models/models.dart';

import 'package:client/api/api.dart';

main() async {
  globalClient = new http.IOClient();
  await signup(new UserCreateModel(
      username: 'tejainece', email: 'tejainece@gmail.com', password: '1234as#'));
}
