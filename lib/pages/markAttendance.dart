import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../constants.dart';
import '../models/attendanceModel.dart';
import '../models/user.dart';
import '../services/fireStore.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key key}) : super(key: key);

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  Attendance attendance=Attendance();


  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize()async{
    UUser teacher=await  FireStore.getUserByUID(FirebaseAuth.instance.currentUser.uid);
    attendance.teacher=teacher;
    List<UUser> students=await  FireStore.getUserList(UserType.students);
    setState(() {
      attendance.students=students;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('All'),
            trailing: Checkbox(
              value: attendance?.students?.every((element) => element.present==true)??false,
              onChanged: (val){
                setState(() {
                  attendance.students.forEach((element) {
                    element.present=val;
                  });
                });
              },
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: (attendance.students??[]).map((student){
                return ListTile(
                  title: Text(student.name),
                  trailing: Checkbox(
                    value: student.present,
                    onChanged: (val){
                      setState(() {
                        student.present=val;
                      });
                    },
                  ),
                );
              }).toList()
            ),
          ),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: (){
          FireStore.saveAttendance(attendance);
          Navigator.pop(context);
        },
        child: Container(
          color: Constants.primaryColor,
          height: 60,
          alignment: Alignment.center,
          child: Text('SUBMIT',),
        ),
      ),
    );
  }
}
