import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/PreviewImage.dart';
import 'package:iorg_flutter/widgets/PostWidget.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum postFields { timestamp, postName, deadline, priority }

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
  postFields _selectedPostField = postFields.timestamp;
  bool _selectedDesc = true;

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
    Query query = postReference
        .where('ownerId', isEqualTo: _currentAuthUser.uid)
        .where('archive', isEqualTo: false);

    switch (_selectedPostField) {
      case postFields.postName:
        query = query.orderBy('postName', descending: _selectedDesc);
        break;
      case postFields.deadline:
        query = query.orderBy('deadline', descending: _selectedDesc);
        break;
      case postFields.timestamp:
        query = query.orderBy('timestamp', descending: _selectedDesc);
        break;
      case postFields.priority:
        query = query.orderBy('priority', descending: _selectedDesc);
        break;
    }

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
                        archiveEntry(
                            context, querySnapshot.docs[index]['postId']);
                      }
                      if (direction == DismissDirection.endToStart) {
                        deleteEntry(
                            context, querySnapshot.docs[index]['postId']);
                      }
                    },
                    background: editBackground(),
                    secondaryBackground: deleteSecondaryBackground(),
                    child: InkWell(
                      splashColor: Colors.purple[300],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewImage(
                                    snapshot: querySnapshot.docs[index],
                                  )),
                        );
                        print("${querySnapshot.docs[index].id} clicked");
                      },
                      child: PostWidget(querySnapshot.docs[index],
                          multiSelectController.isSelected(index)),
                    ),
                  )
                  // )
                      ;
                },
              );
            }
            return Center(
              child: Text(
                "Create data to see, currently cloud is empty",
                style: TextStyle(
                    color: Colors.red
                ),
              ),
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
          height: (AppBar().preferredSize.height / 2),
          width: (AppBar().preferredSize.height / 2),
          decoration: BoxDecoration(
            color: Color(0xff7c94b6),
            image: DecorationImage(
              image: NetworkImage(
                _currentAuthUser.photoURL,
              ),
              fit: BoxFit.scaleDown,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular((AppBar().preferredSize.height / 4))),
            border: Border.all(
              color: Theme
                  .of(context)
                  .accentColor,
              width: 4.0,
            ),
          ),
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
          ? contextActions(context)
          : normalActions(context),
    );
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
            leading: Icon(
              Icons.message,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            title: Text(
              'Messages',
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/controller'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Sign Out",
              style: TextStyle(
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
            onTap: _signOutDialog,
          )
        ],
      ),
    );
  }

  List<Widget> normalActions(context) {
    return List<Widget>.from([
      IconButton(
        icon: Icon(
          Icons.sort,
          color: Theme
              .of(context)
              .accentColor,
        ),
        onPressed: () {
          // _homePageGlobalKey.currentState.showSnackBar(SnackBar(content: Text("Coming Soon"),duration: Duration(seconds: 1),));
          _showSortDialog(context);
        },
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

  Future<void> _showSortDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort List Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Select Order: '),
                ToggleSwitch(
                  cornerRadius: 20.0,
                  activeBgColor: Colors.cyan,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 1,
                  labels: ['Ascending', 'Descending'],
                  icons: [Icons.arrow_drop_up, Icons.arrow_drop_down],
                  onToggle: (index) {
                    print('switched to: $index');
                    if (index == 0) {
                      _selectedDesc = false;
                    } else {
                      _selectedDesc = true;
                    }
                  },
                ),
                Divider(color: Colors.blue,),
                Text("Select Attribute: "),
                //postFields { timestamp,postName,deadline,priority}
                ListTile(
                  title: const Text('Entry Name'),
                  leading: Radio(
                    value: postFields.postName,
                    groupValue: _selectedPostField,
                    onChanged: (postFields value) {
                      setState(() {
                        _selectedPostField = value;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Deadline Date'),
                  leading: Radio(
                    value: postFields.deadline,
                    groupValue: _selectedPostField,
                    onChanged: (postFields value) {
                      setState(() {
                        _selectedPostField = value;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Entry Creation Time'),
                  leading: Radio(
                    value: postFields.timestamp,
                    groupValue: _selectedPostField,
                    onChanged: (postFields value) {
                      setState(() {
                        _selectedPostField = value;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Priority'),
                  leading: Radio(
                    value: postFields.priority,
                    groupValue: _selectedPostField,
                    onChanged: (postFields value) {
                      setState(() {
                        _selectedPostField = value;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> contextActions(context) {
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
        activeIndex: 0,
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
        onTap: (index) {
          _bottomNavIndex = index;
          if (index == 1) {
            Navigator.pushNamed(context, '/archive');
          } else {
            setState(() {
              // Refresh State
            });
          }
        }
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
    return postReference.doc(postId).delete().then((value) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Deleted")));
      print("$postId :: ${postId.runtimeType} Deleted");
    }).catchError((error) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to delete user: $error");
    });
  }

  Future<void> archiveEntry(BuildContext context, String postId) {
    return postReference.doc(postId).update({'archive': true}).then((value) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Archived")));
      print("$postId :: ${postId.runtimeType} Archived");
    }).catchError((error) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to archive entry: $error");
    });
  }
}

Widget editBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget deleteSecondaryBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
