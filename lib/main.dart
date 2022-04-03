import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watch_cart_ui/models/user.dart';
import 'package:watch_cart_ui/pages/home.dart';
import 'package:watch_cart_ui/pages/register.dart';
import 'package:watch_cart_ui/pages/splashScreen.dart';
import 'package:watch_cart_ui/pages/login.dart';
import 'package:watch_cart_ui/pages/dashboard.dart';
import 'package:watch_cart_ui/pages/walkThrough.dart';
import 'package:watch_cart_ui/pages/watch_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watch_cart_ui/services/fireStore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.latoTextTheme(
            TextTheme(),
          ),
        ),
        home: StreamBuilder<User>(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            User user=snapshot.data;
            if(user==null)return Walkthrough();
           else return StreamBuilder<QuerySnapshot>(
              stream: FireStore.getUserByUIDStream(user.uid),
              builder: (context, snapshot) {
                if((snapshot.data?.size??0)>0){
                  UUser uUser=UUser.fromJson(snapshot.data.docs[0].data());
                  if(uUser?.accepted??false) return Home();
                  else return RegisterPage(user: uUser,);
                }
                else return LoginPage();
              }
            );
          }
        ),
      ),
    );
  }
}
