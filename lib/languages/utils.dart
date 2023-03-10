import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

String fromLastSeen(Timestamp lastSeen) {
  var duration = DateTime.now().difference(lastSeen.toDate());
  int shortDuration;
  String unit;

  if (duration.inDays > 1) {
    shortDuration = duration.inDays;
    unit = 'days';
  } else if (duration.inDays == 1) {
    shortDuration = duration.inDays;
    unit = 'day';
  } 
  //
  else if (duration.inHours > 1) {
    shortDuration = duration.inHours;
    unit = 'hours';
  } else if (duration.inHours == 1) {
    shortDuration = duration.inHours;
    unit = 'hour';
  } 
  //
  else if (duration.inMinutes >= 1) {
    shortDuration = duration.inMinutes;
    unit = 'minutes';
  } else if (duration.inMinutes == 1) {
    shortDuration = duration.inMinutes;
    unit = 'minute';
  } 
  //
  else {
    shortDuration = duration.inSeconds;
    unit = shortDuration > 1 ? 'seconds' : 'second';
  }

  switch (Get.locale!.languageCode) {
    case 'en':
      return 'Active $shortDuration $unit ago';

    case 'vi':
      return 'Hoạt động $shortDuration ${unit.tr} trước';
  }
  return '$shortDuration $unit';
}
