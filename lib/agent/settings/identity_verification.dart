import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' hide Location;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:quickseen_agent/home/home_agent.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:quickseen_agent/shared/strings.dart';
import 'package:quickseen_agent/shared/toast_message.dart';


class IdentityVerification extends StatefulWidget {

  final String firstName, lastName, businessName, profileImageLink, agentId, isIdVerified;
  IdentityVerification(this.firstName, this.lastName, this.businessName,
      this.profileImageLink, this.agentId, this.isIdVerified);

  @override
  _IdentityVerificationState createState() => _IdentityVerificationState();
}

class _IdentityVerificationState extends State<IdentityVerification> {

  File _imageFile1, _imageFile2;
  LatLng _currentLocation = LatLng(7.510480, 4.548158);

  Geolocator _geoLocator = Geolocator()..forceAndroidLocationManager;
  Set<Marker> _markers = {};
  GoogleMapController googleMapController;
  Location location = new Location();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);


  double _textSize = 15.0;

  bool _serviceEnabled;
  bool _isBody1 = true;
  bool _isBody2 = false;
  bool _isBody3 = false;
  bool _isBody4 = false;
  bool _isBody5 = false;
  bool _isBody6 = false;
  bool _isLoading = false;
  bool _isMapSelected = false;

  String _businessName, _firstName, _lastName, _mainAddress, _contactName, _contactPhone, _message='';
  String _imageOneString, _imageTwoString, _profileImageLink, _agentId, _isIdVerified;
  String _text = "To get you started on the QuickSeen Logistic Platform, kindly provide the following details";
  String _seekHelp = "Should you require help at any point during the verification, please reach out to our customer care "
      "representative on 08012345678 or hello@quickseen.com";
  String _officeAddress = "Office addresses. (You can register up to 10)";
  String _governmentIssuedId = "Any government issued identity card (national Id card, voters card, or international passport).";
  String _proofOfCompanyReg = "Proof of company registration.";


  @override
  void initState() {
    _retrieveDataFromPreviousPage();
    _enableGps();
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
            title: Text('Identity Verification', style: TextStyle(color: colorWhite),)
        ),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Column(
            children: [
              _topSection(context, _profileImageLink, _firstName, _lastName, _businessName),
              Divider(thickness: 1.5, height: 15.0,),
              SizedBox(height: 20.0,),
              Expanded(child: Stack(
                children: [
                  _body1(context),
                  _body2(context),
                  _body3(context),
                  _body4(context),
                  _body5(context),
                  _body6(context),
                  _mapSelectContainer(),
                  Visibility(
                    visible: _isLoading,
                    child: Column(
                      children: [
                        Expanded(child: Spinner()),
                        Text(_message)
                      ],
                    )
                  ),
                ])
              ),
            ]),
        )
    );
  }

  Widget _topSection(BuildContext context, String profileImageLink, firstName, lastName, agencyBusinessName){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.25,
            margin: EdgeInsets.only(right: 15.0),
            child: Image.asset("assets/images/profile_image.png")
        ),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.0),
                  Text("Welcome", style: TextStyle(fontSize: 15.0),),
                  SizedBox(height: 6.0,),
                  Row(children: [
                    Text(firstName, style: TextStyle(fontSize: 17.0,
                        fontWeight: FontWeight.bold, color: colorPrimaryBlue
                    ),),
                    SizedBox(width: 5.0),
                    Text(lastName, style: TextStyle(fontSize: 17.0,
                        fontWeight: FontWeight.bold, color: colorPrimaryBlue
                    ),),
                  ]),
                  SizedBox(height: 6.0,),
                  Text(agencyBusinessName, style: TextStyle(fontSize: 17.0,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: colorPrimaryBlue
                  ),),
                ])
        )
      ],);
  }

  Widget _body1(BuildContext context){
    return Visibility(
      visible: _isBody1,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_text, style: TextStyle(fontSize: _textSize+1),),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0, top: 15.0),
                  child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                        SizedBox(width: 6.0),
                        Expanded(child: Text("Business name", style: TextStyle(fontSize: _textSize),)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0, top: 12.0),
                  child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                        SizedBox(width: 6.0),
                        Expanded(child: Text(_officeAddress, style: TextStyle(fontSize: _textSize),)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0, top: 12.0),
                  child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                        SizedBox(width: 6.0),
                        Expanded(child: Text(_governmentIssuedId, style: TextStyle(fontSize: _textSize),)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2.0, top: 12.0, bottom: 15.0),
                  child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                        SizedBox(width: 6.0),
                        Expanded(child: Text(_proofOfCompanyReg, style: TextStyle(fontSize: _textSize),)),
                      ]),
                ),
                Text(_seekHelp, style: TextStyle(fontSize: _textSize+1),),
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Get Started", style: TextStyle(fontSize: 18.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () async {
                  setState(() {
                    _isBody1 = false;
                    _isBody2 = true;
                    _isBody3 = false;
                    _isBody4 = false;
                    _isBody5 = false;
                    _isBody6 = false;
                    _isMapSelected = false;
                  });
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _body2(BuildContext context){
    return Visibility(
      visible: _isBody2,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Please enter your business name.", style: TextStyle(fontSize: _textSize+1, fontWeight: FontWeight.bold),),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration( hintText: _businessName),
                    onChanged: (value){
                      setState(() => _businessName = value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Proceed", style: TextStyle(fontSize: 18.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () async {
                  setState(() {
                    _isBody1 = false;
                    _isBody2 = false;
                    _isBody3 = true;
                    _isBody4 = false;
                    _isBody5 = false;
                    _isBody6 = false;
                    _isMapSelected = false;
                  });
                }
            ),
          ),
        ],),
    );
  }

  Widget _body3(BuildContext context){
    return Visibility(
      visible: _isBody3,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Upload a copy of any government issued Identity card.\nEnsure that names and picture are clearly visible, "
                    "and all four edges of the card must be captured by the camera.", style: TextStyle(fontSize: _textSize, fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                Expanded(
                  child: GestureDetector(
                    child: _imageFile1==null ? Image.asset("assets/images/gallery_icon.png")
                        : Image.file(_imageFile1, fit: BoxFit.fill,),
                    onTap: () => openCameraDialog1(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Proceed", style: TextStyle(fontSize: 18.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () async {
                  if(_imageFile1 != null){
                    setState(() {
                      _isBody1 = false;
                      _isBody2 = false;
                      _isBody3 = false;
                      _isBody4 = true;
                      _isBody5 = false;
                      _isBody6 = false;
                      _isMapSelected = false;
                    });
                  } else{
                    toastMessage("Please upload an identification card");
                  }
                }
            ),
          ),
        ],),
    );
  }

  Widget _body4(BuildContext context){
    return Visibility(
      visible: _isBody4,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Proof of company registration - certificate upload", style: TextStyle(fontSize: _textSize, fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                Expanded(
                  child: GestureDetector(
                    child: _imageFile2==null ? Image.asset("assets/images/gallery_icon.png")
                        : Image.file(_imageFile2, fit: BoxFit.fill,),
                    onTap: () => openCameraDialog2(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Proceed", style: TextStyle(fontSize: 18.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () async {
                  if (_imageFile2 != null){
                    setState(() {
                      _isBody1 = false;
                      _isBody2 = false;
                      _isBody3 = false;
                      _isBody4 = false;
                      _isBody5 = true;
                      _isBody6 = false;
                      _isMapSelected = false;
                    });
                  } else{
                    toastMessage("Please upload proof of company registration");
                  }
                }
            ),
          ),
        ]),
    );
  }

  Widget _body5(BuildContext context){
    return Visibility(
      visible: _isBody5,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    Text("Company address.", style: TextStyle(fontSize: _textSize, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10.0,),
                    Text("This will be displayed to dispatch riders who wish to register with you. You can"
                        " add more addresses, after verification, on the settings page.", style: TextStyle(fontSize: _textSize),),
                    Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(top: 25.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: colorRedShade),
                          borderRadius: BorderRadius.circular(10.0),),
                        child: FlatButton(
                          child: Center(
                              child: Text(_mainAddress==null ? "Office address" : _mainAddress, style: TextStyle(
                                  fontSize: _textSize, color: colorBrown, fontWeight: FontWeight.bold),)
                          ),
                          onPressed: (){
                            _locationSelectDialog(context);
                          },
                        )
                    ),
                    Divider(thickness: 1.5),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Text("Details of contact agent assigned to office.", style: TextStyle(fontSize: _textSize, fontWeight: FontWeight.bold),),
                    ),
                    Container(
                        height: 42.0,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: colorBrown),
                          borderRadius: BorderRadius.circular(10.0),),
                        child: FlatButton(
                          child: Center(
                              child: TextField(
                                maxLines: 1,
                                keyboardType: TextInputType.name,
                                autofocus: false,
                                decoration: new InputDecoration( hintText: "Contact agent name"),
                                onChanged: (value){
                                  setState(() => _contactName = value);
                                },
                              )
                          ),
                          onPressed: (){ },
                        )
                    ),
                    Container(
                        height: 42.0,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: colorBrown),
                          borderRadius: BorderRadius.circular(10.0),),
                        child: FlatButton(
                          child: Center(
                              child: TextField(
                                maxLines: 1,
                                keyboardType: TextInputType.phone,
                                autofocus: false,
                                decoration: new InputDecoration( hintText: "Contact agent phone"),
                                onChanged: (value){
                                  setState(() => _contactPhone = value);
                                },
                              )
                          ),
                          onPressed: (){ },
                        )
                    ),
                  ]),
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Finish", style: TextStyle(fontSize: 18.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () async {
                  if (_mainAddress!=null && _contactName!=null){
                    setState(() {
                      _isLoading = true;
                      _message = 'Uploading data to database ...';
                      _uploadImageToStorage(context);
                    });
                  } else {
                    toastMessage("kindly provide required details");
                  }
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _body6(BuildContext context){
    return Visibility(
      visible: _isBody6,
      child: Column(
        children: [
          Image.asset("assets/images/success.png",
              width: MediaQuery.of(context).size.width * 0.6,),
          Text("Your details has been successfully submitted.", style: TextStyle(fontSize: _textSize, fontWeight: FontWeight.bold),),
          SizedBox(height: 40.0,),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              child: Text("Proceed to homepage", style: TextStyle(fontSize: 18.0, color: colorWhite),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              color: colorRedShade,
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (BuildContext context) => HomePageAgent(),
                ), (route) => false,
                );
              }
            ),
          )
        ])
    );
  }

  Widget _mapSelectContainer() {
    return Visibility(
        visible: _isMapSelected,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                markers: _markers,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: _currentLocation, zoom: 15),
                onMapCreated: _onMapCreated,
                onTap: _handleTap,
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
                          _currentLocation = null;
                          _mainAddress = "";
                          _isMapSelected = false;
                          _isBody1 = false;
                          _isBody2 = false;
                          _isBody3 = false;
                          _isBody4 = false;
                          _isBody5 = true;
                          _isBody6 = false;
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
                          _isBody1 = false;
                          _isBody2 = false;
                          _isBody3 = false;
                          _isBody4 = false;
                          _isBody5 = true;
                          _isBody6 = false;
                        });
                      },
                    ),
                  ]),
            ),
          ],
        )
    );
  }


  Future openCameraDialog1(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: 160.0,
              child: Column(
                  children: <Widget>[
                    Text("Select image from",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: colorPrimaryBlue),),
                    SizedBox(height: 32.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            _getImageFromCamera1();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_camera.jpeg", height: 60.0, width: 60.0,),
                              SizedBox(height: 6.0,),
                              Text("Camera", style: TextStyle(fontSize: 15.0),)
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _getImageFromGallery1();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_gallery.png", height: 60.0, width: 60.0,),
                              SizedBox(height: 6.0,),
                              Text("Gallery", style: TextStyle(fontSize: 15.0),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          );
        }
    );
  }

  Future openCameraDialog2(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: 160.0,
              child: Column(
                  children: <Widget>[
                    Text("Select image from",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: colorPrimaryBlue),),
                    SizedBox(height: 32.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            _getImageFromCamera2();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_camera.jpeg", height: 60.0, width: 60.0,),
                              SizedBox(height: 6.0,),
                              Text("Camera", style: TextStyle(fontSize: 15.0),)
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _getImageFromGallery2();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_gallery.png", height: 60.0, width: 60.0,),
                              SizedBox(height: 6.0,),
                              Text("Gallery", style: TextStyle(fontSize: 15.0),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          );
        }
    );
  }

  Future _locationSelectDialog(BuildContext context) {
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
                                _getCurrentLocation();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("select location on map",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _displayMapLocationPicker();
                              },
                            ),
                            FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              child: (Text("manual search",
                                style: TextStyle(color: colorPrimaryBlue, fontSize: 16.0),
                              )),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _locationSearch();
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

  Future<void> _getImageFromCamera1() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.camera);
    setState(() => _imageFile1 = File(_image.path));
  }

  Future<void> _getImageFromGallery1() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() => _imageFile1 = File(_image.path));
  }

  Future<void> _getImageFromCamera2() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.camera);
    setState(() => _imageFile2 = File(_image.path));
  }

  Future<void> _getImageFromGallery2() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() => _imageFile2 = File(_image.path));
  }

  Future _setCurrentLocationToDB(LatLng currentLocation) async {
    Geofire.initialize("office_addresses");

    bool response = await Geofire.setLocation(_agentId,
        currentLocation.latitude,
        currentLocation.longitude
    );

    return response;
  }

  Future _writeDataToDB(BuildContext context) async {
    DatabaseReference profileDB = FirebaseDatabase.instance.reference();
    profileDB.child("profile_info").child(_agentId).update({
      "idImageOne" : _imageOneString,
      "idImageTwo" : _imageTwoString,
      "contactAgentName" : _contactName,
      "contactAgentPhone" : _contactPhone,
      "address" : _mainAddress,
      "addressLatLng" : _currentLocation.toString(),
      "businessOrAgencyName" : _businessName,
      "isIdVerified" : "true",
    }).then((value) {
      _setCurrentLocationToDB(_currentLocation);
      setState(() {
        _isLoading = false;
        _isBody5 = false;
        _isBody6 = true;
      });
    });
  }

  Future _uploadImageToStorage(BuildContext context) async {

    var fileName1 = _agentId+'01';
    var fileName2 = _agentId+'02';
    StorageReference firebaseStorageRef1 = FirebaseStorage.instance.ref().child('identities/$fileName1');
    StorageReference firebaseStorageRef2 = FirebaseStorage.instance.ref().child('identities/$fileName2');

    StorageUploadTask uploadTask = firebaseStorageRef1.putFile(_imageFile1);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      setState(() => _imageOneString = value);
    });
    StorageUploadTask uploadTask2 = firebaseStorageRef2.putFile(_imageFile2);
    StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
    taskSnapshot2.ref.getDownloadURL().then((value) {
      setState(() => _imageTwoString = value);
      _writeDataToDB(context);
    });
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(() {
        _currentLocation = new LatLng(lat, lng);
        _getCurrentAddress();
      });
    }
  }

  _locationSearch() async {
    setState(() => _currentLocation = null);

    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: GOOGLE_API_KEY,
      mode: Mode.fullscreen,
      language: "en",
    );
    displayPrediction(p);
  }

  _displayMapLocationPicker(){
    setState(() {
      _isMapSelected = true;
      _currentLocation = null;
    });
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

  _getCurrentLocation() async {
    _currentLocation = null;

    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _getCurrentAddress();
    });
  }

  _getCurrentAddress() async{
    if(_currentLocation != null){
      try{
        List<Placemark> p = await _geoLocator.placemarkFromCoordinates(
            _currentLocation.latitude, _currentLocation.longitude);
        Placemark place = p[0];
        setState(() => _mainAddress = "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, "
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
    setState(() => _currentLocation = LatLng(position.latitude, position.longitude));
  }

  _handleTap(LatLng point) {
    _markers.clear();
    setState(() {
      _currentLocation = point;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: "Main Office Address",),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta),
      ));
      _getCurrentAddress();
    });

  }

  _onCameraMove(CameraPosition position) {
    _currentLocation = position.target;
  }

  _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  _retrieveDataFromPreviousPage(){
    setState(() {
      _firstName = widget.firstName;
      _lastName = widget.lastName;
      _businessName = widget.businessName;
      _agentId = widget.agentId;
      _isIdVerified = widget.isIdVerified;

      if(_isIdVerified == "Verified"){
        _isBody1 = false;
        _isBody6 = true;
      }
    });
  }

}
