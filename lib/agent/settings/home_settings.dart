import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/settings/about_us.dart';
import 'package:quickseen_agent/agent/settings/address_update.dart';
import 'package:quickseen_agent/agent/settings/identity_verification.dart';
import 'package:quickseen_agent/agent/settings/profile_details.dart';
import 'package:quickseen_agent/agent/settings/terms_of_service.dart';
import 'package:quickseen_agent/service/auth.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/toast_message.dart';

class HomeSettings extends StatefulWidget {

  final String firstName, lastName, businessName, profileImageLink, agentId, isIdVerified, address1, address2, address3, address4, address5,
      address6, address7, address8, address9, address10, contactName1, contactName2, contactName3, contactName4, contactName5, contactName6,
      contactName7, contactName8, contactName9, contactName10, contactNum1, contactNum2, contactNum3, contactNum4, contactNum5, contactNum6,
      contactNum7, contactNum8, contactNum9, contactNum10, profileDesc;

  HomeSettings(
      this.firstName,
      this.lastName,
      this.businessName,
      this.profileImageLink,
      this.agentId,
      this.isIdVerified,
      this.address1,
      this.address2,
      this.address3,
      this.address4,
      this.address5,
      this.address6,
      this.address7,
      this.address8,
      this.address9,
      this.address10,
      this.contactName1,
      this.contactName2,
      this.contactName3,
      this.contactName4,
      this.contactName5,
      this.contactName6,
      this.contactName7,
      this.contactName8,
      this.contactName9,
      this.contactName10,
      this.contactNum1,
      this.contactNum2,
      this.contactNum3,
      this.contactNum4,
      this.contactNum5,
      this.contactNum6,
      this.contactNum7,
      this.contactNum8,
      this.contactNum9,
      this.contactNum10,
      this.profileDesc,
    );

  @override
  _HomeSettingsState createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<HomeSettings> {

  double _textSize = 17.0;

  String _firstName, _lastName, _businessName, _profileImageLink, _agentId, _isIdVerified, _profileDesc;
  String _address1, _address2, _address3, _address4, _address5, _address6, _address7, _address8, _address9, _address10,
      _contactName1, _contactName2, _contactName3, _contactName4, _contactName5, _contactName6, _contactName7, _contactName8, _contactName9,
      _contactName10, _contactNum1, _contactNum2, _contactNum3, _contactNum4, _contactNum5, _contactNum6, _contactNum7, _contactNum8, _contactNum9, _contactNum10;


  @override
  void initState() {
    _retrieveDataFromPreviousPage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar(backgroundColor: colorPrimaryRed)),
        body: _body()
    );
  }


  Widget _body(){
    return Container(
      color:colorBackground,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 10.0, top: 35.0, bottom: 10.0, right: 10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton(
              child: Container(
                width: MediaQuery.of(context).size.width,
                  child: Text("Profile settings", style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue),)
              ),
              onPressed: () {
                toastMessageLong("work in progress ...");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileDetails(_profileImageLink, _profileDesc)));
              },
            ),
            Divider(thickness: 2.0, height: 30.0,),
            FlatButton(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text("Identity verification", style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue),)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => IdentityVerification(
                    _firstName, _lastName, _businessName, _profileImageLink, _agentId, _isIdVerified)));
              },
            ),
            Divider(thickness: 2.0, height: 30.0,),
            // FlatButton(
            //   child: Container(
            //       width: MediaQuery.of(context).size.width,
            //       child: Text("Address Update", style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue),)),
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressUpdate(
            //         _address1, _address2, _address3, _address4, _address5, _address6, _address7, _address8, _address9, _address10,
            //         _contactName1, _contactName2, _contactName3, _contactName4, _contactName5, _contactName6, _contactName7,
            //         _contactName8, _contactName9, _contactName10, _contactNum1, _contactNum2, _contactNum3, _contactNum4, _contactNum5,
            //         _contactNum6, _contactNum7, _contactNum8, _contactNum9, _contactNum10)));
            //   },
            // ),
            // Divider(thickness: 2.0, height: 30.0,),
            FlatButton(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text("About us", style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue),)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            Divider(thickness: 2.0, height: 30.0,),
            FlatButton(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text("Terms of service", style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue),)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsOfService()));
              },
            ),
            Divider(thickness: 2.0, height: 30.0,),
            FlatButton(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text("Log out", style: TextStyle(fontSize: _textSize, color: colorPrimaryRed),)),
              onPressed: () async {
                logoutDialog(context);
              },
            ),
          ]),
    );
  }


  Future logoutDialog(BuildContext context){
    final QuickAuthService _auth = new QuickAuthService();
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: 140.0,
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Text("Logout of QuickSeen?", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0, color: colorPrimaryRed),),
                    Expanded(child: Container()),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 32.0,
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: FlatButton(
                              child: Text("No", style: TextStyle(fontSize: 15.0, color: colorWhite),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              color: colorPrimaryBlue,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            height: 32.0,
                            child: FlatButton(
                                child: Text("Yes, logout", style: TextStyle(fontSize: 15.0, color: colorWhite),),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                color: colorPrimaryGreen,
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _auth.signOut();
                                  // Navigator.pushAndRemoveUntil(
                                  //   context, MaterialPageRoute(
                                  //   builder: (BuildContext context) => SplashScreen(),
                                  // ), (route) => false,
                                  // );
                                }
                            ),
                          ),
                        ]),
                  ]),
            ),
          );
        }
    );
  }

  _retrieveDataFromPreviousPage(){
    setState(() {
      _firstName = widget.firstName;
      _lastName = widget.lastName;
      _businessName = widget.businessName;
      _profileImageLink = widget.profileImageLink;
      _agentId = widget.agentId;
      _isIdVerified = widget.isIdVerified;
      _profileDesc = widget.profileDesc;

      _address1 = widget.address1;
      _address2 = widget.address2;
      _address3 = widget.address3;
      _address4 = widget.address4;
      _address5 = widget.address5;
      _address6 = widget.address6;
      _address7 = widget.address7;
      _address8 = widget.address8;
      _address9 = widget.address9;
      _address10 = widget.address10;

      _contactName1 = widget.contactName1;
      _contactName2 = widget.contactName2;
      _contactName3 = widget.contactName3;
      _contactName4 = widget.contactName4;
      _contactName5 = widget.contactName5;
      _contactName6 = widget.contactName6;
      _contactName7 = widget.contactName7;
      _contactName8 = widget.contactName8;
      _contactName9 = widget.contactName9;
      _contactName10 = widget.contactName10;
      _contactNum1 = widget.contactNum1;
      _contactNum2 = widget.contactNum2;
      _contactNum3 = widget.contactNum3;
      _contactNum4 = widget.contactNum4;
      _contactNum5 = widget.contactNum5;
      _contactNum6 = widget.contactNum6;
      _contactNum7 = widget.contactNum7;
      _contactNum8 = widget.contactNum8;
      _contactNum9 = widget.contactNum9;
      _contactNum10 = widget.contactNum10;

    });
  }


}
