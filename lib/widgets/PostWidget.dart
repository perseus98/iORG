import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:iorg_flutter/main.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final bool isSelected;

  PostWidget(this.snapshot, this.isSelected);

  Map<String, dynamic> get post {
    // 'postId','ownerId','timestamp','image','postName','deadline','priority','details',
    return snapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    return buildMiniVersion(context);
  }

  Widget buildMiniVersion(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color:
            isSelected ? Colors.black : returnPriorityColor(post['priority']),
      ),
      // foregroundDecoration:  isSelected ? BoxDecoration(color: Colors.black) : new BoxDecoration(),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
              height: 100.0,
              width: 100.0,
              child: postImage,
            ),
          ),
          Text("  "),
          Flexible(
            flex: 3,
            child: Container(
                height: 100.0,
                color: Colors.white,
                child: postBody
            ),
          ),
        ],
      ),
    );
  }

  Widget get postImage {
    return Image.network(
      post['image'],
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null)
          return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }

  Widget get postBody {
    // 'postName','deadline'
    Timestamp deadline = post['deadline'];
    Timestamp postDate = post['timestamp'];

    String priorityLevel = (post['priority'] == 1)
        ? 'Low'
        : (post['priority'] == 2) ? 'Medium' : 'High';
    String dateDeadline = DateFormat.yMd().add_Hms().format(deadline.toDate());
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Name: ${post['postName']}'),
          Text('Deadline: $dateDeadline'),
          Text('Priority Level: $priorityLevel'),
          Text('Created: ${timeago.format(postDate.toDate())}'),
        ],
      ),
    );
  }
}

