import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String postName;
  final String photoUrl;
  final String details;
  final String timeStamp;

  PostModel({
    this.id,
    this.postName,
    this.photoUrl,
    this.details,
    this.timeStamp,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      id: doc.id,
      details: doc.get('details'),
      photoUrl: doc.get('photoUrl'),
      postName: doc.get('postName'),
      timeStamp: doc.get('timeStamp'),
    );
  }
}
