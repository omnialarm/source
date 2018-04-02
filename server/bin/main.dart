import 'package:jaguar/jaguar.dart';
import 'package:server/api/api.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main() {
  final server = new Jaguar(port: 10000);

  server.addApi(reflect(new TimedAlarmRoutes()));
  server.addApi(reflect(new AuthRoutes()));
  server.addApi(new PrefixedProxyServer('/', 'http://localhost:8000/'));

  server.log.onRecord.listen(print);
  server.serve(logRequests: true);
}
