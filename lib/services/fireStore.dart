
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_cart_ui/models/attendanceModel.dart';
import 'package:watch_cart_ui/models/internalMarkModel.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../models/user.dart';
class FireStore{
  static Future<UUser> register(UUser user)async{
    user.status=UserStatus.requested;
    if(user.id==null) {
     DocumentReference ref= await FirebaseFirestore.instance.collection('user').add(user.toJson());
     DocumentSnapshot snapshot= await ref.get();
     UUser uUser= UUser.fromJson(snapshot.data());
     uUser.id=snapshot.id;
     return uUser;
    } else {
      await FirebaseFirestore.instance.collection('user').doc(user.id).update(user.toJson());
      DocumentSnapshot snapshot= await FirebaseFirestore.instance.collection('user').doc(user.id).get();
      UUser uUser= UUser.fromJson(snapshot.data());
      uUser.id=snapshot.id;
      return uUser;
    }
  }
  static updateUser(UUser user)async{
    await FirebaseFirestore.instance.collection('user').doc(user.id).update(user.toJson());
  }
  static Future<UUser> getUserByUID(String uid)async {
    QuerySnapshot snapshot  =await FirebaseFirestore.instance.collection('user').where('uid',isEqualTo: uid).get();
    if(snapshot.size>0) {
      Map<String, dynamic> documentData = snapshot.docs[0].data();
      UUser uUser= UUser.fromJson(documentData);
      uUser.id=snapshot.docs[0].id;
      return uUser;
    }
   else return null;
  }
  static Stream<QuerySnapshot> getUserByUIDStream(String uid) {
    return FirebaseFirestore.instance.collection('user').where('uid',isEqualTo: uid).snapshots();
  }

  static Stream<QuerySnapshot> usersList(UserType userType){
      return FirebaseFirestore.instance.collection('user').where('userType',isEqualTo:userType.index).snapshots();
  }

  static Stream<QuerySnapshot> usersSearch(UserType userType,Branch branch,String query){
    return FirebaseFirestore.instance.collection('user')
        .where('userType',isEqualTo:userType.index)
        .where('branch',isEqualTo:branch.index)
        .orderBy('name')
        .startAt([query])
        .endAt([query + '\uf8ff']).snapshots();
  }

  static Future<List<UUser>> getUserList(UserType userType)async{
    List<QueryDocumentSnapshot> list= (await FirebaseFirestore.instance.collection('user').where('userType',isEqualTo:userType.index).get()).docs.toList();

    return  list.map((e) {
      UUser u= UUser.fromJson(e.data());
      u.id=e.id;
      return u;
    }).toList();
  }
  static saveAttendance(Attendance attendance)async{
    attendance.time=Timestamp.now();
    DocumentReference ref= await FirebaseFirestore.instance.collection('attendance').add(attendance.toJson());
    await attendance.students.forEach((student) async{
      var json= {
        "attendanceId": ref.id,
        "time": attendance.time,
        "teacher": attendance.teacher.toJson(),
        "teacherId": attendance.teacher.id,
        "student": student.toAttJson(),
        "studentId": student.id,
        "present": student.present,
      };
      await FirebaseFirestore.instance.collection('attendanceDet').add(json);
    });
   return ref.id;
  }

  static Stream<QuerySnapshot>  attendanceList({UUser student ,UUser teacher}){
    CollectionReference reference= FirebaseFirestore.instance.collection('attendance');
    if(teacher!=null && student!=null) {
     return  reference.where('teacher.id',isEqualTo:teacher.id).where('studentsIds',arrayContains: student.id).snapshots();
    } else if(teacher!=null)return reference.where('teacher.id',isEqualTo:teacher.id).snapshots();
    else if(student!=null)return reference.where('studentsIds',arrayContains:student.id).snapshots();
    else return reference.snapshots();
  }

  static Stream<QuerySnapshot>  attendanceDetList({UUser student ,UUser teacher}){
    CollectionReference reference= FirebaseFirestore.instance.collection('attendanceDet');
    if(teacher!=null && student!=null) {
      return  reference.where('teacher.id',isEqualTo:teacher.id).where('student.id',isEqualTo: student.id).snapshots();
    }
    else if(teacher!=null)return reference.where('teacher.id',isEqualTo:teacher.id).snapshots();
    else if(student!=null) {
      return reference.where('student.id',isEqualTo:student.id).snapshots();
    } else return reference.snapshots();
  }


  static saveInternal(InternalMark internal)async{
    DocumentReference ref= await FirebaseFirestore.instance.collection('internal').add(internal.toJson());
    return ref.id;
  }
}
