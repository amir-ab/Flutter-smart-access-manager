import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iotapp/utils/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  AlertDialog alertDialog;
  var _name = "";
  var _phone = "";
  var _email = "";
  var _address = "";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setProfileData();
      /*Network.instance.checkNetwork().then((value) {
        if (value) {
          getProfile();
        } else {
          _showInternetErrorDialog();
        }
      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: profileView(context));
  }

  Widget profileView(BuildContext context) {
    var iconSize = 30.0;
    var titleSize = 20.0;
    var valueSize = 25.0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 20,
          ),
          CircleAvatar(
              radius: 50.0,
              child: Image(
                  fit: BoxFit.contain,
                  image: new AssetImage('assets/user.png'))),
          Card(
            margin: EdgeInsets.all(10),
            child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Icon(Icons.person),
                          Container(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(_name,
                                textDirection: TextDirection.ltr,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: valueSize)),
                          ),
                        ])),
                    Divider(
                      color: Colors.grey,
                      height: 2,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Icon(Icons.email),
                          Container(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(_email,
                                textDirection: TextDirection.ltr,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black, fontSize: valueSize)),
                          ),
                        ])),
                  ],
                )),
          ),
          /*Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              color: CustomColors.blue,
              elevation: 6.0,
              child: Text(
                "Edit Profile",
                style: TextStyle(
                    color: Colors.white),
              ),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              color: CustomColors.blue,
              elevation: 6.0,
              child: Text(
                "Change Password",
                style: TextStyle(
                    //fontSize: Constants.instance.buttonTextSize,
                    color: Colors.white),
              ),
              onPressed: () {},
            ),
          ),*/
          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              padding: EdgeInsets.all(10),
              color: CustomColors.blue,
              elevation: 6.0,
              child: Text(
                "Log Out",
                style: TextStyle(
                  //fontSize: Constants.instance.buttonTextSize,
                    color: Colors.white),
              ),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "login_page", (Route<dynamic> route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }

  void setProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _email = prefs.getString("email");
    });
  }
}
