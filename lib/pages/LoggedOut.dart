import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path_provider/path_provider.dart';

class LoggedOut extends StatefulWidget {
  @override
  _LoggedOutState createState() => _LoggedOutState();
}

class _LoggedOutState extends State<LoggedOut> {
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
      print("cachedeleted");
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
      print("DataDeleted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "LoggedOut",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  _deleteCacheDir();
                  _deleteAppDir();
                }),
            SizedBox(
              height: 50,
            ),
            RaisedButton.icon(
              onPressed: () => Phoenix.rebirth(context),
              icon: Icon(Icons.settings_backup_restore),
              label: Text("Restart"),
            )
          ],
        ),
      ),
    );
  }
}
