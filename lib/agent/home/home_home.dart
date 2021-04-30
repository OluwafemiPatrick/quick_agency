import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/home/home_data_model.dart';
import 'package:quickseen_agent/agent/home/register_new_rider.dart';
import 'package:quickseen_agent/agent/home/rider_account_details.dart';
import 'package:quickseen_agent/agent/settings/identity_verification.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/colors.dart';
import '../../shared/toast_message.dart';

class HomeHomeAgent extends StatefulWidget {

  final String agencyId, agencyBusinessName, agencyProfileUrl, isIdVerified, firstName, lastName, noOfRegisteredRiders;

  HomeHomeAgent(this.agencyId, this.agencyBusinessName, this.agencyProfileUrl,
      this.isIdVerified, this.firstName, this.lastName, this.noOfRegisteredRiders);

  @override
  _HomeHomeAgentState createState() => _HomeHomeAgentState();
}

class _HomeHomeAgentState extends State<HomeHomeAgent> {

  List<MyRiderList> riderList = [];
  SharedPreferences prefs;

  bool _isIdNotVerified = false;
  String _isIdVerifiedString, _firstName, _lastName, _noOfRegisteredRiders;
  String _agencyId, _agencyBusinessName, _agencyProfileUrl;
  String _info = "On the verification page of the rider app, rider can click on your agency tab to open the direction page.\nOn this page,"
      " ask the rider to click on 'Send my ID to Agency' button. The rider ID will be displayed below." ;

  @override
  void initState() {
    _fetchDetailsFromPreviousPage();
    fetchMyRidersFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar(backgroundColor: colorPrimaryRed)),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorBackground,
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  fetchMyRidersFromDB();
                },
                child: Column(
                  children: [
                    newRider(),
                    Divider(thickness: 1.5, height: 30.0,),
                    Expanded(
                      child: riderList.length>0 ? ListView.builder(
                        itemCount: riderList.length,
                        itemBuilder: (_, index){
                          return _riderList(
                            riderList[index].riderMail,
                              riderList[index].riderName,
                              riderList[index].profileImage,
                              riderList[index].riderId,
                          );
                        }) : Center(child: Text("You have 0 registered riders",)),
                    )
                  ]),
              )
            ),
            Column(
              children: [
                Expanded(child: Container(child: null,)),
                _iDNotVerified(),
              ],
            ),
          ],
        ),
    );
  }

  Widget newRider(){
    return Container(
      height: 42.0,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: colorRedShade),
        borderRadius: BorderRadius.circular(10.0),),
      child: FlatButton(
        child: Center(
          child: Text("Register new Rider", style: TextStyle(
            fontSize: 16.0, color: colorBrown, fontWeight: FontWeight.bold),)
        ),
        onPressed: () async {
          prefs = await SharedPreferences.getInstance();

          DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("id_verification");
          databaseReference.child(prefs.getString("currentUser")).once().then((DataSnapshot dataSnapshot){
            String newRiderId = dataSnapshot.value["riderId"];
            toastMessage(newRiderId);
            enterId(context, newRiderId);
          });
        },
      )
    );
  }

  Widget _iDNotVerified(){
    String toMakeQuickSeen = "Dear user, to make QuickSeen safe for everyone of us, we would like you to verify your identity.\n"
        "This will be required before you can start registering riders on the QuickSeen platform.";

    return Visibility(
      visible: _isIdNotVerified,
      child: Container(
        height: 220.0,
        padding: EdgeInsets.fromLTRB(12.0, 10.0, 8.0, 10.0),
        margin: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        decoration: new BoxDecoration(
            color: colorWhite,
            borderRadius: new BorderRadius.only(
                topLeft:  const  Radius.circular(20.0),
                topRight: const  Radius.circular(20.0))
        ),
        child: Column(
          children: [
            Text("We need to verify your identity", style: TextStyle(fontSize: 20.0,
                color: colorPrimaryRed, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),),
            SizedBox(height: 25.0),
            Expanded(child: Text(toMakeQuickSeen,
              style: TextStyle(fontSize: 15.0, color: colorPrimaryBlue),
              textAlign: TextAlign.center,
            )),
            Container(
              height: 35.0,
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                  child: Text("Proceed to Identity Verification", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  color: colorPrimaryBlue,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => IdentityVerification(
                          _firstName, _lastName, _agencyBusinessName, _agencyProfileUrl, _agencyId, _isIdVerifiedString),
                    ), (route) => false,
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _riderList(String email, username, profileImage, riderId){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45.0,
                width: 45.0,
                margin: EdgeInsets.only(right: 10.0),
                child: Image.network(profileImage),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: TextStyle(
                      fontSize: 16.0, color: colorBlack),
                    ),
                    SizedBox(height: 4.0),
                    Text(email, style: TextStyle(
                      fontSize: 15.0, color: colorBlack),
                    ),
                    Divider(thickness: 1.5)
                  ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0,),
                child: Icon(Icons.arrow_forward_ios, size: 20.0,),
              ),
            ]),
          FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 30.0,
            child: null,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RiderProfileDetails(
                  riderId, _agencyId, _agencyBusinessName, _agencyProfileUrl)));
            },
          )
        ],
      ),
    );
  }


  Future enterId(BuildContext context, String riderId) async {

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            height: 300.0,
            child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text("Request Rider ID", style: TextStyle(fontSize: 17.0, color: colorBlack, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.0,),
                  Expanded(child: Text(_info, style: TextStyle(fontSize: 13.0),)),
                  SizedBox(height: 10.0,),
                  Text(riderId!=null ? riderId : ""),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: colorBrown,
                    margin: EdgeInsets.only(top: 2.0),
                  ),
                  SizedBox(height: 40.0,),
                  Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                        child: Text("Verify", style: TextStyle(fontSize: 15.0, color: colorWhite),),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        color: colorPrimaryBlue,
                        onPressed: () async {
                          Navigator.pop(context);
                          if (riderId!=null && riderId.isNotEmpty){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterNewRider(riderId)));
                          } else{
                            toastMessage("Rider ID cannot be empty");
                          }
                        }
                    ),
                  ),
                ]),
          ),

        );
      },
    );

  }

  Future fetchMyRidersFromDB() async {
    FirebaseDatabase databaseReference = FirebaseDatabase.instance;
    prefs = await SharedPreferences.getInstance();

    databaseReference.reference().child("my_riders").child(prefs.getString("currentUser")).once().then((DataSnapshot dataSnapshot) {
      riderList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys){
        MyRiderList data = new MyRiderList(
          values [key]["riderId"],
          values [key]["riderMail"],
          values [key]["riderName"],
          values [key]["profileImage"],
        );
        riderList.add(data);
      }
      setState(() { });
    });
  }


  _fetchDetailsFromPreviousPage(){
    FirebaseDatabase databaseReference = FirebaseDatabase.instance;

    setState(() {
      _isIdVerifiedString = widget.isIdVerified;
      _agencyId = widget.agencyId;
      _agencyBusinessName = widget.agencyBusinessName;
      _agencyProfileUrl = widget.agencyProfileUrl;
      _firstName = widget.firstName;
      _lastName = widget.lastName;
      _noOfRegisteredRiders = widget.noOfRegisteredRiders;
    });

    Timer(
      Duration(seconds: 3), () {
      if (_isIdVerifiedString == null){
        databaseReference.reference().child("profile_info").child(prefs.getString("currentUser"))
            .once().then((DataSnapshot dataSnapShot){
          String isIdVerified = dataSnapShot.value["isIdVerified"];
          setState(() {
            _agencyBusinessName = dataSnapShot.value["businessOrAgencyName"];
            _agencyProfileUrl = dataSnapShot.value["profileImageUrl"];
            _firstName = dataSnapShot.value["firstName"];
            _lastName = dataSnapShot.value["lastName"];
            _agencyId = dataSnapShot.value["userId"];
            _isIdVerifiedString = dataSnapShot.value["isIdVerified"];
            _noOfRegisteredRiders = dataSnapShot.value["noOfRegisteredRiders"];
            if (isIdVerified == "true"){
              _isIdNotVerified = false;
            } else if (isIdVerified == "false"){
              _isIdNotVerified = true;
            }
          });
        });
      }
    },
    );

  }


}
