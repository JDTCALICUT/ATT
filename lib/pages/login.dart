
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watch_cart_ui/models/user.dart';
import 'package:watch_cart_ui/pages/dashboard.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:watch_cart_ui/pages/register.dart';
import 'package:watch_cart_ui/services/fireStore.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../constants.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: size.height * 0.2, top: size.height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello, \nWelcome JDT", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * 0.1,color: Constants.primaryColor)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SignInButton(
                    Buttons.Google,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    onPressed: () {
                      signInWithGoogle();
                    },
                  ),
                  SizedBox(height: 40),
                  SignInButton(
                    Buttons.FacebookNew,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    onPressed: () {
                      signInWithGoogle();
                    },
                  ),
                  SizedBox(height: 50,)
                ],
              ),
              // Column(
              //   children: [
              //     RaisedButton(
              //       color: Constants.primaryColor,
              //       onPressed: (){
              //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
              //       },
              //       elevation: 0,
              //       padding: EdgeInsets.all(18),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20)
              //       ),
              //       child: Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),)),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

 signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);
    UUser user=await FireStore.getUserByUID(userCredential.user.uid);
    if(user?.accepted??false){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    }
    else{
      if(user==null)user=UUser(
        name: userCredential.user.displayName,
        email: userCredential.user.email,
        mobile: userCredential.user.phoneNumber,
        uid: userCredential.user.uid,
        userType: UserType.students,
        status: UserStatus.none,
        photoURL: user?.photoURL??'',
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage(user: user,)));
    }

  }
}