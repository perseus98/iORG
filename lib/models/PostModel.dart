import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String postName;
  final String photoUrl;
  final String details;
  final String timeStamp;

  PostModel({
    this.postId,
    this.postName,
    this.photoUrl,
    this.details,
    this.timeStamp,
  });

  factory PostModel.fromDocSnap(DocumentSnapshot doc) {
    return PostModel(
      postId: doc.id,
      details: doc.get('details'),
      photoUrl: doc.get('photoUrl'),
      postName: doc.get('postName'),
      timeStamp: doc.get('timeStamp'),
    );
  }
}
