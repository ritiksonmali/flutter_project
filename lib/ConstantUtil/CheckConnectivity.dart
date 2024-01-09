import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectivity {
  static Future<bool> checkServerStatus(String server, int port) async {
    try {
      final socket = await Socket.connect(server, port,
          timeout: const Duration(seconds: 15));
      await socket.close();
      return false;
    } catch (error) {
      return true;
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // static Future<bool> isServerResponding(String url) async {
  //   try {
  //     final response = await http.head(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (_) {
  //     return false;
  //   }
  // }
}
