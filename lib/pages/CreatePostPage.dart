import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/main.dart';
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
  String postId = Uuid().v4();
  User _currentUserAuth;
  Map formVal;
  Uri _imgFilePath;
  bool _uploading;

  @override
  void initState() {
    super.initState();
    _uploading = false;
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
    return _uploading ? _buildUploadingScreen() : Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("CREATE POST"),
          backgroundColor: Hexcolor("#775fad"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.restore,
                color: Colors.white,
              ),
              onPressed: () {
                _fbKey.currentState.reset();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate())
                  setState(() {
                    _uploading = true;
                    print("imgPath::::${_fbKey.currentState.value["image"][0]
                        .uri}");
                    print("runType::::${_fbKey.currentState.value["image"][0]
                        .runtimeType}");
                    // _imgFilePath = _fbKey.currentState.value["image"][0].uri;
                  });
                print("TYpe::");
                print("Check clicked");
              },
            ),
          ],
        ),
        body: buildForm());
  }

  _buildUploadingScreen() {
    print(
        "UploadScreen_imgPath::::${_fbKey.currentState.value["image"][0].uri}");
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text(
              "Uploading",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildForm() {
    return ListView(
      padding: EdgeInsets.all(MediaQuery
          .of(context)
          .size
          .width * 0.05),
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
