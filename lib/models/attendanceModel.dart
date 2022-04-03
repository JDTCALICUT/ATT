import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_cart_ui/models/user.dart';

class Attendance{
  Attendance({
    this.id,
    this.time,
    this.teacher,
    this.students
  });

  String id;
  Timestamp time;
  UUser teacher;
  List<UUser> students;


  factory Attendance.fromRawJson(String str) => Attendance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json["id"],
    time: json["time"],
    teacher: UUser.fromJson(json['teacher']),
    students:json['students'].map((val)=> UUser.fromJson(val)).toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "teacher": teacher.toJson(),
    "teacherId": teacher.id,
    "students": students.map((e) => e.toJson()).toList(),
    "studentsIds": students.map((e) => e.id).toList(),
    "presentIds": students.where((e) => e.present==true).map((e) => e.id).toList(),
    "absentIds": students.where((e) => e.present==false).map((e) => e.id).toList(),
  };
}
class AttendanceDet{
  AttendanceDet({
    this.id,
    this.time,
    this.teacher,
    this.student,
    this.attendanceId,
    this.present=false,
  });

  String id;
  String attendanceId;
  Timestamp time;
  UUser teacher;
  UUser student;
  bool present;
  int total;
  int presented;


  factory AttendanceDet.fromRawJson(String str) => AttendanceDet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttendanceDet.fromJson(Map<String, dynamic> json) => AttendanceDet(
    id: json["id"],
    time: json["time"],
    teacher: UUser.fromJson(json['teacher']),
    student: UUser.fromJson(json['student']),
    attendanceId: json["attendanceId"],
    present: json["present"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "teacher": teacher.toJson(),
    "teacherId": teacher.id,
    "student": student.toJson(),
    "studentId": student.id,
    "present": present,
  };
}
