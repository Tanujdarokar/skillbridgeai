import 'dart:io';

class ApiConstants {
  // Use 10.0.2.2 for Android Emulator to connect to localhost on host machine
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    } else {
      return 'http://localhost:5000/api';
    }
  }
}
