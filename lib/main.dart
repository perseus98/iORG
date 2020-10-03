import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/experiment.dart';
import 'package:iorg_flutter/pages/ArchivePage.dart';
import 'package:iorg_flutter/pages/CreatePostPage.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/pages/InitPage.dart';
import 'package:statusbar/statusbar.dart';

import 'file:///C:/Users/pmhrn/AndroidStudioProjects/iorg_flutter/lib/utility/extension.dart';

import 'ControllerExample.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool usingEmulator = false;
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Posted Pictures");
final postReference = FirebaseFirestore.instance.collection("posts");
final userReference = FirebaseFirestore.instance.collection("users");

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (usingEmulator) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Hexcolor(getAccentColorHexVal()),
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Hexcolor(getAccentColorHexVal()),
  ));
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StatusBar.color(Hexcolor(getAccentColorHexVal()));
    return MaterialApp(
      title: getApplicationTitle(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Theme.of(context).colorScheme.myAccentColor,
        dialogBackgroundColor: Colors.white,
        primarySwatch: Colors.blueGrey,
        cardColor: Colors.white70,
        accentColor: Theme.of(context).colorScheme.myAccentColor,
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 15.0,
            // color: Colors.white,
            color: Theme.of(context).colorScheme.myAccentColor,
          ),
          headline5: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: TextStyle(
            fontSize: 10.0,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      initialRoute: '/init',
      routes: <String, WidgetBuilder>{
        '/init': (BuildContext context) => InitPage(),
        '/home': (BuildContext context) => HomePage(),
        '/archive': (BuildContext context) => ArchivePage(),
        '/create': (BuildContext context) => CreatePostPage(),
        '/experiment': (BuildContext context) => ExperimentPage(),
        '/controller': (BuildContext context) => ControllerExample(),
      },
    );
  }
}

String getApplicationTitle() {
  return "iORG";
}

String getAccentColorHexVal() {
  return "#8777ac";
}

returnPriorityColor(double val) {
  return val == 1
      ? Colors.green[200]
      : val == 2 ? Colors.yellow[200] : val == 3 ? Colors.red[200] : Colors
      .grey[200];
}
