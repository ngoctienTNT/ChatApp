import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFile(File file, String folder, String name) async {
  Reference upload = FirebaseStorage.instance.ref().child("$folder/$name");
  await upload.putFile(file);
  return await upload.getDownloadURL();
}
