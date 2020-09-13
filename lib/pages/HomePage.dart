import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iorg_flutter/main.dart';
import 'package:iorg_flutter/pages/Welcome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
          child: CircleAvatar(
            child: Image.network(
              currentUserAuth.photoURL,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(getApplicationTitle()),
        actionsIconTheme: IconThemeData(size: 5.0),
        actions: [Icon(Icons.filter_list), Icon(Icons.search)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        //border radius doesn't work when the notch is enabled.
        elevation: 8,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.red,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.archive,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.archive,
                color: Colors.indigo,
              ),
              title: Text("Archive")),
        ],
      ),
      body: Center(
        child: Text(" Homepage "),
      ),
    );
  }
}
