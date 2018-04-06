import 'package:jaguar_auth/jaguar_auth.dart';
import 'package:jaguar_validate/jaguar_validate.dart';

class Theme {
  final int id;

  final String name;

  final String color;

  const Theme(this.id, this.name, this.color);

  static const List<Theme> values = [
    turquoise,
    darkRed,
    purple,
    violet,
    blue,
    cadmiumBlue,
    blueGreen,
    avacado,
    fieldDrab,
    sandDune,
    brown,
    faluRed
  ];

  static const Theme turquoise = const Theme(0, 'Turquoise', '#0e4a3f');

  static const Theme darkRed = const Theme(1, 'Dark red', '#4a0e0e');

  static const Theme purple = const Theme(2, 'Purple', '#4a0e34');

  static const Theme violet = const Theme(3, 'Violet', '#3f0e4a');

  static const Theme blue = const Theme(4, 'Blue', '#1d0e4a');

  static const Theme cadmiumBlue = const Theme(5, 'Cadmium blue', '#0e254a');

  static const Theme blueGreen = const Theme(6, 'Blue green', '#0e444a');

  static const Theme avacado = const Theme(7, 'Avacado', '#0e4a10');

  static const Theme fieldDrab = const Theme(8, 'Field drab', '#404a0e');

  static const Theme sandDune = const Theme(9, 'Sand dune', '#4a380e');

  static const Theme brown = const Theme(10, 'Brown', '#4a270e');

  static const Theme faluRed = const Theme(11, 'Falu red', '#4a0e0e');
}

class TimeAlarm {
  String id;

  DateTime time;

  String name;

  String message;

  String link;

  int theme;

  TimeAlarm(
      {this.id, this.time, this.name, this.message, this.link, this.theme});

  Map toJson() => {
        'id': id,
        'time': time.toUtc().millisecondsSinceEpoch ~/ (1000 * 60),
        'name': name,
        'message': message,
        'link': link,
        'theme': theme,
      };

  static TimeAlarm fromMap(Map map) {
    DateTime time = new DateTime.fromMillisecondsSinceEpoch(
        map['time'] * 1000 * 60,
        isUtc: true);
    time = time.toLocal();
    return new TimeAlarm(
      id: map['id'],
      time: time,
      name: map['name'],
      message: map['message'],
      link: map['link'],
      theme: map['theme'] ?? 0,
    );
  }

  Duration timeLeft() {
    final now = new DateTime.now();
    if (time.isBefore(now)) return new Duration();
    return time.difference(now);
  }

  bool get hasExpired => timeLeft().inMinutes == 0;

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
