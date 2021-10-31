import 'package:flutter/material.dart';
import 'package:iotapp/utils/custom_colors.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = true;
  List<String> _languages = ['English', 'French'];
  String _selectedLanguage = 'English';
  List<String> _colors = ['Red', 'Blue','Green'];
  String _selectedColor = 'Red';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: settingsView());
  }

  Widget settingsView() {
    return ListView(
      shrinkWrap: true,
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          trailing: Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            },
            activeTrackColor: CustomColors.skyBlue,
            activeColor: CustomColors.blue,
          ),
          title: Text('Notification Settings'),
          onTap: () {},
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          trailing: DropdownButton<String>(
              items: _languages.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              value: _selectedLanguage,
              onChanged: (newVal) {
                _selectedLanguage = newVal;
                setState(() {});
              }),
          title: Text('Language Switch'),
          onTap: () {},
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          trailing: DropdownButton<String>(
              items: _colors.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
              value: _selectedColor,
              onChanged: (newVal) {
                _selectedColor = newVal;
                setState(() {});
              }),
          title: Text('Select Color Theme'),
          onTap: () {
            // Update the state of the app
          },
        )
      ],
    );
  }
}
