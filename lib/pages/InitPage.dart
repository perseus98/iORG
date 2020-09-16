import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iorg_flutter/pages/WelcomePage.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';

class InitPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong();
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Navigator.pushNamed(context, "/welcome");
          return WelcomePage();
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return firebaseInitLoading();
      },
    );
  }

  Column somethingWentWrong() {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("Error happened while initialising"),
        ),
      ],
    );
  }

  Column firebaseInitLoading() {
    return Column(
      children: [
        progressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("Initializing Firebase App..."),
        ),
      ],
    );
  }
}
