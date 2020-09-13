import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final userReference = FirebaseFirestore.instance.collection("users");
final DateTime timeStamp = DateTime.now();
User currentUserAuth;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isSigningIn = false;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    firstTimeCheck();
    super.initState();
  }

  void firstTimeCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // Not first time
      print("Not first time");
      // shit goes from here
      loginUser();
    } else {
      // first time
      prefs.setBool('first_time', false);
      print(" first time");
    }
  }

  saveUserInfoToFirebase() async {
    DocumentSnapshot documentSnapshot =
        await userReference.doc(currentUserAuth.uid).get();
    if (!documentSnapshot.exists) {
      userReference.doc(currentUserAuth.uid).set({
        "id": currentUserAuth.uid,
        "profileName": currentUserAuth.displayName,
        "url": currentUserAuth.photoURL,
        "email": currentUserAuth.email,
        "timestamp": timeStamp,
      });
      print("New user entry added");
    }
    print("saveToFirebaseExecuted");
  }

  loginUser() {
    setState(() {
      isSigningIn = true;
    });
    signInWithGoogle().then((value) {
      currentUserAuth = value.user;
      saveUserInfoToFirebase();
      isSigningIn = false;
      Navigator.pushNamed(context, '/home');
    }).catchError((onError) {
      print("SignInErrorHandlingBlock");
      print(onError);
    });
  }

  logoutUser() async {
    await FirebaseAuth.instance.signOut();
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return somethingWentWrong();
    }
    if (!_initialized) {
      return welcomeLoading();
    }
    return isSigningIn ? welcomeLoading() : buildWelcomePage();
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
