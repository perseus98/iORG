// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import 'account_setup.dart';
//
// class AccountSetupFacebook extends StatelessWidget {
//   Future<UserCredential> signInWithFacebook() async {
//     // Trigger the sign-in flow
//     final AccessToken accessToken = await FacebookAuth.instance
//         .login(loginBehavior: LoginBehavior.NATIVE_WITH_FALLBACK);
//
//     // Create a credential from the access token
//     final FacebookAuthCredential facebookAuthCredential =
//         FacebookAuthProvider.credential(accessToken.toString());
//
//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance
//         .signInWithCredential(facebookAuthCredential);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//       top: true,
//       bottom: true,
//       child: FutureBuilder<UserCredential>(
//         future: signInWithFacebook(),
//         builder: (context, userSnapshot) {
//           Widget tempWidget = Text(' none ');
//           if (userSnapshot.hasError) {
//             tempWidget = Text("AuthErr ${userSnapshot.error}");
//           } else {
//             switch (userSnapshot.connectionState) {
//               case ConnectionState.none:
//                 print('switch none :: ${userSnapshot.data}');
//                 break;
//               case ConnectionState.waiting:
//                 print('switch waiting :: ${userSnapshot.data}');
//                 tempWidget = Text('Facebook sign-in authenticating...');
//                 break;
//               case ConnectionState.active:
//               case ConnectionState.done:
//                 print('switch done :: ${userSnapshot.data}');
//                 if (userSnapshot.hasData) {
//                   print("userSnapshot.data ==> ${userSnapshot.data}");
//                   tempWidget =
//                       Text('userSnapshot.data ==> ${userSnapshot.data}');
//                 } else {
//                   tempWidget = Column(children: [
//                     Text(' no user found '),
//                     RaisedButton.icon(
//                         onPressed: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => AccountSetup())),
//                         icon: Icon(Icons.replay_circle_filled),
//                         label: Text('Restart Auth'))
//                   ]);
//                   print("userSnapshot.data ==> ${userSnapshot.data}");
//                 }
//                 break;
//             }
//           }
//           return Center(
//             child: tempWidget,
//           );
//         },
//       ),
//     ));
//   }
// }
