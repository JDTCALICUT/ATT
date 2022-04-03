import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_cart_ui/services/fireStore.dart';
import 'package:watch_cart_ui/services/publicVeriable.dart';

import '../models/user.dart';

class UserSearch extends SearchDelegate <UUser>{
  final UserType userType;
  final Branch branch;

  UserSearch(this.userType, this.branch);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }



    return search();
  }

  Widget search() {
    return StreamBuilder<QuerySnapshot>(
        stream:FireStore.usersSearch(userType,branch,query),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if ((snapshot.data?.docs??[]).length == 0) {
            return Column(
              children: <Widget>[
                Text(
                  "No Results Found.",
                ),
              ],
            );
          } else {
            var results = snapshot.data;
            return ListView(
                padding: EdgeInsets.all(15),
                children:(snapshot.data?.docs??[]).map((e){
                  UUser user=UUser.fromJson(e.data());
                  user.id=e.id;
                  return InkWell(
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          leading: ClipOval(
                            // child: Image.network(user.photoURL),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.pop(context,user);
                    },
                  );
                }).toList()
            );
          }
        },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return search();
  }
}