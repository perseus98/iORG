import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String postName;
  final String photoUrl;
  final String priorityColor;
  final String details;
  final String timeStamp;
  final String deadline;

  PostModel({
    this.postId,
    this.postName,
    this.photoUrl,
    this.priorityColor,
    this.details,
    this.timeStamp,
    this.deadline,
  });

  factory PostModel.fromDocSnap(DocumentSnapshot doc) {
    return PostModel(
      postId: doc.id,
      details: doc.get('details'),
      photoUrl: doc.get('photoUrl'),
      priorityColor: doc.get('priorityColor'),
      postName: doc.get('postName'),
      timeStamp: doc.get('timeStamp'),
      deadline: doc.get('deadline'),
    );
  }
}
