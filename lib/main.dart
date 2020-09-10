import 'package:flutter/material.dart';
import 'package:iorg_flutter/pages/Welcome.dart';

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
//      home: new SplashScreen(),
      initialRoute: '/welcome',
      routes: <String, WidgetBuilder>{
        // '/splash': (BuildContext context) => SplashScreen(),
        '/welcome': (BuildContext context) => WelcomePage(),
        // '/intro': (BuildContext context) => IntroScreen(),
        // '/setup': (BuildContext context) => AccountsSetupPage(),
        // '/home': (BuildContext context) => HomePage(),
        // '/timeline': (BuildContext context) => TimeLinePage(),
        // '/notification': (BuildContext context) => NotificationsPage(),
        // '/saved': (BuildContext context) => SavedPage(),
        // '/search': (BuildContext context) => SearchPage(),
        // '/terms': (BuildContext context) => TermsAndCondition(),
        // '/exp': (BuildContext context) => Experimental(),
      },
    );
  }
}
