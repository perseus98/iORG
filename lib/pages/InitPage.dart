import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'accounts/account_setup.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        Widget tempWidget = Text(' none ');
        if (snapshot.hasError) {
          tempWidget = Text('Firebase Init Error :: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          tempWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [progressWidget(), Text('Firebase Init Loading...')],
          );
        } else {
          return AccountSetup();
        }
        return Scaffold(
          body: Center(
            child: tempWidget,
          ),
        );
      },
    );
  }
}
