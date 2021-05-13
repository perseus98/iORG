import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_org/main.dart';

Future<bool> onWillPop(GlobalKey<ScaffoldState> scaffoldKey) async {
  DateTime currentTime = DateTime.now();
  //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
  //Statement 1 Or statement2
  bool backButton = backButtonPressedTime == null ||
      currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);
  if (backButton) {
    backButtonPressedTime = currentTime;
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Double Click to exit app"),
    ));
    return false;
  }
  SystemNavigator.pop();
  return true;
}
