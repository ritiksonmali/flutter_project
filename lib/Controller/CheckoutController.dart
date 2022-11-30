import 'package:easy_localization/easy_localization.dart';

class CheckOutController {
  DateTime now = DateTime.now();
  String now1 = DateFormat('hh:mm:ss').format(DateTime.now());

  List listItemSorting = [
    '09:00',
    '02:00',
    '05:00',
    '08:00',
  ];

  List newlist = [];

  compareTimes() {
    var regex = new RegExp(':'),
        timeStr1 = '10:00:00',
        timeStr2 = now1,
        timeStr3 = '15:00:00',
        timeStr4 = '18:00:00';
    if (int.parse(timeStr1.replaceAll(regex, '')) <
        int.parse(timeStr2.replaceAll(regex, ''))) {
      print('timeStr1 is smaller then timeStr2');
      newlist = ['09:00'];
    } else {
      print('timeStr2 is smaller then timeStr1');
    }
  }
}
