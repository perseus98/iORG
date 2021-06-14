import 'package:flutter/material.dart';
import 'package:iorg_flutter/main.dart';

progressWidget({bool circular = true, Color bgColor = Colors.grey}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: circular
        ? CircularProgressIndicator(
            strokeWidth: 5.0,
            semanticsValue: "loading",
            semanticsLabel: "Loading...",
            backgroundColor: myGrey,
            valueColor: AlwaysStoppedAnimation(myGrey),
          )
        : LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(myGrey),
          ),
  );
}
