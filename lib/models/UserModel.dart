import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String profileName;
  final String url;
  final String email;

  UserModel({
    this.id,
    this.profileName,
    this.url,
    this.email,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      email: doc.get('email'),
      url: doc.get('url'),
      profileName: doc.get('profileName'),
    );
  }

// factory UserModel.fromUser(UserCredential userCredential){
//   return UserModel(
//     id: userCredential.
//   )
// }
}
