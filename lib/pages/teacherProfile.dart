
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:watch_cart_ui/constants.dart';
import 'package:watch_cart_ui/models/user.dart';
import 'package:watch_cart_ui/services/fireStore.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../models/attendanceModel.dart';
import 'homeAttendanceCard.dart';
import 'singleAttendanceCard.dart';
class TeacherProfile extends StatelessWidget {
final UUser user;
final UUser student;
  const TeacherProfile({Key key, this.user,  this.student}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius
                          .circular(50.0),
                          bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                          colors: [
                            Constants.primaryColor,
                            Constants.subColor
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[
                      Text(user.name, style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic
                      ),),
                      SizedBox(height: 20.0),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            alignment: Alignment.center,
                            child: Container(
                              height: 300,
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 100.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(20.0)
                              ),
                              child: Text(user.email),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Text(user.name, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_on, size: 16.0,
                            color: Colors.grey,),
                          Text("San Diego, California, USA",
                            style: TextStyle(color: Colors.grey.shade600),)
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            color: Colors.grey,
                            icon: Icon(Icons.call),
                            onPressed: () {},
                          ),
                          IconButton(
                            color: Colors.grey,
                            icon: Icon(Icons.message),
                            onPressed: () {},
                          ),
                          IconButton(
                            color: Colors.grey.shade600,
                            icon: Icon(Icons.whatsapp),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FireStore.attendanceDetList(teacher: user,student: student),
                    builder: (context, snapshot) {
                      List<Map<String,dynamic>> list=snapshot?.data?.docs?.map((e){
                        Map<String,dynamic> data= e.data();
                        data['id']=e.id;
                        return data;
                      })?.toList()??[];
                      Map newMap = groupBy(list, (Map<String,dynamic> obj) => obj['studentId']);
                      return Column(
                        children: [
                          ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: newMap.keys.map((e) {
                                List<Map<String,dynamic>> attList=newMap[e];
                                AttendanceDet det=AttendanceDet.fromJson(attList[0]);
                                det.total=attList.length;
                                det.presented=attList.where((element) => element['present']==true).length;
                                return HomeAttendanceCard(det: det,);
                              }).toList()
                          ),
                          Divider(),
                         if(student!=null) ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: list.reversed.map((e) {
                               Map<String,dynamic> attList=e;
                                AttendanceDet det=AttendanceDet.fromJson(attList);
                                return SingleAttendanceCard(det: det,);
                              }).toList()
                          ),
                        ],
                      );
                    }
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}