import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/injection.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/create_account.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UnAuthScreen extends StatelessWidget {
  final GoogleSignIn googleSignIn = getIt.get<GoogleSignIn>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Social App',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login(context),
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  login(BuildContext context) {
    googleSignIn.signIn();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account, context);
    }, onError: (err) {
      print('Lỗi đăng nhập: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account, BuildContext context) async {
    if (account != null) {
      await createUserInFirestore(context);
      //   setState(() {
      //     isAuth = true;
      //   });
      // } else {
      //   setState(() {
      //     isAuth = false;
      //   });
    }
  }

  createUserInFirestore(BuildContext context) async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      // make new user their own follower (to include their posts in their timeline)
      await followersRef
          .document(user.id)
          .collection('userFollowers')
          .document(user.id)
          .setData({});

      doc = await usersRef.document(user.id).get();
    }

    currentUser = User.fromDocument(doc);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }
}
