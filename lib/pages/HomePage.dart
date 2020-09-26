import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/LoggedOut.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DateTime backButtonPressedTime;
  User _currentUserAuth;
  int _bottomNavIndex = 0;

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    _currentUserAuth = FirebaseAuth.instance.currentUser;
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  void changePage(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: _showMyDialog,
            child: CircleAvatar(
              child: _currentUserAuth != null
                  ? Image.network(
                      _currentUserAuth.photoURL,
                      fit: BoxFit.fill,
                    )
                  : Icon(Icons.person),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            getApplicationTitle(),
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              color: Theme.of(context).accentColor,
              onPressed: () => Navigator.pushNamed(context, '/experiment'),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              color: Theme.of(context).accentColor,
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            ),
          ],
        ),
        floatingActionButton: ScaleTransition(
          scale: animation,
          child: FloatingActionButton(
            elevation: 8,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add_photo_alternate,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [
            Icons.dashboard,
            Icons.archive,
          ],
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          activeColor: Theme.of(context).accentColor,
          splashColor: Hexcolor('#998abd'),
          inactiveColor: Colors.grey,
          notchAndCornersAnimation: animation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
        body: Center(
          child: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                print('GUserHM::::${GoogleSignIn().isSignedIn()}');
                if (await GoogleSignIn().isSignedIn()) {
                  await GoogleSignIn().signOut();
                  print("GSignOUT");
                } else {
                  print("Didn'tGSignOUT");
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoggedOut()));
              }),
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
                // await FirebaseAuth.instance.signOut();
                // await GoogleSignIn().signOut();
                // Navigator.pushNamed(context, '/welcome');
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

    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
        msg: "Double Click to exit app",
        backgroundColor: Colors.white,
        textColor: Hexcolor(getAccentColorHexVal()),
      );
      return false;
    }
    SystemNavigator.pop();
    return true;
  }
}
