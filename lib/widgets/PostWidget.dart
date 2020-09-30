import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iorg_flutter/main.dart';

class PostWidget extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PostWidget(this.snapshot);

  Map<String, dynamic> get post {
    // 'postId','ownerId','timestamp','image','postName','deadline','priority','details',
    return snapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.0, bottom: 2.0),
      padding: EdgeInsets.all(5.0),
      color: returnPriorityColor(post['priority']),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: imageWidget,
          ),
          Flexible(
            flex: 2,
            child: postBody,
          ),
        ],
      ),
    );
  }

  Widget get imageWidget {
    return Container(
      child: Center(
        child: Image.network(post['image']),
      ),
    );
  }

  Widget get postBody {
    // 'postName','deadline'
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(post['postName']),
        Text(post['deadline'].toString()),
      ],
    );
  }
}

