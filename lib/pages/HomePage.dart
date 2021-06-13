import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iorg_flutter/generated/assets.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/PreviewImage.dart';
import 'package:iorg_flutter/pages/profile_page.dart';
import 'package:iorg_flutter/widgets/PostWidget.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
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
    // Widget temp = ;
    // _homePageGlobalKey.currentState.openDrawer();
    return Scaffold(
      backgroundColor: Colors.white,
      key: _homePageGlobalKey,
      // appBar: _appBar(context),
      drawer: _drawer(context),
      floatingActionButton: _scaleTransition(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _animatedBottomNavigationBar(),
      body: WillPopScope(
          onWillPop: () => onWillPop(_homePageGlobalKey),
          child: ListView(
            children: [
              Material(
                elevation: 15.0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.black12),
                  ]),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 50.0, left: 40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "iORG",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 107, 107, 107),
                                    fontSize: 44.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Documentation Hanlder",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 107, 107, 107),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, right: 25.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              elevation: 5.0,
                              child: Container(
                                height: 45.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 50.0)],
                                ),
                                // alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.sort),
                                    Icon(Icons.menu)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 25.0, left: 25.0, top: 50.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 4.0,
                          child: Container(
                              height: 50.0,
                              padding: EdgeInsets.only(left: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 50.0)],
                              ),
                              alignment: Alignment.center,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  labelStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   child: ,
              // ),
              Container(
                height: MediaQuery.of(context).size.height * 0.62,
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
                                archiveEntry(context,
                                    querySnapshot.docs[index]['postId']);
                              }
                              if (direction == DismissDirection.endToStart) {
                                deleteEntry(context,
                                    querySnapshot.docs[index]['postId']);
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
                                print(
                                    "${querySnapshot.docs[index].id} clicked");
                              },
                              child:
                                  PostWidget(querySnapshot.docs[index], false),
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
            ],
          )),
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
      leading: IconButton(
          icon: Icon(
            Icons.menu_outlined,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () => _homePageGlobalKey.currentState.openDrawer()),
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
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10.0)
            ]),
            child: Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "iORG",
                          style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Documentation",
                          style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Handler",
                          style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Presented By",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      TextSpan(
                        text: "sud3shi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage())),
            child: Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  Icon(Icons.person_outline_outlined),
                  // Image.asset(Assets.logoLogoPerson),
                  SizedBox(
                    child: Text(""),
                    width: 10.0,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _signOutDialog,
            child: Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  Icon(Icons.logout),
                  // Image.asset(Assets.logoSignout),
                  SizedBox(
                    child: Text(""),
                    width: 10.0,
                  ),
                  Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => SystemNavigator.pop(),
            child: Container(
              margin: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                children: [
                  Icon(Icons.exit_to_app),
                  // Image.asset(Assets.logoExit),
                  SizedBox(
                    child: Text(""),
                    width: 10.0,
                  ),
                  Text(
                    'Exit',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          // AboutListTile(
          //   // icon: Icon(Icons.info_outline),
          //   applicationIcon: Image.asset(
          //     'images/logo.png',
          //     height: 100.0,
          //     width: 100.0,
          //   ),
          //   applicationName: 'iORG',
          //   applicationVersion: '0.1.3',
          //   applicationLegalese: ' Copyright @ sud3shi',
          //   aboutBoxChildren: [
          //     Text(
          //       "This application is developed under the name of sud3shi,",
          //       style: TextStyle(fontSize: 10.0),
          //     ),
          //     Text(
          //       "Credits:",
          //       style: TextStyle(fontSize: 10.0),
          //     ),
          //     Text(
          //       "Mulchand Sahu(layout)",
          //       style: TextStyle(fontSize: 10.0),
          //     ),
          //     Text(
          //       "Pramod Vishwakarma(research)",
          //       style: TextStyle(fontSize: 10.0),
          //     ),
          //     Text(
          //       "Prashant Maharana(app dev)",
          //       style: TextStyle(fontSize: 10.0),
          //     ),
          //   ],
          // ),
        ],
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
                  totalSwitches: 2,
                  // activeBgColor: Colors.cyan,
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
            TextButton(
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
            TextButton(
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
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/create');
        },
        child: Material(
          borderRadius: BorderRadius.circular(50.0),
          elevation: 10.0,
          child: Container(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Color.fromARGB(255, 107, 107, 107), width: 5.0),
              borderRadius: BorderRadius.circular(50.0),
              // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 50.0)],
            ),
            // alignment: Alignment.center,
            child: Icon(Icons.add),
          ),
        ),
      ),
      // FloatingActionButton(
      //   elevation: 8,
      //   backgroundColor: Colors.white,
      //   child: ,
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/create');
      //   },
      // ),
    );
  }

  Widget _animatedBottomNavigationBar() {
    return Container(
      height: 60.0,
      padding: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => setState(() {}),
            child: Column(
              children: [
                Icon(
                  Icons.dashboard_customize,
                  size: 20.0,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(fontSize: 10.0),
                )
              ],
            ),
          ),
          Text(""),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/archive'),
            child: Column(
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 20.0,
                ),
                Text(
                  "Archive",
                  style: TextStyle(fontSize: 10.0),
                )
              ],
            ),
          ),
        ],
      ),
    );
    // return AnimatedBottomNavigationBar(
    //     icons: [
    //       Icons.dashboard,
    //       Icons.archive,
    //     ],
    //     backgroundColor: Colors.white,
    //     activeIndex: 0,
    //     activeColor: Theme
    //         .of(context)
    //         .accentColor,
    //     splashColor: Hexcolor('#998abd'),
    //     inactiveColor: Colors.grey,
    //     notchAndCornersAnimation: animation,
    //     splashSpeedInMilliseconds: 300,
    //     notchSmoothness: NotchSmoothness.defaultEdge,
    //     gapLocation: GapLocation.center,
    //     leftCornerRadius: 32,
    //     rightCornerRadius: 32,
    //     onTap: (index) {
    //       if (index == 1) {
    //         Navigator.pushNamed(context, '/archive');
    //       } else {
    //         setState(() {
    //           // Refresh State
    //         });
    //       }
    //     }
    // );
  }

  Future<bool> onWillPop(GlobalKey<ScaffoldState> scaffoldKey) async {
    DateTime currentTime = DateTime.now();

    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Deleted")));
      print("$postId :: ${postId.runtimeType} Deleted");
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to delete user: $error");
    });
  }

  Future<void> archiveEntry(BuildContext context, String postId) {
    return postReference.doc(postId).update({'archive': true}).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Entry Archived")));
      print("$postId :: ${postId.runtimeType} Archived");
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Err:: $error")));
      print("Failed to archive entry: $error");
    });
  }
}
