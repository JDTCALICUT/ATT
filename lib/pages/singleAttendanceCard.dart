
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constants.dart';
import '../models/attendanceModel.dart';

class SingleAttendanceCard extends StatelessWidget {
  final AttendanceDet det;
  const SingleAttendanceCard({
    Key key, this.det,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        height: 80,
        child: Row(
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(5.0)
              ),
            ),
            Expanded(
                child:Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text(det.teacher.name,style: Theme.of(context).textTheme.bodySmall.copyWith(fontWeight: FontWeight.bold),),
                      subtitle:Text('${DateFormat.yMMMEd().format(det.time.toDate())} ${DateFormat('h:m').format(det.time.toDate())}',style: Theme.of(context).textTheme.bodySmall,),
                      trailing: Icon(Icons.school,color: det.present?Colors.green:Colors.red,),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}