import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'account_setup.dart';

class AccountSetupGoogle extends StatelessWidget {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      bottom: true,
      child: FutureBuilder<UserCredential>(
        future: signInWithGoogle(),
        builder: (context, userSnapshot) {
          Widget tempWidget = Text(' none ');
          if (userSnapshot.hasError) {
            print("AuthErr :: ${userSnapshot.error}");
            tempWidget = Text("AuthErr :: ${userSnapshot.error}");
          } else {
            switch (userSnapshot.connectionState) {
              case ConnectionState.none:
                print('switch none :: ${userSnapshot.data}');
                break;
              case ConnectionState.waiting:
                print('switch waiting :: ${userSnapshot.data}');
                tempWidget = Text('Google sign-in authenticating...');
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                print('switch done :: ${userSnapshot.data}');
                if (userSnapshot.hasData) {
                  print("userSnapshot.data ==> ${userSnapshot.data}");
                  tempWidget =
                      Text('userSnapshot.data ==> ${userSnapshot.data}');
                } else {
                  tempWidget = Column(children: [
                    Text(' no user found '),
                    RaisedButton.icon(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountSetup())),
                        icon: Icon(Icons.replay_circle_filled),
                        label: Text('Restart Auth'))
                  ]);
                  print("userSnapshot.data ==> ${userSnapshot.data}");
                }
                break;
            }
          }
          return Center(
            child: tempWidget,
          );
        },
      ),
    ));
  }
}
