import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:watch_cart_ui/pages/login.dart';

import '../constants.dart';


class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}


class _WalkthroughState extends State<Walkthrough> {

  List pageInfos = [
    {
      "title": "Fresh Food",
      "body": "Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus."
          " Vestibulum ac diam sit amet quam vehicula elementum sed sit amet "
          "dui. Nulla porttitor accumsan tincidunt.",
      "img": "assets/images/on1.png",
    },
    {
      "title": "Fast Delivery",
      "body": "Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus."
          " Vestibulum ac diam sit amet quam vehicula elementum sed sit amet "
          "dui. Nulla porttitor accumsan tincidunt.",
      "img": "assets/images/on2.png",
    },
    {
      "title": "Easy Payment",
      "body": "Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus."
          " Vestibulum ac diam sit amet quam vehicula elementum sed sit amet "
          "dui. Nulla porttitor accumsan tincidunt.",
      "img": "assets/images/on3.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      for(int i = 0; i<pageInfos.length; i++)
        _buildPageModel(pageInfos[i])
    ];

    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: IntroductionScreen(
            dotsDecorator: DotsDecorator(
              color: Constants.primaryColor
            ),
            pages: pages,
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return LoginPage();
                  },
                ),
              );
            },
            onSkip: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return LoginPage();
                  },
                ),
              );
            },
            showSkipButton: true,
            skip: Text("Skip", style: TextStyle(
              color: Constants.primaryColor,
            ),),
            next: Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Constants.primaryColor,
              ),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Constants.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item){
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset(
        item['img'],
        height: 185.0,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w600,
          color: Constants.primaryColor,
        ),
        bodyTextStyle: TextStyle(fontSize: 15.0),
      ),
    );
  }
}