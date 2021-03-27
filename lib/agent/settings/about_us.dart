import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/settings/contact_Us.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/strings.dart';

class AboutUs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            backgroundColor: colorPrimaryRed,
            iconTheme: IconThemeData(color: colorWhite, size: 10),
            centerTitle: true,
            title: Text('About QuickSeen', style: TextStyle(color: colorWhite),)
        ),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 5.0),
          child: _body(context),
        )
    );
  }

  Widget _body(BuildContext context){
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.20,
            margin: EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
            child: Image.asset("assets/images/full_logo.png", fit: BoxFit.fill)),
        Text("We will make your delivery quicker.", style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold,
            color: colorPrimaryBlue, fontStyle: FontStyle.normal),),
        SizedBox(height: 10.0,),
        Expanded(child: ListView(
          children: [
            Text(aboutUs, style: TextStyle(fontSize: 16.0),),
          ],
        )),
        Container(
          height: 42.0,
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            color: colorRedShade,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Text("Contact us", style: TextStyle(fontSize: 18.0, color: colorWhite),),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUs()));
            },
          ),
        ),
      ],
    );
  }

}
