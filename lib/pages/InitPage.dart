import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  DateTime backButtonPressedTime;
  bool _authValue = false;
  bool _manualSignIn = false;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() async {
    final prefs = await SharedPreferences.getInstance();
    _authValue = prefs.getBool('authAvail') ?? false;
    if (_authValue) {
      setState(() {});
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    if (_authValue && !_manualSignIn) {
      List<String> _authStr = new List.from(
          prefs.getStringList('authStrings') ?? new List.empty(growable: true));
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _authStr[0],
        idToken: _authStr[1],
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // print("GUser::::$googleUser");
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      // print("GAuth::::$googleAuth");
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      List<String> _authStr = new List.empty(growable: true);
      _authStr.insert(0, googleAuth.accessToken);
      _authStr.insert(1, googleAuth.idToken);
      print("_authValue added :: ${_authStr[0]} :: ${_authStr[1]}");
      prefs.setBool('authAvail', true);
      prefs.setStringList('authStrings', _authStr);
      // print('accessToken::::${googleAuth.accessToken}');
      // print('idToken::::${googleAuth.idToken}');
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    // error = something
    // loading = _initLoading
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return somethingWentWrong(
              context, "FirebaseInitErr", snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return _authValue || _manualSignIn
              ? _futureBuilder()
              : _buildIntroPage(context, _buildSignInButton());
        }
        return _buildIntroPage(context, _buildLoadingRow("Firebase App"));
      },
    );
  }

  FutureBuilder _futureBuilder() {
    return FutureBuilder(
      future: _signInWithGoogle(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return somethingWentWrong(
              context, "AuthErr", snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.user != null) {
            // print("snapshot.data.user ==> ${snapshot.data.user}");
            return HomePage();
          }
        }
        return _buildIntroPage(
            context, _buildLoadingRow("Authentication Processes"));
      },
    );
  }

  Widget _buildIntroPage(BuildContext context, Widget widget) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            height: MediaQuery
                .of(context)
                .size
                .height,
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

  Widget _buildLoadingRow(String str) {
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

  Widget _buildSignInButton() {
    return Center(
      child: SignInButton(
        Buttons.Google,
        text: "Sign up with Google",
        onPressed: () {
          setState(() {
            _manualSignIn = true;
          });
        },
      ),
    );
  }

  Widget somethingWentWrong(BuildContext context, String str, String error) {
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
          child: Text("$str :: $error"),
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
