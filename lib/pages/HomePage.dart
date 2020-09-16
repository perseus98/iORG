import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iorg_flutter/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime backButtonPressedTime;
  int currentIndex;
  User _currentUserAuth;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _currentUserAuth = FirebaseAuth.instance.currentUser;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: _showMyDialog,
            child: CircleAvatar(
              child: _currentUserAuth != null
                  ? Image.network(
                      _currentUserAuth.photoURL,
                    )
                  : Icon(Icons.person),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(getApplicationTitle()),
          actionsIconTheme: IconThemeData(size: 10.0),
          actions: [Icon(Icons.filter_list), Icon(Icons.search)],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/create');
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).accentColor,
          ),
          label: Text(
            "Create",
            style: Theme.of(context).textTheme.button,
          ),
          elevation: 5.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Center(
          child: Text(" Homepage "),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out?'),
          content: Text('Do you want to sign out now?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushNamed(context, '/welcome');
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
      return false;
    }
    SystemNavigator.pop();
    return true;
  }
}
