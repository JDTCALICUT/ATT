

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_cart_ui/constants.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../models/user.dart';
import '../services/fireStore.dart';
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    User user=FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: FireStore.getUserByUIDStream(user.uid),
    builder: (context, snapshot) {
      if ((snapshot.data?.size ?? 0) > 0) {
        UUser uUser = UUser.fromJson(snapshot.data.docs[0].data());
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
                          Text(user.displayName, style: TextStyle(
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
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.network(
                                        user.photoURL, fit: BoxFit.cover,)),
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
                          Text(user.displayName, style: TextStyle(
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
                    if(uUser.userType==UserType.students) ExpansionTile(
                      leading: Icon(Icons.school_outlined),
                      title: Text('INTERNALS'),
                      children: [
                        ListTile(
                          title: Text('SEM1'),
                          trailing: Text('20'),
                        ),
                        ListTile(
                          title: Text('SEM1'),
                          trailing: Text('20'),
                        ),
                        ListTile(
                          title: Text('SEM1'),
                          trailing: Text('20'),
                        ),
                        ListTile(
                          title: Text('SEM1'),
                          trailing: Text('20'),
                        ),
                        ListTile(
                          title: Text('SEM1'),
                          trailing: Text('20'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
      else return Container();
    }
    );
  }
}