import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_cart_ui/models/user.dart';
import 'package:watch_cart_ui/pages/studentProfile.dart';
import 'package:watch_cart_ui/pages/teacherProfile.dart';
import 'package:watch_cart_ui/services/fireStore.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

class TeachersList extends StatefulWidget {
  const TeachersList({Key key}) : super(key: key);

  @override
  _TeachersListState createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStore.getUserByUIDStream(FirebaseAuth.instance.currentUser.uid),
        builder: (context, snapshot) {
          if((snapshot.data?.size??0)>0){
            UUser uUser=UUser.fromJson(snapshot.data.docs[0].data());
            return Scaffold(
                appBar: AppBar(
                  title: Text('Teachers'),
                  elevation: 0,
                ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: FireStore.usersList(UserType.teacher),
                  builder:(context,snapshot){
                    return ListView(
                      padding: EdgeInsets.all(15),
                      children:(snapshot.data?.docs??[]).map((e){
                        UUser user=UUser.fromJson(e.data());
                        user.id=e.id;
                        return Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              leading: ClipOval(
                                // child: Image.network(user.photoURL),
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              trailing: IconButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherProfile(user: user,student: uUser,)));
                                  }, icon: Icon(Icons.arrow_forward_ios)
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    );
                  }
              ),
            );
          }
          else return Container();
        }
      );
  }
}
