import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  DateTime backButtonPressedTime;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Future<UserCredential> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    print("GUser::::$googleUser");
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print("GAuth::::$googleAuth");
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
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

  @override
  Widget build(BuildContext context) {
    // error = something
    // loading = _initLoading
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return somethingWentWrong(context, "FirebaseInitErr", snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: _signInWithGoogle(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return somethingWentWrong(context, "AuthErr", snapshot.error);
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.user != null) {
                  return HomePage();
                }
              }
              return _buildIntroPage(
                  context, _buildLoadingRow("Authentication Processes"));
            },
          );
        }
        return _buildIntroPage(context, _buildLoadingRow("Firebase App"));
      },
    );
  }

  _buildIntroPage(BuildContext context, Widget widget) {
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
                widget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildLoadingRow(String str) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        progressIndicator(),
        Expanded(
          child: Text(str),
        ),
      ],
    );
  }

  somethingWentWrong(BuildContext context, String str, Error error) {
    return buildScreen(
      context,
      [
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text("$str :: ${error.toString()}"),
        ),
      ],
    );
  }
}

Scaffold buildScreen(BuildContext context, List<Widget> _children,
    {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
  /// returns Scaffold with container with column
  return Scaffold(
    body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _children,
      ),
    ),
  );
}
