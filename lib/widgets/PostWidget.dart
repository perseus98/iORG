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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
      padding: EdgeInsets.only(left: 10.0, right: 15.0, top: 5.0, bottom: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        elevation: 3.0,
        child: Container(
          padding:
              EdgeInsets.only(left: 10.0, right: 15.0, top: 20.0, bottom: 20.0),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.black,
                      border: Border.all(color: Colors.black, width: 1.0)),
                  padding: EdgeInsets.all(1.0),
                  height: 100.0,
                  width: 150.0,
                  child: postImage,
                ),
              ),
              Text("  "),
              Flexible(
                flex: 4,
                child: Container(
                    height: 100.0, color: Colors.white, child: postBody),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get postImage {
    return Image.network(
      post['image'],
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
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
        : (post['priority'] == 2)
            ? 'Medium'
            : 'High';
    String dateDeadline = DateFormat.yMd().add_Hms().format(deadline.toDate());
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            post['postName'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0),
          ),
          Text('Deadline: $dateDeadline'),
          Text("Priority: ${post['priority'].round()}"),
          Text(
            'Created: ${timeago.format(postDate.toDate())}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
