import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:uuid/uuid.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with AutomaticKeepAliveClientMixin<CreatePostPage> {
  bool get wantKeepAlive => true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  final _nameController =
      TextEditingController(text: 'ENTRY_${DateTime.now().toString()}');
  final _detailsController = TextEditingController(
      text: 'This entry was created on ${DateTime.now().toString()}');
  var _priority = 1.0;
  double _progressBarValue = 0;
  bool _uploading = false;
  String postId = Uuid().v4();
  User _currentUserAuth;
  Map formVal;
  Uri _imgFilePath;

  @override
  void initState() {
    super.initState();
    _currentUserAuth = FirebaseAuth.instance.currentUser;
  }

  Stream<StorageTaskEvent> uploadImage(Uri imgFile) {
    File _tempFile = new File.fromUri(imgFile);
    StorageUploadTask storageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(_tempFile);
    return storageUploadTask.events;
  }

  double _bytesTransferred(StorageTaskSnapshot snapshot) {
    return snapshot.bytesTransferred.toDouble() /
        snapshot.totalByteCount.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("CREATE POST"),
          backgroundColor: Hexcolor("#775fad"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.restore,
                color: _uploading ? Colors.grey : Colors.white,
              ),
              onPressed: _uploading
                  ? null
                  : () {
                      _fbKey.currentState.reset();
                    },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: _uploading ? Colors.grey : Colors.white,
              ),
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate() && !_uploading)
                  setState(() {
                    _imgFilePath = _fbKey.currentState.value["image"][0].uri;
                    _uploading = true;
                  });
                print("TYpe::");
                print("Check clicked");
                // setState(() {
                //   _uploading = true;
                // });
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            buildForm(),
            _imgFilePath != null
                ? StreamBuilder(
                    stream: uploadImage(_imgFilePath),
                    builder: (context,
                        AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
                      Widget subtitle;
                      if (asyncSnapshot.hasData) {
                        final StorageTaskEvent event = asyncSnapshot.data;
                        final StorageTaskSnapshot snapshot = event.snapshot;
                        switch (event.type) {
                          case StorageTaskEventType.progress:
                            {
                              _progressBarValue = _bytesTransferred(snapshot);
                              subtitle = Text(
                                  'Event:${event.type}::${_bytesTransferred(snapshot)}');
                              print(event.type);
                            }
                            break;
                          case StorageTaskEventType.success:
                            {
                              print(
                                  'Download :: ${snapshot.ref.getDownloadURL().runtimeType}');
                              formVal = _fbKey.currentState.value;
                              postReference
                                  .doc(_currentUserAuth.uid)
                                  .collection("posts")
                                  .doc(postId)
                                  .set({
                                "postId": postId,
                                "ownerId": _currentUserAuth.uid,
                                "url": snapshot.ref.getDownloadURL(),
                                "postName": formVal["name"],
                                "deadline": formVal["deadline"],
                                "priority": formVal["priority"],
                                "description": formVal["details"],
                                "timestamp": DateTime.now(),
                              });
                              print("Task success");
                              _nameController.clear();
                              print('nameField :: ${_nameController.text}');
                              _detailsController.clear();
                              _fbKey.currentState.reset();
                              _uploading = false;
                              postId = Uuid().v4();
                              // Navigator.pushNamed(context, '/home');
                              subtitle = HomePage();
                            }
                            break;
                          default:
                        }
                      } else {
                        subtitle = Text('Starting...');
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(200, 255, 255, 255),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: _progressBarValue,
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                              backgroundColor: Colors.grey,
                              strokeWidth: 3.0,
                            ),
                            subtitle
                          ],
                        ),
                      );
                    },
                  )
                : Text(""),
          ],
        ));
  }

  ListView buildForm() {
    return ListView(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          readOnly: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FormBuilderImagePicker(
                attribute: 'image',
                imageHeight: MediaQuery.of(context).size.width * 0.90,
                imageWidth: MediaQuery.of(context).size.width * 0.90,
                imageQuality: 10,
                labelText: 'Pick a document:',
                defaultImage: NetworkImage(
                  'https://cohenwoodworking.com/wp-content/uploads/2016/09/image-placeholder-500x500.jpg',
                ),
                maxImages: 1,
                validators: [
                  FormBuilderValidators.required(),
                  (images) {
                    if (images.length <= 0) {
                      return 'Image required.';
                    }
                    return null;
                  }
                ],
              ),
              SizedBox(height: 15),
              FormBuilderTextField(
                attribute: 'name',
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name:',
                ),
                onChanged: (val) {
                  print(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                ],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 15),
              FormBuilderDateTimePicker(
                attribute: 'deadline',
                onChanged: _onChanged,
                inputType: InputType.both,
                decoration: const InputDecoration(
                  labelText: 'Deadline:',
                ),
                validator: (val) => null,
                initialTime: TimeOfDay.now(),
                initialValue: DateTime.now(),
              ),
              SizedBox(height: 15),
              FormBuilderSlider(
                attribute: 'priority',
                decoration: const InputDecoration(
                  labelText: 'Set Priority:',
                ),
                onChanged: (value) {
                  print(value);
                  setState(() {
                    _priority = value;
                  });
                },
                min: 1.0,
                max: 3.0,
                initialValue: _priority,
                divisions: 2,
                activeColor: returnPriorityColor(_priority),
                inactiveColor: Colors.pink[100],
                displayValues: DisplayValues.current,
              ),
              SizedBox(height: 15),
              FormBuilderTextField(
                attribute: 'details',
                // autovalidate: true,
                controller: _detailsController,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Details',
                ),
                onChanged: (val) {
                  print(val);
                },
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ],
    );
  }

  returnPriorityColor(double val) {
    return val == 1
        ? Colors.green
        : val == 2 ? Colors.yellow : val == 3 ? Colors.red : Colors.grey;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
