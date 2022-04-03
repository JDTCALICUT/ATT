import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:watch_cart_ui/models/attendanceModel.dart';
import 'package:watch_cart_ui/models/user.dart';
import 'package:watch_cart_ui/pages/homeAttendanceCard.dart';
import 'package:watch_cart_ui/services/fireStore.dart';
import 'package:lodash_dart/lodash_dart.dart' ;

class StudentsAttendanceListForTeacher extends StatefulWidget {
  final UUser teacher;
  const StudentsAttendanceListForTeacher({Key key, this.teacher}) : super(key: key);

  @override
  _StudentsAttendanceListForTeacherState createState() => _StudentsAttendanceListForTeacherState();
}

class _StudentsAttendanceListForTeacherState extends State<StudentsAttendanceListForTeacher> {
  Lodash lodash=Lodash();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Attendance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStore.attendanceDetList(teacher: widget.teacher),
        builder: (context, snapshot) {
          List<Map<String,dynamic>> list=snapshot?.data?.docs?.map((e){
           Map<String,dynamic> data= e.data();
           data['id']=e.id;
           return data;
          })?.toList()??[];
          Map newMap = groupBy(list, (Map<String,dynamic> obj) => obj['studentId']);
          return ListView(
            children: newMap.keys.map((e) {
              List<Map<String,dynamic>> attList=newMap[e];
              AttendanceDet det=AttendanceDet.fromJson(attList[0]);
              det.total=attList.length;
              det.presented=attList.where((element) => element['present']==true).length;
              return HomeAttendanceCard(det: det,);
            }).toList()
          );
        }
      ),
    );
  }
}
