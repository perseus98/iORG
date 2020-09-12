import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iorg_flutter/models/User.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final userReference = FirebaseFirestore.instance.collection("users");
final DateTime timeStamp = DateTime.now();
User currentUser;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isSignedIn = false;
  bool isSigningIn = false;

  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    firstTimeCheck();
    googleSignIn.onCurrentUserChanged.listen((googleSigninAccount) {
      controlSignIn(googleSigninAccount);
    }, onError: (gError) {
      print("Sign In Auth Err");
      print(gError);
    });
    googleSignIn
        .signInSilently(suppressErrors: false)
        .then((googleSigninAccount) {
      controlSignIn(googleSigninAccount);
    }).catchError((gError) {
      print("Sign In silently Auth Err");
      print(gError);
    });
    super.initState();
  }

  void firstTimeCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // Not first time
      print("Not first time");
      loginUser();
    } else {
      // first time
      print(" first time");
    }
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFirebase();
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveUserInfoToFirebase() async {
    final GoogleSignInAccount gCurrentAccount = googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
    await userReference.doc(gCurrentAccount.id).get();

    if (!documentSnapshot.exists) {
      userReference.doc(gCurrentAccount.id).set({
        "id": gCurrentAccount.id,
        "profileName": gCurrentAccount.displayName,
        "url": gCurrentAccount.photoUrl,
        "email": gCurrentAccount.email,
        "timestamp": timeStamp,
      });
      documentSnapshot = await userReference.doc(gCurrentAccount.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  loginUser() {
    googleSignIn.signIn();
    setState(() {
      isSigningIn = true;
    });
  }

  logoutUser() {
    googleSignIn.signOut();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return somethingWentWrong();
    }
    if (!_initialized) {
      return welcomeLoading();
    }
    return isSignedIn
        ? HomePage()
        : isSigningIn ? welcomeLoading() : buildWelcomePage();
  }

  Scaffold somethingWentWrong() {
    return Scaffold(
      body: Center(
        child: Text("INTERNET CONNECTION ERROR"),
      ),
    );
  }

  Scaffold welcomeLoading() {
    return Scaffold(
      body: Center(
        child: progressIndicator(),
      ),
    );
  }

  Scaffold buildWelcomePage() {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(
                indent: 5.0,
                endIndent: 5.0,
                thickness: 1.0,
                color: Colors.white70,
              ),
              Text(
                "Welcome to ",
                style: Theme.of(context).textTheme.headline5,
              ),
              Image.asset(
                "images/logo.png",
                fit: BoxFit.contain,
                height: 300.0,
                width: 300.0,
              ),
              Image.asset(
                "images/title.png",
                fit: BoxFit.contain,
                height: 100.0,
                width: 200.0,
              ),
              Divider(
                indent: 5.0,
                endIndent: 5.0,
                thickness: 1.0,
                color: Colors.white70,
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () {
                  loginUser();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
