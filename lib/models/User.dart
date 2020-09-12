import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String url;
  final String email;

  User({
    this.id,
    this.profileName,
    this.url,
    this.email,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      email: doc.get('email'),
      url: doc.get('url'),
      profileName: doc.get('profileName'),
    );
  }
}
