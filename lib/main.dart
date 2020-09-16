import 'package:flutter/material.dart';
import 'package:iorg_flutter/pages/HomePage.dart';
import 'package:iorg_flutter/pages/InitPage.dart';
import 'package:iorg_flutter/pages/WelcomePage.dart';

import 'file:///C:/Users/pmhrn/AndroidStudioProjects/iorg_flutter/lib/utility/extension.dart';

String getApplicationTitle() {
  return "iORG";
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: getApplicationTitle(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Theme.of(context).colorScheme.myAccentColor,
        dialogBackgroundColor: Colors.white,
        primarySwatch: Colors.blueGrey,
        cardColor: Colors.white70,
        accentColor: Theme.of(context).colorScheme.myAccentColor,
        textTheme: TextTheme(
          button: TextStyle(
            color: Theme.of(context).colorScheme.myAccentColor,
          ),
          headline5: TextStyle(
              fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      initialRoute: '/init',
      routes: <String, WidgetBuilder>{
        '/init': (BuildContext context) => InitPage(),
        '/welcome': (BuildContext context) => WelcomePage(),
        '/home': (BuildContext context) => HomePage(),
      },
    );
  }
}
