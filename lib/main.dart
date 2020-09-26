import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/experiment.dart';
import 'package:iorg_flutter/pages/CreatePostPage.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/pages/InitPage.dart';
import 'package:statusbar/statusbar.dart';

import 'file:///C:/Users/pmhrn/AndroidStudioProjects/iorg_flutter/lib/utility/extension.dart';

final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Posted Pictures");
final postReference = FirebaseFirestore.instance.collection("posts");
final userReference = FirebaseFirestore.instance.collection("users");

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        // '/welcome': (BuildContext context) => WelcomePage(),
        '/home': (BuildContext context) => HomePage(),
        '/create': (BuildContext context) => CreatePostPage(),
        '/experiment': (BuildContext context) => ExperimentPage(),
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
