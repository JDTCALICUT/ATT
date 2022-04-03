
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watch_cart_ui/models/user.dart';
import 'package:watch_cart_ui/pages/dashboard.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:watch_cart_ui/pages/userSearch.dart';
import 'package:watch_cart_ui/services/fireStore.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../constants.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  final UUser user;

  const RegisterPage({Key key, this.user}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: size.height * 0.2, top: size.height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello, \nWelcome ${widget.user.name}", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: size.width * 0.07,color: Constants.primaryColor)),
              if(widget.user.status==UserStatus.none) Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(height: 50,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color:Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: widget.user.userType,
                        items: [
                          DropdownMenuItem(
                              child: Text('HOD'),
                              value: UserType.hod,
                          ),
                          DropdownMenuItem(
                              child: Text('Teachers'),
                              value: UserType.teacher,
                          ),
                          DropdownMenuItem(
                              child: Text('Students'),
                              value: UserType.students,
                          ),
                          DropdownMenuItem(
                              child: Text('Parents'),
                              value: UserType.parents,
                          ),
                        ], onChanged: (UserType value) {
                          setState(() {
                            widget.user.userType=value;
                          });
                      },
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color:Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: widget.user.branch,
                        items: [
                          DropdownMenuItem(
                              child: Text('CS'),
                              value: Branch.cs,
                          ),
                          DropdownMenuItem(
                              child: Text('EC'),
                            value: Branch.ec,
                          ),
                          DropdownMenuItem(
                              child: Text('EE'),
                            value: Branch.ee,
                          ),
                        ], onChanged: (Branch value) {
                          setState(() {
                            widget.user.branch=value;
                          });
                      },
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                 if(widget.user.isParent) InkWell(
                   child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color:Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: ListTile(
                        title: Text('${widget.user?.student?.name}'),
                      ),
                    ),
                   onTap: ()async{
                   UUser uUser=await showSearch(context: context, delegate: UserSearch(widget.user.userType, widget.user.branch));
                   if(uUser!=null){
                     setState(() {
                       widget.user.student=uUser;
                     });
                   }
                   },
                 ),
                  SizedBox(height: 20,),

                  RaisedButton(
                    color: Constants.primaryColor,
                    onPressed: ()async{
                      UUser user=await FireStore.register(widget.user);
                      setState(() {
                        widget.user.status=user.status;
                      });
                    },
                    elevation: 0,
                    padding: EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text("Register", style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                ],
              )
              else Column(
                children: [
                  Center(
                    child:  RaisedButton(
                      color: Constants.primaryColor,
                      onPressed: ()async{
                        UUser user=await FireStore.getUserByUID(FirebaseAuth.instance.currentUser.uid);
                        if(user.accepted){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                        }
                      },
                      elevation: 0,
                      padding: EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(child: Text("${widget.user.statusText}", style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

 signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential= await FirebaseAuth.instance.signInWithCredential(credential);
    UUser user=await FireStore.getUserByUID(userCredential.user.uid);
    if(user.accepted){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    }

  }
}