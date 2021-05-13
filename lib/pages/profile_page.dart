import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Profile'),
      ),
      body: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          Widget temp = Text('null');
          if (snapshot.hasError) {
            return promptData(snapshot.error);
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              temp = Text('Waiting');
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              temp = promptData(snapshot.data.toString());
              break;
          }
          return temp;
        },
      ),
    );
  }

  Widget promptData(Object str) {
    return Center(
      child: Text('$str'),
    );
  }
}
