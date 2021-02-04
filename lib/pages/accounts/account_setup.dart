import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iorg_flutter/utilities/system_methods.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'account_setup_google.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountSetup extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(scaffoldKey),
      child: Scaffold(
        key: scaffoldKey,
        body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User> userSnapshot) {
            Widget tempWidget = Text(' none ');
            print(userSnapshot.connectionState);
            if (userSnapshot.hasError) {
              tempWidget = Text('FirebaseAuth Error :: ${userSnapshot.error}');
            }
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              tempWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  progressWidget(),
                  Text('Firebase User State Loading...'),
                ],
              );
            } else {
              if (userSnapshot.hasData) {
                return HomePage(userSnapshot.data);
              } else {
                tempWidget = Container(
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 1,
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                  semanticLabel: 'Google sign-in',
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountSetupGoogle()));
                                },
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 1,
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.ghost,
                                  color: Colors.white,
                                  semanticLabel: "Anonymous",
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountSetupGoogle()));
                                },
                              ),
                            ),
                          ]),
                    ],
                  ),
                );
              }
            }
            return Center(
              child: tempWidget,
            );
          },
        ),
      ),
    );
  }
}
