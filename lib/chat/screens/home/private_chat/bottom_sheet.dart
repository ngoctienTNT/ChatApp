import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class _IconCreator extends StatelessWidget {
  const _IconCreator({required this.onTap, required this.color, required this.icon, required this.text, Key? key}) : super(key: key);
  final Function() onTap;
  final Color color;
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, size: 29, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IconCreator(
                    icon: Icons.insert_drive_file,
                    color: Colors.indigo,
                    text: "Document",
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

                      if (result != null) {
                        List<File> files = result.paths.map((path) => File(path!)).toList();
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  _IconCreator(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    text: "Camera",
                    onTap: () async {
                      try {
                        final image = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (image != null) {}
                      } on PlatformException catch (_) {}
                    },
                  ),
                  const SizedBox(width: 40),
                  _IconCreator(
                    icon: Icons.insert_photo,
                    color: Colors.purple,
                    text: "Gallery",
                    onTap: () async {
                      try {
                        List<XFile>? images = await ImagePicker().pickMultiImage();
                      } catch (_) {}
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IconCreator(
                    icon: Icons.headset,
                    color: Colors.orange,
                    text: "Audio",
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'wav', 'aac'],
                      );

                      if (result != null) {
                        List<File> files = result.paths.map((path) => File(path!)).toList();
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  _IconCreator(
                    icon: Icons.location_pin,
                    color: Colors.teal,
                    text: "Location",
                    onTap: () {},
                  ),
                  const SizedBox(width: 40),
                  _IconCreator(
                    icon: Icons.person,
                    color: Colors.blue,
                    text: "Contact",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
