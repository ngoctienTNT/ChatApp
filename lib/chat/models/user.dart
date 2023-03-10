import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String? image;
  String? address;
  String? phone;
  String? token;
  String? description;
  DateTime? lastSeen;
  DateTime? birthday;
  bool isActive;
  bool notify;
  bool gender;

  User({
    required this.id,
    required this.name,
    this.image,
    this.lastSeen,
    this.token,
    this.phone,
    this.address,
    this.birthday,
    this.description,
    this.isActive = true,
    this.notify = true,
    this.gender = true,
  });

  factory User.fromFirebase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id,
      name: data["name"],
      image: data["profile_picture"],
      lastSeen: DateTime.fromMicrosecondsSinceEpoch(
        (data["last_seen"] as Timestamp).microsecondsSinceEpoch,
      ),
      token: data["token"],
      isActive: data["is_active"],
      birthday: DateTime.now(),
      gender: data["gender"] ?? true,
      address: data["address"],
      phone: data["phone"],
      description: data["description"],
    );
  }

  Map<String, dynamic> toMapProfile() {
    return {
      "name": name,
      "profile_picture": image,
      "phone": phone,
      "address": address,
      "gender": gender,
      "birthday": birthday,
      "description": description,
    };
  }

  static Future<User?> getInfoUser(String id) async {
    User? user;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) async {
      user = User.fromFirebase(value);
    });
    return user;
  }
}
