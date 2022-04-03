import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_cart_ui/models/user.dart';

class InternalMark{
  InternalMark({
    this.id,
    this.teacher,
    this.student,
    this.internalMark=0
  });

  String id;
  UUser teacher;
  UUser student;
  int internalMark;


  factory InternalMark.fromRawJson(String str) => InternalMark.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InternalMark.fromJson(Map<String, dynamic> json) => InternalMark(
    id: json["id"],
    teacher: UUser.fromJson(json['teacher']),
    internalMark:json["internalMark"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacher": teacher.toJson(),
    "teacherId": teacher.id,
    "student": student.toJson(),
    "studentId": student.id,
    "internalMark":internalMark
  };
}
