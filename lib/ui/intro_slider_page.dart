import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iotapp/utils/StatusNavBarColorChanger.dart';
import 'package:iotapp/utils/custom_colors.dart';
import 'package:iotapp/widgets/login_signup_bottom_custom_painer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navigate/navigate.dart';
import 'package:toast/toast.dart';
import 'intro_slider_pages/intro_slider_one_page.dart';
import 'intro_slider_pages/intro_slider_three_page.dart';
import 'intro_slider_pages/intro_slider_two_page.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'login_page.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage>
    with SingleTickerProviderStateMixin {
  PageController _introSliderController;
  SharedPreferences _sharedPreferences;
  double height, width;

  @override
  void initState() {
    super.initState();
    _introSliderController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    _setupSharedPreferences();


    Future.delayed(const Duration(seconds: 1));

    checkLogin();

  }

  void checkLogin() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.getBool("login")) {
        Toast.show("Login Success!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (Route<dynamic> route) => false);
      }
    });
  }

  Future _setupSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    /**/
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowGlow();
              },
              child: PageView(
                controller: _introSliderController,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  IntroSliderOnePage(),
                  IntroSliderTwoPage(),
                  IntroSliderThreePage(),
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              CustomPaint(
                painter: LoginSignupBottomCustomPainter(),
                child: Container(
                  width: width,
                  height: height * 0.20,
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: height * 0.05,
                    ),
                    child: GestureDetector(
                      child: Text(
                        "Login To Your Account!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      onTap: () {
                        _sharedPreferences.setBool("intro_done", true);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "login_page", (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: ((4.064 * height) / 100)),
                  child: PageIndicator(
                    layout: PageIndicatorLayout.DROP,
                    size: ((1.354 * height) / 100),
                    controller: _introSliderController,
                    space: ((0.677 * height) / 100),
                    count: 3,
                    activeColor: Colors.white,
                    // color: Colors.white.withAlpha(90),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
