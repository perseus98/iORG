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
    print("Archive-init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Archive-build");
    Query query = postReference
        .where('ownerId', isEqualTo: _currentAuthUser.uid)
        .where('archive', isEqualTo: true)
        .orderBy('timestamp', descending: true);
    return Scaffold(
      key: _archivePageGlobalKey,
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        // key: UniqueKey(),
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: progressWidget());
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
                      unarchiveEntry(
                          context, querySnapshot.docs[index]['postId']);
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

  Future<void> unarchiveEntry(BuildContext context, String postId) {
    return postReference.doc(postId).update({'archive': false}).then((value) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Entry Un-Archived Successfully ")));
      print("$postId :: ${postId.runtimeType} unarchived");
    }).catchError((error) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("UnArchErr:: $error")));
      print("Failed to archive entry: $error");
    });
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context)),
      backgroundColor: Colors.white,
      title: Text(
        "Archive",
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        Icon(Icons.unarchive),
      ],
    );
  }

  Widget editBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.unarchive,
              color: Colors.white,
            ),
            Text(
              " Un-Archive",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget deleteSecondaryBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
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
