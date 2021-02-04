import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:iorg_flutter/pages/HomePage.dart';

class AccountSetupGoogle extends StatelessWidget {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    print('googleUser :: $googleUser');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print('googleAuth :: $googleAuth');
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('credential :: $credential');
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
            tempWidget = Text("AuthErr ${userSnapshot.error}");
          }
          switch (userSnapshot.connectionState) {
            case ConnectionState.none:
              print('switch none :: ${userSnapshot.data}');
              break;
            case ConnectionState.waiting:
              print('switch waiting :: ${userSnapshot.data}');
              break;
            case ConnectionState.active:
              print('switch active :: ${userSnapshot.data}');
              break;
            case ConnectionState.done:
              print('switch done :: ${userSnapshot.data}');
              break;
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            tempWidget = Text('Google sign-in authenticating...');
          } else {
            if (userSnapshot.hasData) {
              print("userSnapshot.data ==> ${userSnapshot.data}");
              tempWidget = Text('userSnapshot.data ==> ${userSnapshot.data}');
              // return HomePage(userSnapshot.data);
            } else {
              tempWidget = Text(' no user found ');
              print("userSnapshot.data ==> ${userSnapshot.data}");
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
