import 'package:flutter/material.dart';
import 'package:iotapp/utils/custom_colors.dart';

class IntroSliderTwoPage extends StatefulWidget {
  @override
  _IntroSliderOnePageState createState() => _IntroSliderOnePageState();
}

class _IntroSliderOnePageState extends State<IntroSliderTwoPage> {
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assets/img/page2.png"),
              width: width * 0.80,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(((2.032 * height) / 100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Auto-Recognition",
                    style: TextStyle(
                      color: CustomColors.blue,
                      fontSize: ((2.099 * height) / 100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: ((1.354 * height) / 100),
                  ),
                  Text(
                    "automatic recognition of plate license",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ((1.896 * height) / 100),
                      fontWeight: FontWeight.normal,
                      letterSpacing: ((0.067 * height) / 100),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
