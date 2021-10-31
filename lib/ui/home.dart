import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iotapp/models/choice.dart';
import 'package:iotapp/models/history.dart';
import 'package:iotapp/models/vehicle.dart';
import 'package:iotapp/ui/profile.dart';
import 'package:iotapp/ui/settings.dart';
import 'package:iotapp/utils/custom_colors.dart';
import 'package:json_table/json_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool tab1 = true;
  bool tab2 = false;
  bool tab3 = false;
  bool tab4 = false;
  String _buttonText = "START";
  Color _buttonColor = Colors.green;
  String jsonSample = "";
  List<Vehicle> vehicleList = [];
  List<History> historyList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Smart Access Manager"),
          actions: <Widget>[
            popMenu(),
          ]),
      body: homeView(),
      bottomNavigationBar: bottomBar(),
      floatingActionButton: floatButton(),
    );
  }

  Widget popMenu() {
    return PopupMenuButton<Choice>(
      onSelected: _select,
      itemBuilder: (BuildContext context) {
        return choices.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }

  Widget floatButton() {
    return Visibility(
      visible: tab2,
      child: FloatingActionButton(
        onPressed: () {
          print("FAB");
          _asyncInputDialog(context);
        },
        backgroundColor: CustomColors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget bottomBar() {
    return CubertoBottomBar(
      tabStyle: CubertoTabStyle.STYLE_FADED_BACKGROUND,
      barBackgroundColor: CustomColors.blue,
      initialSelection: 0,
      drawer: CubertoDrawer.NO_DRAWER,
      tabs: [
        TabData(iconData: Icons.home, title: "Home"),
        TabData(iconData: Icons.drive_eta, title: "Cars"),
        TabData(iconData: Icons.notifications, title: "Notifications"),
        TabData(iconData: Icons.history, title: "History")
      ],
      onTabChangedListener: (position, title, color) {
        setState(() {
          switch (position) {
            case 0:
              tab1 = true;
              tab2 = false;
              tab3 = false;
              tab4 = false;
              break;
            case 1:
              tab1 = false;
              tab2 = true;
              tab3 = false;
              tab4 = false;
              getVehicleData();
              break;
            case 2:
              tab1 = false;
              tab2 = false;
              tab3 = true;
              tab4 = false;
              break;
            case 3:
              tab1 = false;
              tab2 = false;
              tab3 = false;
              tab4 = true;
              getHistoryData();
              break;
            default:
              {}
              break;
          }
        });
      },
    );
  }

  Widget homeView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Visibility(
          visible: tab1,
          child: Expanded(
            child: Container(
              //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
              color: CustomColors.blue,
              child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      String id = prefs.getString("id");
                      String _status = "";
                      if (_buttonText == "START") {
                        _status = "1";
                      } else {
                        _status = "0";
                      }
                      Firestore.instance
                          .collection('realtime_data')
                          .document(id)
                          .setData({'status': _status}).then((erg) {
                        print("Success!");
                        setState(() {
                          if (_status == "1") {
                            _buttonText = "STOP";
                            _buttonColor = Colors.red;
                          } else {
                            _buttonText = "START";
                            _buttonColor = Colors.green;
                          }
                        });
                      }, onError: (e) {
                        print("Fail!");
                      });
                    },
                    child: AvatarGlow(
                      startDelay: Duration(milliseconds: 1000),
                      glowColor: Colors.green,
                      endRadius: 90.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: false,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Text(_buttonText,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _buttonColor),
                              textAlign: TextAlign.center),
                          radius: 75.0,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
        ),
        Visibility(
          visible: tab2,
          child: Flexible(child: _buildList()),
        ),
        Visibility(
          visible: tab4,
          child: Flexible(child: _buildHistoryList()),
        )
      ],
    );
  }

  void getVehicleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("id"));
    QuerySnapshot _myDoc = await Firestore.instance
        .collection('vehicle_data')
        .where("user_id", isEqualTo: prefs.getString("id"))
        .getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    print(_myDocCount.length); // Count of Documents in Collection
    if (_myDocCount.length == 0) {
      print("Fail!");
      Toast.show("No Vehicles!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      print("Success!");
      setState(() {
        vehicleList.clear();
        _myDocCount.forEach((document) {
          print(document["vehicle_number"]);
          vehicleList
              .add(Vehicle(document.documentID, document["vehicle_number"]));
        });
      });
    }
  }

  void addVehicle(String _vehicle) async {
    //countDocuments(_name, _email, _pass1);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    QuerySnapshot _myDoc = await Firestore.instance
        .collection('vehicle_data')
        .where("vehicle_number", isEqualTo: _vehicle)
        .getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    print(_myDocCount.length); // Count of Documents in Collection
    if (_myDocCount.length == 0) {
      Firestore.instance.collection('vehicle_data').add({
        'vehicle_number': _vehicle,
        'user_id': prefs.getString("id")
      }).then((erg) {
        print("Success!");

        Toast.show("Success!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        getVehicleData();
      }, onError: (e) {
        print("Fail!");
        Toast.show("Error!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      });
    } else {
      Toast.show("Already Added!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  Future _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Vehicle Number'),
          content: Row(
            children: <Widget>[
              Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(hintText: 'eg. 123456'),
                    onChanged: (value) {
                      teamName = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (teamName
                    .trim()
                    .length > 0) {
                  Navigator.of(context).pop();
                  addVehicle(teamName);
                } else {
                  Toast.show("No Value!", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                }
              },
            ),
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future _asyncConfirmDialog(BuildContext context, String _vehicle) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Do you want to delete this vehicle?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteVehicle(_vehicle);
              },
            )
          ],
        );
      },
    );
  }

  void deleteVehicle(String _vehicle) async {
    await Firestore.instance
        .collection('vehicle_data')
        .document(_vehicle)
        .delete();
    getVehicleData();
  }

  void getHistoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("id"));
    QuerySnapshot _myDoc = await Firestore.instance
        .collection('history_data')
        .where("user_id", isEqualTo: prefs.getString("id"))
        .getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    print(_myDocCount.length); // Count of Documents in Collection
    if (_myDocCount.length == 0) {
      print("Fail!");
      Toast.show("No History!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      print("Success!");
      setState(() {
        historyList.clear();
        _myDocCount.forEach((document) {
          historyList
              .add(History(
              document.documentID, document["entry_date"], document["exit_date"],
              document["vehicle_number"]));
        });
      });
    }
  }

  void deleteHistory(String _vehicle) async {
    await Firestore.instance
        .collection('history_data')
        .document(_vehicle)
        .delete();
    getHistoryData();
  }

  Future _asyncConfirmDialogHistory(BuildContext context, String _vehicle) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const Text('Do you want to delete this history?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteHistory(_vehicle);
              },
            )
          ],
        );
      },
    );
  }




  Widget _buildList() {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      onRefresh: _handleRefresh, // refresh callback
      child: ListView.builder(
        // Must have an item count equal to the number of items!
        itemCount: vehicleList.length,
        // A callback that will return a widget.
        itemBuilder: (context, int) {
          // In our case, a DogCard for each doggo.
          return Card(
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(0.0),
                color: Colors.white,
              ),
              child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    child: ListTile(
                        title: Text(
                          vehicleList[int].number,
                        )),
                  ),
                  actions: <Widget>[

                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _asyncConfirmDialog(context, vehicleList[int].id);
                      },
                    ),
                  ]),
            ),
          );
        },
      ), // scroll view
    );
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      print("handlerefresh");
      getVehicleData();
      //_refreshIndicatorKey.currentState.dispose();
    });
  }

  Widget _buildHistoryList() {
    return LiquidPullToRefresh(
      showChildOpacityTransition: false,
      onRefresh: _handleHistoryRefresh, // refresh callback
      child: ListView.builder(
        // Must have an item count equal to the number of items!
        itemCount: historyList.length,
        // A callback that will return a widget.
        itemBuilder: (context, int) {
          // In our case, a DogCard for each doggo.
          return Card(
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(0.0),
                color: Colors.white,
              ),
              child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    //color: Colors.white,
                    child: ListTile(
                      leading: Text((int+1).toString()),
                        title: Text(
                          historyList[int].vehicle,
                        ),
                    subtitle: Text("Entry: "+historyList[int].entry+"\n"+"Exit: "+historyList[int].exit),),

                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _asyncConfirmDialogHistory(context, historyList[int].id);
                      },
                    ),
                  ]),
            ),
          );
        },
      ), // scroll view
    );
  }

  Future<void> _handleHistoryRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      print("handlerefresh");
      getHistoryData();
    });
  }

  static const List<Choice> choices = const <Choice>[
    const Choice(title: 'Profile', icon: Icons.person),
    const Choice(title: 'Settings', icon: Icons.settings),
  ];

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    switch (choices.indexOf(choice)) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      default:
        break;
    }
  }
}
