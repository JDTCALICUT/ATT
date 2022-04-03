
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constants.dart';
import '../models/attendanceModel.dart';

class HomeAttendanceCard extends StatelessWidget {
  final AttendanceDet det;
  const HomeAttendanceCard({
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
        height: 150,
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
                      title: Text('${det.student.name}',style: Theme.of(context).textTheme.titleLarge.copyWith(fontWeight: FontWeight.bold),),
                      subtitle: Text('${det.presented} Presented / ${det.total} Register',style: Theme.of(context).textTheme.bodyMedium,),
                      trailing: Text('${det.teacher.name}',style: Theme.of(context).textTheme.bodySmall.copyWith(fontWeight: FontWeight.bold),),
                    ),
                    ListTile(
                      dense: true,
                      title: Text('Timing',style: Theme.of(context).textTheme.bodySmall.copyWith(fontWeight: FontWeight.bold),),
                      subtitle:Text('${det.time.toDate()}',style: Theme.of(context).textTheme.bodySmall,),
                      trailing: Container(
                        width: 60.0,
                        height: 60.0,
                        child: FittedBox(
                          child: new CircularPercentIndicator(
                            radius: 25.0,
                            lineWidth: 5.0,
                            percent: 0.9,
                            backgroundColor: Colors.white,
                            center: new Text("${(det.presented*100/det.total).toStringAsFixed(1)}%",style: Theme.of(context).textTheme.labelSmall.copyWith(fontSize: 8)),
                            progressColor: Colors.green,
                          ),
                        ),
                      ),
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