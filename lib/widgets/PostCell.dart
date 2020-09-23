import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iorg_flutter/models/PostModel.dart';

Container postCell(BuildContext context, PostModel _post) {
  return Container(
    margin: EdgeInsets.all(5.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(color: Hexcolor(_post.priorityColor)),
    height: MediaQuery.of(context).size.height * 0.8,
    width: MediaQuery.of(context).size.width * 0.8,
    child: Row(
      children: [
        Image.network(_post.photoUrl),
        Column(
          children: [
            Text(_post.postName),
            Text(_post.deadline),
          ],
        )
      ],
    ),
  );
}
