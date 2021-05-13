import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:i_org/main.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'HomePage.dart';

enum PictureMode { camera, gallery }

class CreatePostPage extends StatefulWidget {
  CreatePostPage({Key key}) : super(key: key);
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with AutomaticKeepAliveClientMixin<CreatePostPage> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  //    id, owner, title, description, location, phoneNo, postStatus, imageUrl;

  final ImagePicker _picker = ImagePicker();
  final _uploadFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _createPageGlobalKey =
      GlobalKey<ScaffoldState>();
  // final GlobalKey<FormBuilderState> _createFormBuilderGlobalKey =
  //     GlobalKey<FormBuilderState>();
  bool get wantKeepAlive => true;
  final ValueChanged _onChanged = (val) => print(val);
  final _nameController = TextEditingController(
      text: 'ENTRY_${DateTime.now().microsecondsSinceEpoch}');
  final _detailsController = TextEditingController(
      text:
          'This entry was created on ${DateTime.now().microsecondsSinceEpoch}');
  var _priority = 1.0;
  // double _progressBarValue = 0;
  String postId = Uuid().v4();
  User _currentUserAuth;
  bool _uploading;
  Map<String, dynamic> mapData;
  double prioritySliderValue = 0;
  final titleTextEditingController = TextEditingController();
  final detailsTextEditingController = TextEditingController();
  final dateTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _uploading = false;
    _currentUserAuth = FirebaseAuth.instance.currentUser;
    print("Create-init");
  }

  Stream<TaskSnapshot> uploadImage(Uri imgFile) {
    File _tempFile = new File.fromUri(imgFile);
    UploadTask storageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(_tempFile);
    return storageUploadTask.snapshotEvents;
  }

  double _bytesTransferredInPercentage(TaskSnapshot snapshot) {
    return snapshot.bytesTransferred * 100 / snapshot.totalBytes;
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 400.0,
        maxHeight: 400.0,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Create-build");
    return _uploading
        ? _buildUploadingScreen()
        : Scaffold(
            key: _uploadFormKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text("CREATE ENTRY"),
              backgroundColor: Color.fromARGB(255, 135, 119, 172),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.restore,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _uploadFormKey.currentState.reset();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_uploadFormKey.currentState.validate())
                      mapData = new Map<String, dynamic>.from({});

                    setState(() {
                      _uploading = true;
                    });
                    print("Check clicked");
                  },
                ),
              ],
            ),
            body: buildForm());
  }

  _buildUploadingScreen() {
    return StreamBuilder(
      stream: uploadImage(mapData["image"][0].uri),
      builder: (context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        double _uploadProgress = 0.0;
        String _uploadDetails = "Uploading, Please wait...";
        // Widget subtitle = Text("");
        if (asyncSnapshot.hasError) {
          return buildUploadErrorHandler(asyncSnapshot.error);
        }
        if (asyncSnapshot.hasData) {
          final TaskSnapshot event = asyncSnapshot.data;
          switch (event.state) {
            case TaskState.running:
              {
                // setState(() {
                //   _progressBarValue = _bytesTransferred(snapshot);
                // });
                // _progressBarValue = _bytesTransferred(snapshot);
                _uploadProgress = _bytesTransferredInPercentage(event);
                _uploadDetails = "Upload Progress : $_uploadProgress %";
                print("uploadProgress::::$_uploadProgress");
              }
              break;
            case TaskState.error:
              print("uploadTaskFailed");
              break;
            case TaskState.success:
              {
                if (mapData.isEmpty) {
                  print(" mapDAta :: null");
                } else {
                  event.ref.getDownloadURL().then((downloadURL) {
                    print('picUrl == $downloadURL');
                    // postReference
                    //     .doc(postId)
                    //     .set({
                    //       "postId": postId,
                    //       "ownerId": _currentUserAuth.uid,
                    //       "timestamp": DateTime.now(),
                    //       "image": downloadURL,
                    //       "postName": mapData[
                    //           'name'], // name, details, deadline, priority,
                    //       "deadline": mapData['deadline'],
                    //       "priority": mapData['priority'],
                    //       "details": mapData['details'],
                    //       'archive': false,
                    //     })
                    //     .then((value) => print("Post Added"))
                    //     .catchError(
                    //         (error) => print("Failed to add post: $error"));
                  });
                  print("Cloud Save executed");
                  return HomePage(_currentUserAuth);
                }
              }
              break;
            default:
          }
        } else {
          _uploadDetails = "Starting Upload Process";
          // subtitle = Text('Starting...');
        }
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromARGB(200, 255, 255, 255),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  // value: _progressBarValue,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  backgroundColor: Colors.grey,
                  strokeWidth: 3.0,
                ),
                Flexible(
                  child: Text(
                    _uploadDetails,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildForm() {
    return ListView(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      children: <Widget>[
        Form(
            child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: "Enter Title"),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Enter Details"),
            ),
            TextFormField(
              enabled: false,
              onTap: () {
                print("Deadline Field clicked");
              },
              decoration: InputDecoration(hintText: "Enter Title"),
            ),
            Slider(
              value: prioritySliderValue,
              min: 1,
              max: 3,
              divisions: 2,
              label: prioritySliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  prioritySliderValue = value;
                });
              },
            )
          ],
        ))
      ],
    );
  }

  buildUploadErrorHandler(Error err) {
    return Scaffold(
      body: Center(
        child: Expanded(
            child: Text(
          "UploadErr::::$err",
          style: TextStyle(fontSize: 50, color: Colors.white),
        )),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
