import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iorg_flutter/widgets/PostWidget.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';

import '../main.dart';
import 'HomePage.dart';
import 'PreviewImage.dart';

class ArchivePage extends StatefulWidget {
  ArchivePage({Key key}) : super(key: key);

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  GlobalKey<ScaffoldState> _archivePageGlobalKey = GlobalKey();
  User _currentAuthUser;

  @override
  void initState() {
    _currentAuthUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Query query = postReference
        .where('ownerId', isEqualTo: _currentAuthUser.uid)
        .where('archive', isEqualTo: true)
        .orderBy('timestamp', descending: true);
    return Scaffold(
      key: _archivePageGlobalKey,
      appBar: _appBar(),
      body: StreamBuilder<QuerySnapshot>(
        // key: UniqueKey(),
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: progressIndicator());
          }
          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }
          if (stream.hasData) {
            QuerySnapshot querySnapshot = stream.data;
            return ListView.builder(
              itemCount: querySnapshot.size,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ObjectKey(querySnapshot.docs[index]),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Entry Un-Archived")));
                    }
                    if (direction == DismissDirection.endToStart) {
                      String _tmpId = querySnapshot.docs[index]['postId'];
                      deleteEntry(context, _tmpId);
                    }
                  },
                  background: editBackground(),
                  secondaryBackground: deleteSecondaryBackground(),
                  child: InkWell(
                    splashColor: Colors.purple[300],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewImage(
                                  snapshot: querySnapshot.docs[index],
                                )),
                      );
                      print("${querySnapshot.docs[index].id} clicked");
                    },
                    child: PostWidget(querySnapshot.docs[index], false),
                  ),
                )
                    // )
                    ;
              },
            );
          }
          return Center(
            child: Text(
              "Create data to see, currently cloud is empty",
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme
                .of(context)
                .accentColor,
          ),
          onPressed: () => Navigator.pop(context)
      ),
      backgroundColor: Colors.white,
      title: Text(
        "Archive",
        style: TextStyle(color: Theme
            .of(context)
            .accentColor),
      ),
      actions: [
        Icon(Icons.unarchive),
      ],

    );
  }

  Future<void> deleteEntry(BuildContext context, String postId) {
    return postReference.doc(postId).delete().then((value) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Deleted")));
      print("Entry Deleted");
    }).catchError((error) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to delete user: $error");
    });
  }

}
