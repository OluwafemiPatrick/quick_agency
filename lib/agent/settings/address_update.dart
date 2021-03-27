import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:quickseen_agent/service/firebase_methds.dart';
import 'package:quickseen_agent/shared/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickseen_agent/shared/colors.dart';


class AddressUpdate extends StatefulWidget {

  final String address1, address2, address3, address4, address5, address6, address7, address8, address9, address10,
      contactName1, contactName2, contactName3, contactName4, contactName5, contactName6, contactName7, contactName8, contactName9, contactName10,
      contactNum1, contactNum2, contactNum3, contactNum4, contactNum5, contactNum6, contactNum7, contactNum8, contactNum9, contactNum10;

  AddressUpdate(
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
      this.contactNum10);

  @override
  _AddressUpdateState createState() => _AddressUpdateState();
}

class _AddressUpdateState extends State<AddressUpdate> {

  SharedPreferences prefs;

  Geolocator _geoLocator = Geolocator()..forceAndroidLocationManager;
  Set<Marker> _markers = {};
  GoogleMapController googleMapController;
  Location location = new Location();

  String _address1, _address2, _address3, _address4, _address5, _address6, _address7, _address8, _address9, _address10,
      _contactName1, _contactName2, _contactName3, _contactName4, _contactName5, _contactName6, _contactName7, _contactName8, _contactName9,
      _contactName10, _contactNum1, _contactNum2, _contactNum3, _contactNum4, _contactNum5, _contactNum6, _contactNum7, _contactNum8,
      _contactNum9, _contactNum10;

  LatLng _loc1, _loc2, _loc3, _loc4, _loc5, _loc6, _loc7, _loc8, _loc9, _loc10, _currentLoc=LatLng(7.510480, 4.548158);

  double _textSize = 15.0;
  bool _serviceEnabled;

  bool _isMapSelected = false;
  bool _isMapSelected1 = false;
  bool _isMapSelected2 = false;
  bool _isMapSelected3 = false;
  bool _isMapSelected4 = false;
  bool _isMapSelected5 = false;
  bool _isMapSelected6 = false;
  bool _isMapSelected7 = false;
  bool _isMapSelected8 = false;
  bool _isMapSelected9 = false;
  bool _isMapSelected10 = false;


  @override
  void initState() {
    _enableGps();
    _retrieveDataFromPreviousPage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            backgroundColor: colorPrimaryRed,
            iconTheme: IconThemeData(color: colorWhite, size: 10),
            centerTitle: true,
            title: Text('Address Update', style: TextStyle(color: colorWhite),)
        ),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          child: mainSwitch()
        )
    );
  }


  Widget mainSwitch(){
    if (_isMapSelected == true){
      return Stack(
        children: [
          _mapSelectContainer1(),
          _mapSelectContainer2(),
          _mapSelectContainer3(),
          _mapSelectContainer4(),
          _mapSelectContainer5(),
          _mapSelectContainer6(),
          _mapSelectContainer7(),
          _mapSelectContainer8(),
          _mapSelectContainer9(),
          _mapSelectContainer10(),
        ]);
    }
    else {
      return Column(
        children: [
          Expanded(
            child: ListView(
                children: [
                  _body1(),
                  _body2(),
                  _body3(),
                  _body4(),
                  _body5(),
                  _body6(),
                  _body7(),
                  _body8(),
                  _body9(),
                  _body10(),
                ]),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10.0),
            child: FlatButton(
              color: colorRedShade,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Text("Save Changes", style: TextStyle(fontSize: 18.0, color: colorWhite),),
              onPressed: () { },
            ),
          ),
        ],
      );
    }
  }


  Widget _body1(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address1=="empty" || _address1=="" ? "Office address 1" : _address1, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog1(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName1 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum1 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5,),
      ],
    );
  }

  Widget _body2(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address2=="empty" || _address2=="" ? "Office address 2" : _address2, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog2(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName2 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum2 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body3(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address3=="empty" || _address3=="" ? "Office address 3" : _address3, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog3(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName3 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum3 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body4(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address4=="empty" || _address4=="" ? "Office address 4" : _address4, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog4(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName4 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum4 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body5(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address5=="empty" || _address5=="" ? "Office address 5" : _address5, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog5(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName5 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum5 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body6(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address6=="empty" || _address6=="" ? "Office address 6" : _address6, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog6(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName6 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum6 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body7(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address7=="empty" || _address7=="" ? "Office address 7" : _address7, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog7(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName7 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum7 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body8(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address8=="empty" || _address8=="" ? "Office address 8" : _address8, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog8(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName8 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum8 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body9(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address9=="empty" || _address9=="" ? "Office address 9" : _address9, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog9(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName9 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum9 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _body10(){
    return Column(
      children: [
        SizedBox(height: 20.0,),
        Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorBoxBackground),
              borderRadius: BorderRadius.circular(10.0),),
            child: FlatButton(
              child: Center(
                  child: Text(_address10=="empty" || _address10=="" ? "Office address 10" : _address10, style: TextStyle(
                      fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
              ),
              onPressed: (){
                _locationSelectDialog10(context);
              },
            )
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.name,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent name",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactName10 = value);
                        },
                      )
                  ),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBoxBackground),
                        borderRadius: BorderRadius.circular(10.0),),
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(
                          hintText: "Contact agent phone",
                          hintStyle: TextStyle(fontSize: 14.0),
                          labelStyle: null,
                        ),
                        onChanged: (value){
                          setState(() => _contactNum10 = value);
                        },
                      )
                  ),
                ),
              ]),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }

  Widget _mapContainerSwitch(){
    if (_isMapSelected1 == true){
      return _mapSelectContainer1();
    }
    if (_isMapSelected2 == true){
      return _mapSelectContainer2();
    }
    if (_isMapSelected3 == true){
      return _mapSelectContainer3();
    }
    if (_isMapSelected4 == true){
      return _mapSelectContainer4();
    }
    if (_isMapSelected5 == true){
      return _mapSelectContainer5();
    }
    if (_isMapSelected6 == true){
      return _mapSelectContainer6();
    }
    if (_isMapSelected7 == true){
      return _mapSelectContainer7();
    }
    if (_isMapSelected8 == true){
      return _mapSelectContainer8();
    }
    if (_isMapSelected9 == true){
      return _mapSelectContainer9();
    }
    else if (_isMapSelected10 == true){
      return _mapSelectContainer10();
    }
  }



  Widget _mapSelectContainer1() {
    return Visibility(
        visible: _isMapSelected1,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap1,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc1 = null;
                            _address1 = "";
                            _isMapSelected1 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected2 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer2() {
    return Visibility(
        visible: _isMapSelected2,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap2,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc2 = null;
                            _address2 = "";
                            _isMapSelected2 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected2 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer3() {
    return Visibility(
        visible: _isMapSelected3,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap3,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc3 = null;
                            _address3 = "";
                            _isMapSelected3 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected3 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer4() {
    return Visibility(
        visible: _isMapSelected4,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap4,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc4 = null;
                            _address4 = "";
                            _isMapSelected4 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected4 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer5() {
    return Visibility(
        visible: _isMapSelected5,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap5,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc5 = null;
                            _address5 = "";
                            _isMapSelected5 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected5 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer6() {
    return Visibility(
        visible: _isMapSelected6,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap6,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc6 = null;
                            _address6 = "";
                            _isMapSelected6 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected6 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer7() {
    return Visibility(
        visible: _isMapSelected7,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap7,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc7 = null;
                            _address7 = "";
                            _isMapSelected7 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected7 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer8() {
    return Visibility(
        visible: _isMapSelected8,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap8,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc8 = null;
                            _address8 = "";
                            _isMapSelected8 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected8 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer9() {
    return Visibility(
        visible: _isMapSelected9,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap9,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc9 = null;
                            _address9 = "";
                            _isMapSelected9 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected9 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }

  Widget _mapSelectContainer10() {
    return Visibility(
        visible: _isMapSelected10,
        child: Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _currentLoc, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onTap: _handleTap10,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                ),
              ),
              Container(
                height: 34.0,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryBlue,
                        child: Text("Dismiss", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _loc10 = null;
                            _address10 = "";
                            _isMapSelected10 = false;
                          });
                        },
                      ),
                      FlatButton(
                        minWidth: 120.0,
                        color: colorPrimaryGreen,
                        child: Text("Confirm", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                        onPressed: () {
                          setState(() {
                            _isMapSelected = false;
                            _isMapSelected10 = false;
                          });
                        },
                      ),
                    ]),
              ),
            ])
    );
  }



  Future _locationSelectDialog1(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation1();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = true;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog2(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation2();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = true;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog3(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation3();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = true;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog4(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation4();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = true;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog5(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation5();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = true;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog6(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation6();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = true;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog7(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation7();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = true;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog8(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation8();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = true;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog9(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation9();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = true;
                                  _isMapSelected10 = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future _locationSelectDialog10(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 320.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Select a location",
                            style: TextStyle(fontSize: 26.0, color: colorPrimaryRed, fontWeight: FontWeight.bold),)),
                      SizedBox(height: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("my current location",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _getCurrentLocation10();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isMapSelected = true;
                                  _isMapSelected1 = false;
                                  _isMapSelected2 = false;
                                  _isMapSelected3 = false;
                                  _isMapSelected4 = false;
                                  _isMapSelected5 = false;
                                  _isMapSelected6 = false;
                                  _isMapSelected7 = false;
                                  _isMapSelected8 = false;
                                  _isMapSelected9 = false;
                                  _isMapSelected10 = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        width: double.infinity,
                        height: 40.0,
                        child: FlatButton(
                            color: colorPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: colorPrimaryRed),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Dismiss", style: TextStyle(
                                color: Colors.white, fontSize: 18.0),)
                        ),
                      ),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }



  _enableGps() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        _getUserLocation();
      } else if (!_serviceEnabled) {
        return null;
      }
    } else if (_serviceEnabled) {
      _getUserLocation();
    }
  }

  _getCurrentLocation1() async {
    _loc1 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc1 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress1();
    });
  }

  _getCurrentLocation2() async {
    _loc2 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc2 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress2();
    });
  }

  _getCurrentLocation3() async {
    _loc3 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc3 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress3();
    });
  }

  _getCurrentLocation4() async {
    _loc4 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc4 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress4();
    });
  }

  _getCurrentLocation5() async {
    _loc5 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc5 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress5();
    });
  }

  _getCurrentLocation6() async {
    _loc6 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc6 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress6();
    });
  }

  _getCurrentLocation7() async {
    _loc7 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc7 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress7();
    });
  }

  _getCurrentLocation8() async {
    _loc8 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc8 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress8();
    });
  }

  _getCurrentLocation9() async {
    _loc9 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc9 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress9();
    });
  }

  _getCurrentLocation10() async {
    _loc10 = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _loc10 = LatLng(position.latitude, position.longitude);
      _getCurrentAddress10();
    });
  }


  _getCurrentAddress1() async{
    if(_loc1 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc1.latitude, _loc1.longitude);
        Placemark place = p[0];
        setState(() => _address1 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress2() async{
    if(_loc2 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc2.latitude, _loc2.longitude);
        Placemark place = p[0];
        setState(() => _address2 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress3() async{
    if(_loc3 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc3.latitude, _loc3.longitude);
        Placemark place = p[0];
        setState(() => _address3 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress4() async{
    if(_loc4 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc4.latitude, _loc4.longitude);
        Placemark place = p[0];
        setState(() => _address4 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress5() async{
    if(_loc5 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc5.latitude, _loc5.longitude);
        Placemark place = p[0];
        setState(() => _address5 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress6() async{
    if(_loc6 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc6.latitude, _loc6.longitude);
        Placemark place = p[0];
        setState(() => _address6 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress7() async{
    if(_loc7 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc7.latitude, _loc7.longitude);
        Placemark place = p[0];
        setState(() => _address7 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress8() async{
    if(_loc8 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc8.latitude, _loc8.longitude);
        Placemark place = p[0];
        setState(() => _address8 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress9() async{
    if(_loc9 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc9.latitude, _loc9.longitude);
        Placemark place = p[0];
        setState(() => _address9 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getCurrentAddress10() async{
    if(_loc10 != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _loc10.latitude, _loc10.longitude);
        Placemark place = p[0];
        setState(() => _address10 = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
            "${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.isoCountryCode}");
      }
      catch(e){
        print(e);
        toastMessage(e.toString());
      }
    }
  }

  _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() => _currentLoc = LatLng(position.latitude, position.longitude));
  }


  _handleTap1(LatLng point) {
    _markers.clear();
    setState(() {
      _loc1 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 1",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress1();
    });
  }

  _handleTap2(LatLng point) {
    _markers.clear();
    setState(() {
      _loc2 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 2",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress2();
    });
  }

  _handleTap3(LatLng point) {
    _markers.clear();
    setState(() {
      _loc3 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 3",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress3();
    });
  }

  _handleTap4(LatLng point) {
    _markers.clear();
    setState(() {
      _loc4 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 4",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress4();
    });
  }

  _handleTap5(LatLng point) {
    _markers.clear();
    setState(() {
      _loc5 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 5",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress5();
    });
  }

  _handleTap6(LatLng point) {
    _markers.clear();
    setState(() {
      _loc6 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 6",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress6();
    });
  }

  _handleTap7(LatLng point) {
    _markers.clear();
    setState(() {
      _loc7 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 7",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress7();
    });
  }

  _handleTap8(LatLng point) {
    _markers.clear();
    setState(() {
      _loc8 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 8",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress8();
    });
  }

  _handleTap9(LatLng point) {
    _markers.clear();
    setState(() {
      _loc9 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 9",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress9();
    });
  }

  _handleTap10(LatLng point) {
    _markers.clear();
    setState(() {
      _loc9 = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Office Address 10",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress10();
    });
  }


  _onCameraMove(CameraPosition position) {
    _currentLoc = position.target;
  }

  _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  _sendDataToDB(){
    FirebaseMethods _fireMethods = new FirebaseMethods();
    _fireMethods.uploadAddressToDB(
        _address1, _address2, _address3, _address4, _address5, _address6, _address7, _address8, _address9, _address10,
        _contactName1, _contactName2, _contactName3, _contactName4, _contactName5, _contactName6, _contactName7,
        _contactName8, _contactName9, _contactName10, _contactNum1, _contactNum2, _contactNum3, _contactNum4, _contactNum5,
        _contactNum6, _contactNum7, _contactNum8, _contactNum9, _contactNum10);
  }

  _retrieveDataFromPreviousPage(){
    setState(() {
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
