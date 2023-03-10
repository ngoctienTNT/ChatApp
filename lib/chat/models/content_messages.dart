import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';

class ContentMessages {
  int activity; //0: callDuration, 1: file, 2: image, 3: recording, 4: sticker, 5: text
  DateTime? callDuration;
  String? file;
  List<String>? image;
  String? recording;
  String? sticker;
  String? text;
  Contact? contact;

  ContentMessages({
    required this.activity,
    this.callDuration,
    this.file,
    this.image,
    this.sticker,
    this.recording,
    this.text,
    this.contact,
  });

  factory ContentMessages.fromMap(Map<String, dynamic> data) {
    Timestamp? timestamp = data["call_duration"];
    return ContentMessages(
      activity: data["activity"],
      callDuration: timestamp != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              timestamp.microsecondsSinceEpoch)
          : null,
      text: data["text"],
      sticker: data["sticker"],
      recording: data["recording"],
      file: data["file"],
      image: ((data["image"] ?? []) as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      contact: Contact(
        displayName: data["name_contact"],
        phones: [Item(value: data["phone_contact"])],
        givenName: data["name_contact"],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "activity": activity,
      "call_duration": callDuration,
      "file": file,
      "image": image,
      "sticker": sticker,
      "text": text,
      "recording": recording,
      "name_contact": contact != null ? contact!.displayName : null,
      "phone_contact": contact != null ? contact!.phones![0].value : null,
    };
  }
}
