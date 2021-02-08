import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/PreviewImage.dart';
import 'package:iorg_flutter/widgets/PostWidget.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage(this.user, {Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

enum postFields { timestamp, postName, deadline, priority }

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _homePageGlobalKey = GlobalKey<ScaffoldState>();

  DateTime backButtonPressedTime;
  User _currentAuthUser;
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;
  postFields _selectedPostField = postFields.timestamp;
  bool _selectedDesc = true;

  @override
  void initState() {
    super.initState();
    _currentAuthUser = FirebaseAuth.instance.currentUser;
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
    print("Home-init");
  }

  @override
  Widget build(BuildContext context) {
    print("Home-build");
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

    return Scaffold(
      key: _homePageGlobalKey,
      appBar: _appBar(context),
      drawer: _drawer(context),
      // floatingActionButton: _scaleTransition(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: _animatedBottomNavigationBar(),
      body: WillPopScope(
        onWillPop: () => onWillPop(_homePageGlobalKey),
        child: StreamBuilder<QuerySnapshot>(
          // key: UniqueKey(),
          stream: query.snapshots(),
          builder: (context, stream) {
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: progressWidget());
            }
            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }
            if (stream.hasData) {
              QuerySnapshot querySnapshot = stream.data;
              return ListView.builder(
                itemCount: querySnapshot.size,
                itemBuilder: (context, index) {
                  // multiSelectController.set(querySnapshot.size);
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
                      child: PostWidget(querySnapshot.docs[index], false),
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
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
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
              Icons.archive,
              color: Colors.white,
            ),
            Text(
              " Archive ",
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => _homePageGlobalKey.currentState.openDrawer(),
        child: Container(
          height: (AppBar().preferredSize.height / 2),
          width: (AppBar().preferredSize.height / 2),
          decoration: BoxDecoration(
            color: Color(0xff7c94b6),
            // image: DecorationImage(
            //   image: NetworkImage(
            //     _currentAuthUser.photoURL,
            //   ),
            //   fit: BoxFit.scaleDown,
            // ),
            borderRadius: BorderRadius.all(
                Radius.circular((AppBar().preferredSize.height / 4))),
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 4.0,
            ),
          ),
        ),
      ),
      title: Text(
        'iORG',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      actions: normalActions(context),
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            child: Text(
              'iORG',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _listTile(Icon(Icons.border_color), 'Bottom Bar Example',
              '/bottomBarExample'),
          _listTile(Icon(Icons.image), 'Image Preview Example', '/controller'),
          AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationIcon: Image.asset(
              'images/logo.png',
            ),
            applicationName: 'iORG',
            applicationVersion: '0.1.3',
            applicationLegalese: ' Copyright @ sud3shi',
            aboutBoxChildren: [
              Text(
                "This application is developed under the name of sud3shi,",
                style: TextStyle(fontSize: 10.0),
              ),
              Text(
                "Credits:",
                style: TextStyle(fontSize: 10.0),
              ),
              Text(
                "Mulchand Sahu(layout)",
                style: TextStyle(fontSize: 10.0),
              ),
              Text(
                "Pramod Vishwakarma(research)",
                style: TextStyle(fontSize: 10.0),
              ),
              Text(
                "Prashant Maharana(app dev)",
                style: TextStyle(fontSize: 10.0),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Sign Out",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            onTap: _signOutDialog,
          )
        ],
      ),
    );
  }

  ListTile _listTile(Icon icon, String _name, String _path) {
    return ListTile(
      leading: IconButton(
        icon: icon,
        color: Theme.of(context).accentColor,
        onPressed: () => Navigator.pushNamed(context, _path),
      ),
      title: Text(
        _name,
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  List<Widget> normalActions(context) {
    return List<Widget>.from([
      IconButton(
        icon: Icon(
          Icons.sort,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          // _homePageGlobalKey.currentState.showSnackBar(SnackBar(content: Text("Coming Soon"),duration: Duration(seconds: 1),));
          _showSortDialog(context);
        },
      ),
      IconButton(
        icon: Icon(
          Icons.search,
          color: Theme.of(context).accentColor,
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
                Divider(
                  color: Colors.blue,
                ),
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
          color: Theme.of(context).accentColor,
        ),
        onPressed: null,
      ),
      IconButton(
        icon: Icon(
          Icons.select_all,
          color: Theme.of(context).accentColor,
        ),
        onPressed: null,
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
                // final prefs = await SharedPreferences.getInstance();
                // prefs.remove('authAvail');
                // prefs.remove('authStrings');
                await FirebaseAuth.instance.signOut();
                // await GoogleSignIn().signOut();
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

  // ScaleTransition _scaleTransition() {
  //   return ScaleTransition(
  //     scale: animation,
  //     child: FloatingActionButton(
  //       elevation: 8,
  //       backgroundColor: Colors.white,
  //       child: Icon(
  //         Icons.add_photo_alternate,
  //         color: Theme
  //             .of(context)
  //             .accentColor,
  //       ),
  //       onPressed: () {
  //         Navigator.pushNamed(context, '/create');
  //       },
  //     ),
  //   );
  // }

  // AnimatedBottomNavigationBar _animatedBottomNavigationBar() {
  //   return AnimatedBottomNavigationBar(
  //       icons: [
  //         Icons.dashboard,
  //         Icons.archive,
  //       ],
  //       backgroundColor: Colors.white,
  //       activeIndex: 0,
  //       activeColor: Theme
  //           .of(context)
  //           .accentColor,
  //       splashColor: Hexcolor('#998abd'),
  //       inactiveColor: Colors.grey,
  //       notchAndCornersAnimation: animation,
  //       splashSpeedInMilliseconds: 300,
  //       notchSmoothness: NotchSmoothness.defaultEdge,
  //       gapLocation: GapLocation.center,
  //       leftCornerRadius: 32,
  //       rightCornerRadius: 32,
  //       onTap: (index) {
  //         if (index == 1) {
  //           Navigator.pushNamed(context, '/archive');
  //         } else {
  //           setState(() {
  //             // Refresh State
  //           });
  //         }
  //       }
  //   );
  // }

  Future<bool> onWillPop(GlobalKey<ScaffoldState> scaffoldKey) async {
    DateTime currentTime = DateTime.now();

    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Press back again to exit'),
      ));
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  void changePage(int index) {
    setState(() {});
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
