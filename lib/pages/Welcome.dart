import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
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
              SignInButton(
                Buttons.Google,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
