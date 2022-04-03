import 'dart:convert';
import '../services/publicVeriable.dart';

class UUser{
  UUser({
    this.id,
    this.name,
    this.address,
    this.userType,
    this.branch,
    this.mobile,
    this.email,
    this.uid,
    this.status,
    this.photoURL,
    this.present=false,
    this.student,
  });

  String id;
  String name;
  String address;
  UserType userType;
  Branch branch;
  String mobile;
  String email;
  String uid;
  UserStatus status;
  String photoURL;
  bool present;
  UUser student;

  UUser copyWith({
    String id,
    String name,
    String address,
    UserType userType,
    UserType branch,
    String mobile,
    String email,
    String uid,
    UserStatus status,
    String photoURL,
  }) =>
      UUser(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        userType: userType ?? this.userType,
        branch: branch ?? this.branch,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        uid: uid ?? this.uid,
        status: status ?? this.status,
        photoURL: photoURL ?? this.photoURL,
      );

  factory UUser.fromRawJson(String str) => UUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UUser.fromJson(Map<String, dynamic> json) => UUser(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    userType: UserType.values[json["userType"]??0],
    branch: Branch.values[json["branch"]??0],
    mobile: json["mobile"],
    email: json["email"],
    uid: json["uid"],
    photoURL: json["photoURL"],
    status: UserStatus.values[json["status"]??0],
    student:json["student"]==null?null:UUser.fromJson(json["student"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "userType": userType.index,
    "branch": branch.index,
    "mobile": mobile,
    "email": email,
    "uid": uid,
    "status": status.index,
    "photoURL": photoURL,
    "student": student?.toJson(),
  };
  Map<String, dynamic> toAttJson() => {
    "id": id,
    "name": name,
    "address": address,
    "userType": userType.index,
    "branch": branch.index,
    "mobile": mobile,
    "email": email,
    "uid": uid,
    "status": status.index,
    "photoURL": photoURL,
    "present": present,
  };

  bool get accepted{
   return this.status==UserStatus.accepted;
  }
  bool get isStudent{
    return this.userType==UserType.students;
  }
  bool get isTeacher{
    return this.userType==UserType.teacher;
  }
  bool get isParent{
    return this.userType==UserType.parents;
  }
  String get statusText{
    if(this.status==UserStatus.accepted)  return 'Accepted';
    else if(this.status==UserStatus.requested)  return 'Requested';
    else if(this.status==UserStatus.rejected)  return 'Rejected';
    else  return 'Not registered';
  }
  UserType get childUserType{
    if(this.userType==UserType.admin)  return UserType.principal;
    else if(this.userType==UserType.principal)  return UserType.hod;
    else if(this.userType==UserType.hod)  return UserType.teacher;
    else if(this.userType==UserType.teacher)  return UserType.students;
    else  return UserType.none;
  }
  String get childUserTypeName{
    if(this.userType==UserType.admin)  return 'Principal';
    else if(this.userType==UserType.principal)  return 'HOD';
    else if(this.userType==UserType.hod)  return 'Teachers';
    else if(this.userType==UserType.teacher)  return 'Students';
    else  return "None";
  }
}
