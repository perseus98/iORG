import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildBody(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(
        "Archive",
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      actions: [
        Icon(Icons.unarchive),
      ],
    );
  }

  Container _buildBody() {
    return Container();
  }
}
