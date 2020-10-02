import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/InitPage.dart';
import 'package:iorg_flutter/widgets/PostWidget.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DateTime backButtonPressedTime;
  int _bottomNavIndex = 0;
  User _currentAuthUser;
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;
  GlobalKey<ScaffoldState> _homePageGlobalKey = GlobalKey();
  MultiSelectController multiSelectController = new MultiSelectController();

  @override
  void initState() {
    super.initState();
    _currentAuthUser = FirebaseAuth.instance.currentUser;
    multiSelectController.disableEditingWhenNoneSelected = true;

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

  void selectAll() {
    setState(() {
      multiSelectController.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentAuthUser == null) {
      return InitPage();
    }
    Query query = postReference.where(
        'ownerId', isEqualTo: _currentAuthUser.uid).orderBy(
        'timestamp', descending: true);
    print('Selected ${multiSelectController.selectedIndexes} : ');
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _homePageGlobalKey,
        appBar: _appBar(context),
        drawer: _drawer(context),
        floatingActionButton: _scaleTransition(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _animatedBottomNavigationBar(),
        body: StreamBuilder<QuerySnapshot>(
          // key: UniqueKey(),
          stream: query.snapshots(),
          builder: (context, stream) {
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: progressIndicator());
            }
            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }
            if (stream.hasData) {
              QuerySnapshot querySnapshot = stream.data;
              return ListView.builder(
                itemCount: querySnapshot.size,
                itemBuilder: (context, index) {
                  multiSelectController.set(querySnapshot.size);
                  return Dismissible(
                    key: ObjectKey(querySnapshot.docs[index]),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(
                            content: Text("Entry Archived")));
                      }
                      if (direction == DismissDirection.endToStart) {
                        String _tmpId = querySnapshot.docs[index]['postId'];
                        deleteEntry(context, _tmpId);
                      }
                    },
                    background: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Icon(
                              Icons.archive, size: 50.0, color: Colors.green,),
                          ),
                          Flexible(
                            flex: 10,
                            child: Text(""),
                          ),
                          Flexible(
                            flex: 1,
                            child: Icon(Icons.delete_outline, size: 50.0,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[100]
                      ),
                    ),
                    child: MultiSelectItem(
                      isSelecting: multiSelectController.isSelecting,
                      onSelected: () {
                        setState(() {
                          multiSelectController.toggle(index);
                          // print('Selected ${multiSelectController.selectedIndexes}');
                        });
                      },
                      child: PostWidget(querySnapshot.docs[index],
                          multiSelectController.isSelected(index), true),
                    ),
                  )
                  // PostWidget(querySnapshot.docs[index], true)
                      ;
                },
              );
            }
            return Center(
              child: Text("Create data to see, currently cloud is empty",),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: multiSelectController.isSelecting
          ? IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme
                .of(context)
                .accentColor,
          ),
          onPressed: () {
            setState(() {
              multiSelectController.deselectAll();
            });
          })
          : GestureDetector(
        onTap: () => _homePageGlobalKey.currentState.openDrawer(),
        child: Container(
          height: AppBar().preferredSize.height,
          width: AppBar().preferredSize.height,
          decoration: BoxDecoration(
            color: Color(0xff7c94b6),
            image: DecorationImage(
              image: NetworkImage(
                _currentAuthUser.photoURL,
              ),
              fit: BoxFit.scaleDown,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(AppBar().preferredSize.height / 2)),
            border: Border.all(
              color: Theme
                  .of(context)
                  .accentColor,
              width: 4.0,
            ),
          ),
          // radius: 3.0,
          // backgroundColor: Theme.of(context).accentColor,
          // backgroundImage: NetworkImage(_currentAuthUser.photoURL,),
          // onBackgroundImageError: (exception,stacktrace){
          //   print('ProfilePictureException::::$exception');
          // },
        ),
      ),
      title: Text(
        multiSelectController.isSelecting
            ? ' ${multiSelectController.selectedIndexes.length} Selected '
            : getApplicationTitle(),
        style: TextStyle(color: Theme
            .of(context)
            .accentColor),
      ),
      actions: multiSelectController.isSelecting
          ? contextActions()
          : normalActions(),
    );
  }

  List<Widget> normalActions() {
    return List<Widget>.from([
      IconButton(
        icon: Icon(
          Icons.sort,
          color: Theme
              .of(context)
              .accentColor,
        ),
        onPressed: null,
      ),
      IconButton(
        icon: Icon(
          Icons.search,
          color: Theme
              .of(context)
              .accentColor,
        ),
        onPressed: null,
      ),
    ]);
  }

  List<Widget> contextActions() {
    return List<Widget>.from([
      IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: Theme
              .of(context)
              .accentColor,
        ),
        onPressed: null,
      ),
      IconButton(
        icon: Icon(
          Icons.select_all,
          color: Theme
              .of(context)
              .accentColor,
        ),
        onPressed: selectAll,
      ),
    ]);
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            child: Text(
              getApplicationTitle(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.signOutAlt),
            title: Text("Sign Out"),
            onTap: _signOutDialog,
          )
        ],
      ),
    );
  }

  Future<void> _signOutDialog() async {
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
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('authAvail');
                prefs.remove('authStrings');
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushNamed(context, '/init');
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

  ScaleTransition _scaleTransition() {
    return ScaleTransition(
      scale: animation,
      child: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add_photo_alternate,
          color: Theme
              .of(context)
              .accentColor,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
      ),
    );
  }

  AnimatedBottomNavigationBar _animatedBottomNavigationBar() {
    return AnimatedBottomNavigationBar(
      icons: [
        Icons.dashboard,
        Icons.archive,
      ],
      backgroundColor: Colors.white,
      activeIndex: _bottomNavIndex,
      activeColor: Theme
          .of(context)
          .accentColor,
      splashColor: Hexcolor('#998abd'),
      inactiveColor: Colors.grey,
      notchAndCornersAnimation: animation,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) => setState(() => _bottomNavIndex = index),
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    //block app from quitting when selecting
    // if (multiSelectController.isSelecting) {
    //   setState(() {
    //     multiSelectController.deselectAll();
    //   });
    //   return false;
    // }

    // var before = !multiSelectController.isSelecting;
    // setState(() {
    //   multiSelectController.deselectAll();
    // });
    // return before;

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

  void changePage(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Future<void> deleteEntry(BuildContext context, String postId) {
    return postReference
        .doc(postId)
        .delete()
        .then((value) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Deleted")));
      print("Entry Deleted");
    })
        .catchError((error) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to delete user: $error");
    });
  }

  Future<void> archiveEntry(BuildContext context, String postId) {
    return postReference
        .doc(postId)
        .update({'archive': true})
        .then((value) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Archived")));
      print("Entry Archived");
    })
        .catchError((error) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to archive entry: $error");
    });
  }
}
