import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';

import '../models/models.dart';

MongoDb mongodb(Context ctx) =>
    new MongoDb('mongodb://localhost:27017/omnilarm');

/// The authenticator
JsonAuth jsonAuth(Context ctx) => new JsonAuth(userManager);

/// The authorizor
Authorizer authorizor(Context ctx) => new Authorizer(userManager);

UserAccess accessFromCtx(Context ctx) =>
    new UserAccess(ctx.getInterceptorResult(MongoDb));

class UserAccess {
  final Db db;

  UserAccess(this.db);

  List<TimeAlarm> _decodeTimeAlarmList(List<Map> list) =>
      (list ?? []).map(_decodeTimeAlarm).toList();

  TimeAlarm _decodeTimeAlarm(Map map) => TimeAlarm.fromMap(map);

  User _decodeUser(Map map) => new User(
      id: (map['_id'] as ObjectId).toHexString(),
      username: map['username'],
      email: map['email'],
      pwdHash: map['pwdHash'],
      timeAlarms: map['timeAlarms']);

  Future<String> createUser(UserCreateModel user) async {
    final id = new ObjectId();
    await db.collection('usr').insert({
      '_id': id,
      'username': user.username,
      'email': user.email,
      'pwdHash': user.password,
    });
    return id.toHexString();
  }

  Future<User> getUser(String userId) async {
    Map map = await db
        .collection('usr')
        .findOne(where.id(new ObjectId.fromHexString(userId)));
    return _decodeUser(map);
  }

  Future<User> getUserByEmail(String email) async {
    Map map = await db.collection('usr').findOne(where.eq('email', email));
    return _decodeUser(map);
  }

  Future upsertTimeAlarm(String userId, TimeAlarm alarm) async {
    await db.collection('usr').update(
        where.id(new ObjectId.fromHexString(userId)),
        modify.set('timeAlarms.${alarm.id}', alarm.toJson()));
  }

  Future removeTimeAlarm(String userId, String alarmId) async {
    await db.collection('usr').update(
        where.id(new ObjectId.fromHexString(userId)),
        modify.unset('timeAlarms.${alarmId}'));
  }

  Future<List<TimeAlarm>> getTimeAlarms(String userId) async {
    Map map = await db.collection('usr').findOne(
        where.id(new ObjectId.fromHexString(userId)).fields(['timeAlarms']));
    return _decodeTimeAlarmList((map['timeAlarms'] as Map).values.toList());
  }

  Future<TimeAlarm> getTimeAlarm(String userId, String alarmId) async {
    Map map = await db.collection('usr').findOne(
        where.id(new ObjectId.fromHexString(userId)).fields(['timeAlarms']));
    return _decodeTimeAlarm((map['timeAlarms'][alarmId]));
  }
}

/// This route group contains login and logout routes
@Api(path: '/api/auth')
@WrapOne(mongodb)
class AuthRoutes {
  @PostJson(path: '/login')
  @WrapOne(jsonAuth)
  User login(Context ctx) {
    final User user = ctx.getInterceptorResult<User>(JsonAuth);
    return user;
  }

  @Post(path: '/logout')
  @WrapOne(authorizor)
  Future logout(Context ctx) async {
    // Clear session data
    (await ctx.session).clear();
  }

  @Post()
  Future signup(Context ctx) async {
    UserCreateModel user =
        await ctx.req.bodyAsJson(convert: UserCreateModel.fromMap);
    final errors = user.validate();
    if (errors.hasErrors) throw Response.json(errors, statusCode: 400);
    user.password = hasher.hash(user.password);
    UserAccess access = accessFromCtx(ctx);
    String newId = await access.createUser(user);
    // TODO
  }
}

@Api(path: '/api/alarm/time')
@Wrap(const [mongodb, authorizor])
class TimedAlarmRoutes {
  @PostJson()

  /// Creates new alarm
  Future<TimeAlarm> create(Context ctx) async {
    final User user = ctx.getInterceptorResult<User>(Authorizer);
    TimeAlarm alarm = await ctx.req.bodyAsJson(convert: TimeAlarm.fromMap);
    String id = new ObjectId().toHexString();
    alarm.id = id;
    UserAccess access = accessFromCtx(ctx);
    await access.upsertTimeAlarm(user.id, alarm);
    return access.getTimeAlarm(user.id, id);
  }

  @PutJson(path: '/:id')

  /// Creates new alarm
  Future<TimeAlarm> update(Context ctx) async {
    final User user = ctx.getInterceptorResult<User>(Authorizer);
    String id = ctx.pathParams['id'];
    TimeAlarm alarm = await ctx.req.bodyAsJson(convert: TimeAlarm.fromMap);
    alarm.id = id;
    UserAccess access = accessFromCtx(ctx);
    await access.upsertTimeAlarm(user.id, alarm);
    return access.getTimeAlarm(user.id, id);
  }

  @DeleteJson(path: '/:id')

  /// Removes an alarm by 'id'
  Future<List<TimeAlarm>> remove(Context ctx) async {
    final User user = ctx.getInterceptorResult<User>(Authorizer);
    String id = ctx.pathParams['id'];
    UserAccess access = accessFromCtx(ctx);
    await access.removeTimeAlarm(user.id, id);
    return access.getTimeAlarms(user.id);
  }

  @GetJson()

  /// Returns an alarm by 'id'
  Future<List<TimeAlarm>> getAll(Context ctx) async {
    final User user = ctx.getInterceptorResult<User>(Authorizer);
    UserAccess access = accessFromCtx(ctx);
    return access.getTimeAlarms(user.id);
  }

  @GetJson(path: '/:id')

  /// Returns an alarm by 'id'
  Future<TimeAlarm> get(Context ctx) async {
    final User user = ctx.getInterceptorResult<User>(Authorizer);
    String id = ctx.pathParams['id'];
    UserAccess access = accessFromCtx(ctx);
    return access.getTimeAlarm(user.id, id);
  }
}

Sha256Hasher hasher =
    new Sha256Hasher('dfgdgre64564356desrgdsg4356sfhgjfdgtgq354wtsgdsaewe');

const UserManager userManager = const UserManager();

/// Fetcher to aid authorization and authentication
class UserManager implements AuthModelManager<User> {
  const UserManager();

  Future<User> authenticate(
      Context ctx, String username, String password) async {
    User model = await fetchByAuthenticationId(ctx, username);
    if (model == null) return null;
    if (!hasher.verify(model.pwdHash, password)) return null;
    return model;
  }

  Future<User> fetchByAuthenticationId(Context ctx, String authName) async {
    UserAccess access = accessFromCtx(ctx);
    return access.getUserByEmail(authName);
  }

  Future<User> fetchByAuthorizationId(Context ctx, String sessionId) async {
    UserAccess access = accessFromCtx(ctx);
    return access.getUser(sessionId);
  }
}
