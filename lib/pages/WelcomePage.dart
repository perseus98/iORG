import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userReference = FirebaseFirestore.instance.collection("users");
final DateTime timeStamp = DateTime.now();

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  DateTime backButtonPressedTime;
  bool firstInstance = false;
  bool signingIn = false;
  User _currentUserAuth;

  @override
  void initState() {
    print("initExecuted");
    firstTimeCheck();
    super.initState();
  }

  void firstTimeCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      print("Not first time");
      // loginUser();
    } else {
      print(" first time");
      prefs.setBool('first_time', false);
      firstInstance = true;
    }
  }

  loginUser() {
    signInWithGoogle().then((value) {
      _currentUserAuth = value.user;
      saveUserInfoToFirebase(_currentUserAuth);
      print("loginComplete");
    }).catchError((onError) {
      print("SignInErrorHandlingBlock");
      print(onError);
    });
  }

  navigateToHome() {
    Navigator.pushNamed(context, '/home');
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  saveUserInfoToFirebase(User _user) async {
    DocumentSnapshot documentSnapshot =
    await userReference.doc(_user.uid).get();
    if (!documentSnapshot.exists) {
      userReference.doc(_user.uid).set({
        "id": _user.uid,
        "profileName": _user.displayName,
        "url": _user.photoURL,
        "email": _user.email,
        "timestamp": timeStamp,
      });
      print("New user entry added");
    }
    // setState(() {
    navigateToHome();
    // });
    print("saveToFirebaseExecuted");
  }

  Future<void> executeAfterBuild() async {
    if (signingIn && _currentUserAuth != null) navigateToHome();
    // if (firstInstance) {
    //   setState(() {
    //     firstInstance = true;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserAuth != null) {
      print("build::");
      print(_currentUserAuth.displayName);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterBuild());
    if (_currentUserAuth != null) return HomePage();
    print("instance");
    print(firstInstance);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: !firstInstance
              ? buildWelcomePage()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, snapshot) {
                    Widget builderChild;
                    if (snapshot.hasError) {
                      print("Snapshot-Errors:");
                      print(snapshot.error);
                      builderChild = somethingWentWrong(snapshot.error);
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      User _user = snapshot.data;
                      if (_user == null) {
                        // Signed Out
                        builderChild = buildWelcomePage();
                      }
                      builderChild = navigateLoading();
                      // setState(() {
                      _currentUserAuth = _user;
                      // });
                      // navigateToHome(_user);
                    } else {
                      builderChild = welcomeLoading();
                    }
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: builderChild,
                    );
                  },
                ),
        ),
      )),
    );
  }

  Column buildWelcomePage() {
    return Column(
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
    );
  }

  Column somethingWentWrong(Object err) {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("Error: $err"),
        ),
      ],
    );
  }

  Column welcomeLoading() {
    return Column(
      children: [
        progressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("Initializing..."),
        ),
      ],
    );
  }

  Column navigateLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        progressIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("Setting up things..."),
        ),
      ],
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
    //Statement 1 Or statement2
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      print("inside fun");
      return false;
    }
    SystemNavigator.pop();
    print("outside fun");
    return true;
  }
}
