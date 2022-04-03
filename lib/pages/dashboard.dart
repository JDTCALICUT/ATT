
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_cart_ui/widgets/home_options.dart';
import 'package:watch_cart_ui/widgets/main_app_bar.dart';

import '../models/attendanceModel.dart';
import '../models/user.dart';
import '../services/fireStore.dart';
import 'homeAttendanceCard.dart';
import 'singleAttendanceCard.dart';

class Dashboard extends StatelessWidget {
final GlobalKey<ScaffoldState> scaffoldKey;

  const Dashboard({Key key, this.scaffoldKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User user=FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: FireStore.getUserByUIDStream(user.uid),
    builder: (context, snapshot) {
      if ((snapshot.data?.size ?? 0) > 0) {
        UUser uUser = UUser.fromJson(snapshot.data.docs[0].data());
        return Scaffold(
          backgroundColor: Color.fromRGBO(245, 245, 245, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MainAppBar(scaffoldKey: scaffoldKey),
                    SizedBox(
                      height: 50.0,
                    ),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "JDT\n",
                            style: TextStyle(
                              height: 2.5,
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(34, 34, 34, 1),
                            ),
                          ),
                          TextSpan(
                            text: "Attendance",
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Color.fromRGBO(34, 34, 34, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    HomeOptions(),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      children: [
                      if(uUser.isStudent)  StreamBuilder<QuerySnapshot>(
                            stream: FireStore.attendanceDetList(student:uUser),
                            builder: (context, snapshot) {
                              List<Map<String,dynamic>> list=snapshot?.data?.docs?.map((e){
                                Map<String,dynamic> data= e.data();
                                data['id']=e.id;
                                return data;
                              })?.toList()??[];
                              Map newMap = groupBy(list, (Map<String,dynamic> obj) => obj['teacherId']);
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
                                   ListView(
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
                      else if(uUser.isTeacher) StreamBuilder<QuerySnapshot>(
                          stream: FireStore.attendanceDetList(teacher: uUser),
                          builder: (context, snapshot) {
                            List<Map<String,dynamic>> list=snapshot?.data?.docs?.map((e){
                              Map<String,dynamic> data= e.data();
                              data['id']=e.id;
                              return data;
                            })?.toList()??[];
                            Map newMap = groupBy(list, (Map<String,dynamic> obj) => obj['studentId']);
                            return ListView(
                              shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: newMap.keys.map((e) {
                                  List<Map<String,dynamic>> attList=newMap[e];
                                  AttendanceDet det=AttendanceDet.fromJson(attList[0]);
                                  det.total=attList.length;
                                  det.presented=attList.where((element) => element['present']==true).length;
                                  return HomeAttendanceCard(det: det,);
                                }).toList()
                            );
                          }
                      )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
      else
        return Container();
    }
    );
  }
}

