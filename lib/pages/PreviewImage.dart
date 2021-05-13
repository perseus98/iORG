import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({Key key, this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

const double min = pi * -2;
const double max = pi * 2;

const double minScale = 0.2;
const double defScale = 0.1;
const double maxScale = 4.5;

class _PreviewImageState extends State<PreviewImage> {
  Map<String, dynamic> get post {
    // 'postId','ownerId','timestamp','image','postName','deadline','priority','details',
    return widget.snapshot.data();
  }

  PhotoViewControllerBase controller;
  PhotoViewScaleStateController scaleStateController;

  int calls = 0;

  @override
  void initState() {
    controller = PhotoViewController()
      ..scale = defScale
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);
    super.initState();
  }

  void onController(PhotoViewControllerValue value) {
    setState(() {
      calls += 1;
    });
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
  }

  @override
  void dispose() {
    controller.dispose();
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          post['postName'],
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ClipRect(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: PhotoView(
                  imageProvider: NetworkImage(
                    post['image'],
                  ),
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  filterQuality: FilterQuality.high,
                  controller: controller,
                  scaleStateController: scaleStateController,
                  enableRotation: true,
                  initialScale: minScale,
                  minScale: minScale,
                  maxScale: maxScale,
                ),
              ),
              Positioned(
                bottom: 0,
                height: 290,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: StreamBuilder(
                    stream: controller.outputStateStream,
                    initialData: controller.value,
                    builder: _streamBuild,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _streamBuild(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError || !snapshot.hasData) {
      return Container();
    }
    final PhotoViewControllerValue value = snapshot.data;
    return Column(
      children: <Widget>[
        Text(
          "Rotation ${value.rotation}",
          style: const TextStyle(color: Colors.white),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white, thumbColor: Colors.white),
          child: Slider(
            value: value.rotation.clamp(min, max),
            min: min,
            max: max,
            onChanged: (double newRotation) {
              controller.rotation = newRotation;
            },
          ),
        ),
        Text(
          "Scale ${value.scale}",
          style: const TextStyle(color: Colors.white),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: value.scale.clamp(minScale, maxScale),
            min: minScale,
            max: maxScale,
            onChanged: (double newScale) {
              controller.scale = newScale;
            },
          ),
        ),
        Text(
          "Position ${value.position.dx}",
          style: const TextStyle(color: Colors.white),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: value.position.dx,
            min: -2000.0,
            max: 2000.0,
            onChanged: (double newPosition) {
              controller.position = Offset(newPosition, controller.position.dy);
            },
          ),
        ),
        // Text(
        //   "ScaleState ${scaleStateController.scaleState}",
        //   style: const TextStyle(color: Colors.white),
        // ),
      ],
    );
  }
}
