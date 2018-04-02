import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_validate/jaguar_validate.dart';

class TimeAlarm {
  String id;

  DateTime time;

  String name;

  String message;

  TimeAlarm({this.id, this.time, this.name, this.message});

  Map toJson() => {
        'id': id,
        'time': time.toUtc().millisecondsSinceEpoch ~/ (1000 * 60),
        'name': name,
        'message': message,
      };

  static TimeAlarm fromMap(Map map) => new TimeAlarm(
        id: map['id'],
        time: new DateTime.fromMillisecondsSinceEpoch(map['time'] * 1000 * 60,
            isUtc: true),
        name: map['name'],
        message: map['message'],
      );

  String toString() => toJson().toString();
}

class LocationAlarm {
  String id;

  Location location;

  int radius;

  String message;
}

class Location {
  int longitude;

  int latitude;
}

class SavedLocation {
  String name;

  Location location;
}

class User implements AuthorizationUser {
  String id;

  String username;

  String email;

  String pwdHash;

  // TODO List<SavedLocation> savedLocations;

  Map<String, TimeAlarm> timeAlarms;

  // TODO List<LocationAlarm> locationAlarm;

  User({this.id, this.username, this.email, this.pwdHash, this.timeAlarms});

  Map toJson() => {
        'id': id,
        'username': username,
      };

  @override
  String get authorizationId => id;
}

class UserCreateModel {
  String username;

  String email;

  String password;

  UserCreateModel({this.username, this.email, this.password});

  ObjectErrors validate() {
    ObjectErrors errors = new ObjectErrors();
    Validate.string
        .isNotNull()
        .isNotEmpty()
        .doesNotHaveSpace()
        .hasLengthLessThan(15)
        .startsWithAlpha()
        .matches(r'^[a-zA-Z0-9.]+$')
        .setErrors(username, 'username', errors);
    Validate.string
        .isNotNull()
        .isNotEmpty()
        .isEmail()
        .setErrors(email, 'email', errors);
    Validate.string
        .isNotNull()
        .isNotEmpty(trim: true)
        .hasLengthInRange(6, 50)
        .doesNotHaveConsecutiveRepeatedChars(2)
        .hasADigit()
        .hasAnAlphabet()
        .hasASpecialChar()
        .setErrors(password, 'password', errors);
    return errors;
  }

  Map toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };

  static UserCreateModel fromMap(Map map) => new UserCreateModel(
      username: map['username'],
      email: map['email'],
      password: map['password']);
}
