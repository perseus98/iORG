import 'package:flutter/material.dart';

progressIndicator(
    {bool circular = true,
    Color color = Colors.white,
    Color bgColor = Colors.grey}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: circular
        ? CircularProgressIndicator(
            strokeWidth: 5.0,
            semanticsValue: "loading",
            semanticsLabel: "Loading...",
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation(color),
          )
        : LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(color),
          ),
  );
}
