
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? username;
  final String? name;
  final String? password;
  final String? phone;
  final String? location;

  UserModel({this.username, this.name, this.password, this.phone, this.location,this.id});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot['username'],
      name: snapshot['name'],
      password: snapshot['password'],
      phone: snapshot['phone'],
      location: snapshot['location'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "name": name,
    "password": password,
    "phone": phone,
    "location" : location,
    "id": id,
  };
}