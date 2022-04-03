import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watch_cart_ui/constants.dart';

class MainAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainAppBar({Key key, this.scaffoldKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/svg/menu.svg",
            width: 12.0,
            height: 12.0,
          ),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
        ),
        CircleAvatar(
          backgroundColor: Constants.primaryColor,
          child: IconButton(
            icon: Icon(Icons.notification_important_outlined,color: Colors.white,),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
