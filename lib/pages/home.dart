import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:watch_cart_ui/constants.dart';
import 'package:watch_cart_ui/pages/dashboard.dart';
import 'package:watch_cart_ui/pages/splashScreen.dart';
import 'package:watch_cart_ui/pages/studentAttendanceListForStudents.dart';
import 'package:watch_cart_ui/pages/studentAttendanceListForTeacher.dart';
import 'package:watch_cart_ui/pages/teachersList.dart';
import 'package:watch_cart_ui/pages/userList.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../services/fireStore.dart';
import 'profile.dart';
import 'watch_details.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int _currentIndex=0;


  List<Widget> widgets=[
    Dashboard(scaffoldKey: scaffoldKey),
    // WatchDetails(tag: 'tag',watch:
    // Product(
    //   brand: "Skmei Analog",
    //   name: "Men’s Watch",
    //   image: "assets/images/watch-2.png",
    //   price: 79.99,
    //   category: "Trending Watch",
    //   model: "AM03",
    //   description:
    //   "Combining functionality with timeless style. Explore the Rolex® collection and find the watch is that was made for you.",
    // ),
    // ),
    SplashScreen(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    User user=FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: FireStore.getUserByUIDStream(user.uid),
    builder: (context, snapshot) {
      if ((snapshot.data?.size ?? 0) > 0) {
        UUser uUser = UUser.fromJson(snapshot.data.docs[0].data());
        return Scaffold(
            key: scaffoldKey,
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  DrawerHeader(
                      padding: EdgeInsets.all(0),
                      child: UserAccountsDrawerHeader(
                        accountEmail: Text(
                            FirebaseAuth.instance.currentUser.email),
                        accountName: Text(
                            FirebaseAuth.instance.currentUser.displayName),
                        currentAccountPicture: ClipOval(
                            child: Image.network(FirebaseAuth.instance
                                .currentUser.photoURL)
                        ),
                      )
                  ),
                  if(uUser.userType==UserType.teacher) ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Students'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => UserList()));
                    },
                  ),
                 if(uUser.userType==UserType.students) Column(
                    children: [
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Teachers'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => TeachersList()));
                        },
                      ),
                    ],
                  ),
                 if(uUser.userType==UserType.teacher) Column(
                    children: [
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Attendance List'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => StudentsAttendanceListForTeacher(teacher: uUser,)));
                        },
                      ),
                    ],
                  ),
                 if(uUser.userType==UserType.students) Column(
                    children: [
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Attendance List'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => StudentsAttendanceListForStudent(student: uUser,)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: widgets[_currentIndex],
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: [

                /// Home
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  selectedColor: Constants.primaryColor,
                ),

                /// Likes
                // SalomonBottomBarItem(
                //   icon: Icon(Icons.favorite_border),
                //   title: Text("Attendance"),
                //   selectedColor: Constants.primaryColor,
                // ),

                /// Search
              if(uUser.isTeacher)  SalomonBottomBarItem(
                  icon: Icon(Icons.nfc),
                  title: Text("SCAN"),
                  selectedColor: Constants.primaryColor,
                ),

                /// Profile
                SalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Profile"),
                  selectedColor: Constants.primaryColor,
                ),
              ],
            )
        );
      }
      else return Container();
    }
    );
  }
}
