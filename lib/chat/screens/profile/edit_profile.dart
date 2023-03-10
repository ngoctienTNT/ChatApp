import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/auth/widgets/custom_button.dart';
import 'package:chat_app/auth/widgets/gender_widget.dart';
import 'package:chat_app/auth/widgets/show_birthday.dart';
import 'package:chat_app/chat/controllers/firebase_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/chat/models/user.dart' as myuser;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});
  final myuser.User user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();
  bool gender = true;
  File? image;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    gender = widget.user.gender;
    selectedDate = widget.user.birthday!;
    nameController.text = widget.user.name;
    addressController.text = widget.user.address ?? "";
    phoneController.text = widget.user.phone ?? "";
    descriptionController.text = widget.user.description ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: const Text(
            "Account",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(90),
                onTap: () async {
                  try {
                    var pickImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickImage == null) return;
                    final cropImage = await ImageCropper().cropImage(
                        sourcePath: pickImage.path,
                        aspectRatio:
                            const CropAspectRatio(ratioX: 1, ratioY: 1),
                        aspectRatioPresets: [CropAspectRatioPreset.square]);
                    if (cropImage == null) return;
                    setState(() => image = File(cropImage.path));
                  } on PlatformException catch (_) {}
                },
                child: Stack(
                  children: [
                    ClipOval(
                      child: image == null
                          ? CachedNetworkImage(
                              imageUrl: widget.user.image!,
                              width: 170,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                // return loadingInfo(width: 150, height: 150, radius: 90);
                                return Container();
                              },
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image.file(image!, width: 170),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.circlePlus,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textProfile("Full Name"),
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    textProfile("Description"),
                    TextField(
                      controller: descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    textProfile("Address"),
                    TextField(
                      controller: addressController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    textProfile("Phone Number"),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    textProfile("Birthday"),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: showBirthday(selectedDate),
                    ),
                    const SizedBox(height: 30),
                    textProfile("Gender"),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Spacer(),
                        genderWidget(
                            currentGender: gender,
                            gender: true,
                            action: () {
                              if (!gender) {
                                setState(() => gender = true);
                              }
                            }),
                        const Spacer(),
                        genderWidget(
                            currentGender: gender,
                            gender: false,
                            action: () {
                              if (gender) {
                                setState(() => gender = false);
                              }
                            }),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      onPress: () {
                        updateInfo();
                        Navigator.pop(context);
                      },
                      text: "Save",
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future updateInfo() async {
    String avatar = widget.user.image!;
    if (image != null) {
      avatar = await uploadFile(
          image!, "avatar", "${FirebaseAuth.instance.currentUser!.uid}.png");
    }

    widget.user.image = avatar;
    widget.user.name = nameController.text;
    widget.user.description = descriptionController.text;
    widget.user.address = addressController.text;
    widget.user.phone = phoneController.text;
    widget.user.gender = gender;
    widget.user.birthday = selectedDate;

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(widget.user.toMapProfile());
  }

  Widget textProfile(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    );
  }
}
