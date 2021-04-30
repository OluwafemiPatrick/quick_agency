import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/account/home_account.dart';
import 'package:quickseen_agent/agent/message/home_message.dart';
import 'package:quickseen_agent/agent/home/home_home.dart';
import 'package:quickseen_agent/agent/settings/home_settings.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePageAgent extends StatefulWidget {
  @override
  _HomePageAgentState createState() => _HomePageAgentState();
}

class _HomePageAgentState extends State<HomePageAgent> {

  double _iconSize = 25.0;
  double _textSize = 12.0;

  bool isHomeButton = true;
  bool isDashboardButton = false;
  bool isAccountButton = false;
  bool isSettingButton = false;

  String _firstName, _lastName, _email, _userId, _phoneNumber, _userCategory, _desc, _address, _profileImageUrl,
      _businessOrAgencyName, _isIdVerified, _totalMoneyEarned, _totalMoneyWithdraw, _totalBalance, _noOfRegisteredRiders, _addressLatLng;
  String _address1, _address2, _address3, _address4, _address5, _address6, _address7, _address8, _address9, _address10, _contactName1,
      _contactName2, _contactName3, _contactName4, _contactName5, _contactName6, _contactName7, _contactName8, _contactName9, _contactName10,
      _contactNum1, _contactNum2, _contactNum3, _contactNum4, _contactNum5, _contactNum6, _contactNum7, _contactNum8, _contactNum9, _contactNum10;

  @override
  void initState() {
    _retrieveDataFromDb();
    super.initState();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar(backgroundColor: colorPrimaryRed)),
        body: Column(
            children: [
              Expanded(child: _switchNavigationButtons()),
              bottomNavigationButtons(),
            ] )
    );
  }

  // ignore: missing_return
  Widget _switchNavigationButtons(){
    if (isHomeButton == true) {
      return HomeHomeAgent(
          _userId,
          _businessOrAgencyName,
          _profileImageUrl,
          _isIdVerified,
          _firstName,
          _lastName,
          _noOfRegisteredRiders);
    }
    else if (isDashboardButton == true) {
      return HomeChat();
    }
    else if (isAccountButton == true) {
      return HomeAccount(
          _profileImageUrl,
          _businessOrAgencyName,
          _phoneNumber,
          _email,
          _totalBalance,
          _desc,
          _address,
          _totalMoneyEarned,
          _totalMoneyWithdraw,
          _isIdVerified,
          _noOfRegisteredRiders,
          _profileImageUrl,
          _address1,
          _address2,
          _address3,
          _address4,
          _address5,
          _address6,
          _address7,
          _address8,
          _address9,
          _address10);
    }
    else if (isSettingButton == true) {
      return HomeSettings(
          _firstName,
          _lastName,
          _businessOrAgencyName,
          _profileImageUrl,
          _userId,
          _isIdVerified,
          _address1,
          _address2,
          _address3,
          _address4,
          _address5,
          _address6,
          _address7,
          _address8,
          _address9,
          _address10,
          _contactName1,
          _contactName2,
          _contactName3,
          _contactName4,
          _contactName5,
          _contactName6,
          _contactName7,
          _contactName8,
          _contactName9,
          _contactName10,
          _contactNum1,
          _contactNum2,
          _contactNum3,
          _contactNum4,
          _contactNum5,
          _contactNum6,
          _contactNum7,
          _contactNum8,
          _contactNum9,
          _contactNum10,
          _desc);
    }
  }


  Widget bottomNavigationButtons(){
    return Container(
      color: colorPrimaryRed,
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _homeButton(text: "Home", iconName: Icons.home),
          _dashboardButton(text: "Messages", iconName: Icons.dashboard),
          _accountButton(text: "Account", iconName: Icons.account_box),
          _settingsButton(text: "Settings", iconName: Icons.settings),
        ],
      ),
    );
  }


  _homeButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = true;
            isDashboardButton = false;
            isAccountButton = false;
            isSettingButton = false;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: colorWhite),
            SizedBox(height: 5.0,),
            Text(text, style: TextStyle(fontSize: _textSize, color: colorWhite)),
            SizedBox(height: 5.0,),
            Container(width: 40.0, height: 2.0, color: isHomeButton ? colorWhite : colorPrimaryRed,)
          ],
        ),
      ),
    );
  }

  _dashboardButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = false;
            isDashboardButton = true;
            isAccountButton = false;
            isSettingButton = false;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: colorWhite),
            SizedBox(height: 5.0,),
            Text(text, style: TextStyle(fontSize: _textSize, color: colorWhite)),
            SizedBox(height: 5.0,),
            Container(width: 52.0, height: 2.0, color: isDashboardButton ? colorWhite : colorPrimaryRed,)
          ],
        ),
      ),
    );
  }

  _accountButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = false;
            isDashboardButton = false;
            isAccountButton = true;
            isSettingButton = false;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: colorWhite),
            SizedBox(height: 5.0,),
            Text(text, style: TextStyle(fontSize: _textSize, color: colorWhite)),
            SizedBox(height: 5.0,),
            Container(width: 48.0, height: 2.0, color: isAccountButton ? colorWhite : colorPrimaryRed,)
          ],
        ),
      ),
    );
  }

  _settingsButton({String text, IconData iconName}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          setState(() {
            isHomeButton = false;
            isDashboardButton = false;
            isAccountButton = false;
            isSettingButton = true;
          });
        },
        child: Column(
          children: <Widget>[
            Icon(iconName, size: _iconSize, color: colorWhite),
            SizedBox(height: 5.0,),
            Text(text, style: TextStyle(fontSize: _textSize, color: colorWhite)),
            SizedBox(height: 5.0,),
            Container(width: 50.0, height: 2.0, color: isSettingButton ? colorWhite : colorPrimaryRed,)
          ] ),
      ),
    );
  }


  Future _retrieveDataFromDb() async {
    FirebaseDatabase databaseReference = FirebaseDatabase.instance;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isIdVerified;

    databaseReference.reference().child("profile_info").child(prefs.getString("currentUser"))
        .once().then((DataSnapshot dataSnapShot){
      isIdVerified = dataSnapShot.value["isIdVerified"];
      setState(() {
        _businessOrAgencyName = dataSnapShot.value["businessOrAgencyName"];
        _phoneNumber = dataSnapShot.value["phoneNumber"];
        _profileImageUrl = dataSnapShot.value["profileImageUrl"];
        _desc = dataSnapShot.value["desc"];
        _totalBalance = dataSnapShot.value["totalBalance"];
        _email = dataSnapShot.value["email"];
        _address = dataSnapShot.value["address"];
        _totalMoneyEarned = dataSnapShot.value["totalMoneyEarned"];
        _firstName = dataSnapShot.value["firstName"];
        _lastName = dataSnapShot.value["lastName"];
        _userId = dataSnapShot.value["userId"];
        _userCategory = dataSnapShot.value["userCategory"];
        _totalMoneyWithdraw = dataSnapShot.value["totalMoneyWithdraw"];
        _totalBalance = dataSnapShot.value["totalBalance"];
        _noOfRegisteredRiders = dataSnapShot.value["noOfRegisteredRiders"];

        if (isIdVerified == "true"){
          _isIdVerified = "Verified";
        } else if (isIdVerified == "false"){
          _isIdVerified = "Not verified";
        }
      });
    });

  }


}
