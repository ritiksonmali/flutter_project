// ignore_for_file: prefer_function_declarations_over_variables

// import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';
import 'package:dio/dio.dart' as dio;

class LogsController {
  static final logger = (Type type) => Logger(
        printer: LogsFormat(type.toString()),
        level: Level.verbose,
      );

  static final _lock = new Lock();

  static Future<void> printLog(
      Type className, String logType, dynamic message) async {
    var now = DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var formattedDate = dateFormat.format(now);
    var logMessage = '[$logType]  $className : $message\n';

    // Save logs to file
    var logsDirectory = await getApplicationDocumentsDirectory();
    var logsFile = File('${logsDirectory.path}/logs.txt');

    await _lock.synchronized(() async {
      await logsFile.writeAsString('$formattedDate $logMessage',
          mode: FileMode.append);

      // Delete logs that are older than 10 days
      var logs = await logsFile.readAsLines();
      var tenDaysAgo = now.subtract(const Duration(days: 10));
      var filteredLogs = logs.where((log) {
        var logDate = dateFormat.parse(log.substring(0, 19));
        return logDate.isAfter(tenDaysAgo);
      }).toList();
      var lastLogMessage = filteredLogs.last;
      filteredLogs[filteredLogs.length - 1] = '$lastLogMessage\n';

      await logsFile.writeAsString(filteredLogs.join('\n'),
          mode: FileMode.write);
      // await logsFile.writeAsString(filteredLogs.join('\n'),
      //     mode: FileMode.write);
    });

    // Print logs to console
    switch (logType) {
      case 'DEBUG':
        logger(className).d(logMessage);
        break;
      case 'INFO':
        logger(className).i(logMessage);
        break;
      case 'WARNING':
        logger(className).w(logMessage);
        break;
      case 'ERROR':
        logger(className).e(logMessage);
        break;
      default:
        logger(className).v(logMessage);
        break;
    }
  }
}

class LogsFormat extends LogPrinter {
  final String className;

  LogsFormat(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;
    return [color!('$emoji $message')];
  }
}
// class LogsController {
//   static final logger = (Type type) => Logger(
//         printer: LogsFormat(type.toString()),
//         level: Level.verbose,
//       );

//   static Future<void> printLog(
//       Type className, String logType, dynamic message) async {
//     var now = DateTime.now();
//     var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     var formattedDate = dateFormat.format(now);
//     var logMessage = '[$logType]  $className : $message';

//     // if (error != null) {
//     //   logMessage += ': $error';
//     // }

//     var logger = (Type type) => Logger(
//           printer: LogsFormat(className.toString()),
//           level: Level.verbose,
//         );

//     switch (logType) {
//       case 'DEBUG':
//         logger(className).d(logMessage);
//         break;
//       case 'INFO':
//         logger(className).i(logMessage);
//         break;
//       case 'WARNING':
//         logger(className).w(logMessage);
//         break;
//       case 'ERROR':
//         // if (error != null) {
//         //   logMessage += ': $error';
//         // }
//         logger(className).e(logMessage);
//         break;
//       default:
//         logger(className).v(logMessage);
//         break;
//     }
//     // savelog(logMessage);
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/logs.txt');

//     // Append the log message to the file
//     file.writeAsString(logMessage, mode: FileMode.append);
//     // var appDocDir = await getApplicationDocumentsDirectory();
//     // var logFile = File('${appDocDir.path}/logs.txt');
//     // var logSink = logFile.openWrite(mode: FileMode.append);

//     // logSink.write('$logMessage\n');
//     // await logSink.flush();
//     // await logSink.close();

//     // await _removeOldLogs(appDocDir);
//   }

//   // static Level _getLogLevel(String logType) {
//   //   switch (logType) {
//   //     case 'debug':
//   //       return Level.debug;
//   //     case 'info':
//   //       return Level.info;
//   //     case 'warning':
//   //       return Level.warning;
//   //     case 'error':
//   //       return Level.error;
//   //     default:
//   //       return Level.verbose;
//   //   }
//   // }

//   // static Future<void> _removeOldLogs(Directory appDocDir) async {
//   //   var logFile = File('${appDocDir.path}/logs.txt');
//   //   if (!await logFile.exists()) {
//   //     return;
//   //   }

//   //   var tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
//   //   var linesToKeep = <String>[];
//   //   var logLines = await logFile.readAsLines();
//   //   var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//   //   for (var line in logLines) {
//   //     var parts = line.split(' ');
//   //     var logDate = dateFormat.parse('${parts[0]} ${parts[1]}');
//   //     if (logDate.isAfter(tenDaysAgo)) {
//   //       linesToKeep.add(line);
//   //     }
//   //   }

//   //   await logFile.writeAsString(linesToKeep.join('\n'));
//   // }
// }

// // Future<void> savelog(String message) async {
// //   final now = DateTime.now();
// //   final date = '${now.year}-${now.month}-${now.day}';
// //   final time = '${now.hour}:${now.minute}:${now.second}';
// //   final logMessage = '[$date $time] $message \n';

// //   // Get the local storage directory
// //   final directory = await getApplicationDocumentsDirectory();
// //   final file = File('${directory.path}/logs.txt');

// //   // Append the log message to the file
// //   file.writeAsString(logMessage, mode: FileMode.append);
// // }

// class LogsFormat extends LogPrinter {
//   final String className;

//   LogsFormat(this.className);

//   @override
//   List<String> log(LogEvent event) {
//     final color = PrettyPrinter.levelColors[event.level];
//     final emoji = PrettyPrinter.levelEmojis[event.level];
//     final message = event.message;
//     // final error = event.error;
//     // uploadLogs(color!('$emoji $message'));
//     return [color!('$emoji $message')];
//   }

//   // uploadLogs(String log) async {
//   //   var appDocDir = await getApplicationDocumentsDirectory();
//   //   var logFile = File('${appDocDir.path}/logs.txt');
//   //   var logSink = logFile.openWrite(mode: FileMode.append);

//   //   logSink.write('$log\n');
//   // }
// }







// class LogsController {
//   static void printLog(Type className, String logType, dynamic error) async {
//     var now = DateTime.now();
//     var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     var formattedDate = dateFormat.format(now);
//     var logIcon = _getLogIcon(logType);
//     var logMessage = '$formattedDate $logIcon [$className] $logType';
//     if (error != null) {
//       logMessage += ': $error';
//     }

//     var logger = Logger(
//       printer: PrettyPrinter(
//         methodCount: 0,
//         errorMethodCount: 10,
//         lineLength: 120,
//         colors: true,
//         printTime: false,
//         printEmojis: false,
//       ),
//     );

//     switch (logType) {
//       case 'debug':
//         logger.d(logMessage);
//         break;
//       case 'info':
//         logger.i(logMessage);
//         break;
//       case 'warning':
//         logger.w(logMessage);
//         break;
//       case 'error':
//         if (error != null) {
//           logMessage += ': $error';
//         }
//         logger.e(logMessage);
//         break;
//       default:
//         logger.v(logMessage);
//         break;
//     }

//     var appDocDir = await getApplicationSupportDirectory();
//     var logFile = File('${appDocDir.path}/myapp_logs.txt');
//     var logSink = logFile.openWrite(mode: FileMode.append);

//     logSink.write('$logMessage\n');
//     await logSink.flush();
//     await logSink.close();

//     await _removeOldLogs(appDocDir);
//   }

//   static String _getLogIcon(String logType) {
//     switch (logType) {
//       case 'debug':
//         return '🐞';
//       case 'info':
//         return 'ℹ️';
//       case 'warning':
//         return '⚠️';
//       case 'error':
//         return '❌';
//       default:
//         return '🔹';
//     }
//   }

//   static Future<void> _removeOldLogs(Directory appDocDir) async {
//     var logFile = File('${appDocDir.path}/logs.txt');
//     if (!await logFile.exists()) {
//       return;
//     }

//     var tenDaysAgo = DateTime.now().subtract(Duration(days: 10));
//     var linesToKeep = <String>[];
//     var logLines = await logFile.readAsLines();
//     var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     for (var line in logLines) {
//       var parts = line.split(' ');
//       var logDate = dateFormat.parse(parts[0] + ' ' + parts[1]);
//       if (logDate.isAfter(tenDaysAgo)) {
//         linesToKeep.add(line);
//       }
//     }

//     await logFile.writeAsString(linesToKeep.join('\n'));
//   }
// }


// final logger = (Type type) => Logger(
//       printer: LogsController(type.toString()),
//       level: Level.verbose,
//     );

// // final logger = Logger();

// class LogsController extends LogPrinter {
//   final String className;

//   LogsController(this.className);

//   @override
//   List<String> log(LogEvent event) {
//     final color = PrettyPrinter.levelColors[event.level];
//     final emoji = PrettyPrinter.levelEmojis[event.level];
//     final message = event.message;
//     final error = event.error;

//     return [color!('$emoji $className: $message,$error')];
//   }

//   static void logMessage(String code, String message, Type className) {
//     switch (code) {
//       case 'DEBUG':
//         logger.d('$code: $className $message');
//         break;
//       case 'INFO':
//         logger.i('$code: $className $message');
//         break;
//       case 'WARNING':
//         logger.w('$code: $className $message');
//         break;
//       case 'ERROR':
//         logger.e('$code: $className $message');
//         break;
//       case 'WTF':
//         logger.wtf('$code: $className $message');
//         break;
//       default:
//         throw Exception('Invalid log type');
//     }
//   }
// }
