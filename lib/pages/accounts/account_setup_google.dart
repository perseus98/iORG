import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iorg_flutter/widgets/ProgressWidgets.dart';
import 'package:iorg_flutter/pages/HomePage.dart';

class AccountSetupGoogle extends StatelessWidget {
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      bottom: true,
      child: FutureBuilder<User>(
        future: signInWithGoogle(),
        builder: (context, userSnapshot) {
          Widget tempWidget = Text(' none ');
          if (userSnapshot.hasError) {
            tempWidget = Text("AuthErr ${userSnapshot.error}");
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            tempWidget = Text('Google sign-in authenticating...');
          } else {
            if (userSnapshot.hasData) {
              print("userSnapshot.data ==> ${userSnapshot.data}");
              return HomePage(userSnapshot.data);
            } else {
              tempWidget = Text(' no user found ');
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
