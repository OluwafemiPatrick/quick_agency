import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide Context;
import 'package:quickseen_agent/agent/home/home_data_model.dart';
import 'package:quickseen_agent/agent/home/rider_successfully_verified.dart';
import 'package:quickseen_agent/home/home_agent.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:quickseen_agent/shared/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterNewRider extends StatefulWidget {

  final String riderId;
  RegisterNewRider(this.riderId);

  @override
  _RegisterNewRiderState createState() => _RegisterNewRiderState();
}

class _RegisterNewRiderState extends State<RegisterNewRider> {


  String _profileImageUrl, _firstName, _lastName, _noOfDeliveries, _rating, _profileDesc, _riderId;
  String _uploadInfo = "Kindly verify each of the following identities provided by the dispatch rider. \nEnsure that the names on the documents"
      " match the names displayed on the app";
  String _drivingLicense = "Driving license.";
  String _proofOfVehicleReg = "Proof of vehicle registration";
  String _governmentIssuedId = "Any government issued identity card (national Id card, voters card, or international passport).";
  String _proceedToUpload = "After manual verification, kindly upload a copy of each document for review.";
  String _discountInfo = "The agency is expected to negotiate a percentage fee to charge from all orders of the rider. "
      "QuickSeen expects this to be less than 20%.";
  String _provideGuarantorDetails = "The rider is also expected to present details of his guarantor. Required guarantor's details are "
      "\n   * full name \n   * phone \n   * valid means of identification";


  bool _isQueryComplete = false;
  bool _isLoading = false;
  bool _isBodyOne = true;
  bool _isBodyTwo = false;
  bool _isBodyThree = false;
  bool _isBodyFour = false;

  File _imageFile1, _imageFile2, _imageFile3, _imageFile4;
  SharedPreferences prefs;
  String _vehicle = "", _percentage, _riderMail, _riderName, _isIdVerified, _fullNameG, _phoneG;
  String _imageOneString, _imageTwoString, _imageThreeString, _imageFourString, _agencyName, _noOfRegisteredRiders;

  final double _textSize = 14.0;

  @override
  void initState() {
    setState(() => _riderId = widget.riderId);
    _fetchDataFromDB();
    super.initState();
  }

  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 12.0,
      width:  12.0,
      decoration: BoxDecoration(
          color: isActive ? colorPrimaryBlue : colorBoxBackground,
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: colorPrimaryRed,
          iconTheme: IconThemeData(color: colorWhite, size: 10),
          centerTitle: true,
          title: Text('Register New Rider', style: TextStyle(color: colorWhite),)
      ),
      body: _isQueryComplete ? Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10.0, 10, 5.0, 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topSection(_profileImageUrl, _firstName, _lastName, _rating, _noOfDeliveries, _profileDesc),
                Divider(thickness: 1.5, height: 30.0,),
                Expanded(child: Stack(
                  children: [
                    _body1(context),
                    _body2(context),
                    _body3(context),
                    _body4(context),
                  ],
                )),
              ])
      ) : Spinner(),
    );
  }

  Widget _body1(BuildContext context){
    return Visibility(
      visible: _isBodyOne,
      child: Column(
        children: [
          Expanded(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(_uploadInfo, style: TextStyle(fontSize: 15.0, color: colorBlack,)),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Row(
                        children: [
                          SizedBox(width: 20.0),
                          Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                          SizedBox(width: 6.0),
                          Expanded(child: Text(_governmentIssuedId, style: TextStyle(fontSize: _textSize),)),
                        ]),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                        SizedBox(width: 6.0),
                        Text(_drivingLicense, style: TextStyle(fontSize: _textSize),),
                      ]),
                  SizedBox(height: 5.0),
                  Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.arrow_forward, size: 20.0, color: colorPrimaryBlue),
                        SizedBox(width: 6.0),
                        Text(_proofOfVehicleReg, style: TextStyle(fontSize: _textSize),),
                      ]),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(_proceedToUpload, style: TextStyle(fontSize: 15.0, color: colorBlack,)),
                  ),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(_provideGuarantorDetails, style: TextStyle(fontSize: 15.0, color: colorBlack,)),
                  ),
                ]),
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Proceed to Document Upload", style: TextStyle(fontSize: 15.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () async {
                  setState(() {
                    _isBodyOne = false;
                    _isBodyTwo = true;
                    _isBodyThree = false;
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
      visible: _isBodyTwo,
      child: Column(
        children: [
          Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 2.0, bottom: 5.0, left: 10.0, right: 10.0),
                child: PageView(
                    allowImplicitScrolling: true,
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() => _currentPage = page);
                    },
                    children: [
                      GestureDetector(
                        child: Column(
                          children: [
                            Expanded(
                              child: _imageFile1==null ? Image.asset("assets/images/gallery_icon.png")
                                  : Image.file(_imageFile1, fit: BoxFit.fill,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Driving license", style: TextStyle(fontSize: 15.0, color: colorBlack),),
                            )
                          ],
                        ),
                        onTap: () => openCameraDialog1(context),
                      ),
                      GestureDetector(
                        child: Column(
                          children: [
                            Expanded(
                              child: _imageFile2==null ? Image.asset("assets/images/gallery_icon.png")
                                  : Image.file(_imageFile2, fit: BoxFit.fill),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Proof of vehicle ownership", style: TextStyle(fontSize: 15.0, color: colorBlack),),
                            )
                          ],
                        ),
                        onTap: () => openCameraDialog2(context),
                      ),
                      GestureDetector(
                        child: Column(
                          children: [
                            Expanded(
                              child: _imageFile3==null ? Image.asset("assets/images/gallery_icon.png")
                                  : Image.file(_imageFile3, fit: BoxFit.fill),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("National ID", style: TextStyle(fontSize: 15.0, color: colorBlack),),
                            )
                          ],
                        ),
                        onTap: () => openCameraDialog3(context),
                      ),
                    ]),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
          SizedBox(height: 20.0,),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Finish Upload", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () {
                  if(_imageFile1!=null && _imageFile2!=null && _imageFile3!=null){
                    setState(() {
                      _isBodyOne = false;
                      _isBodyTwo = false;
                      _isBodyThree = false;
                      _isBodyFour = true;
                    });
                  } else{
                    toastMessage("All document images is required");
                  }
                }
            ),
          ),
        ],
      )
    );
  }

  Widget _body4(BuildContext context){
    String guarantorInfo = "Kindly fill in guarantor's contact details. All fields are required.";

    return Visibility(
      visible: _isBodyFour,
      child: Column(
          children: [
            Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0, bottom: 15.0, right: 6.0),
                      child: Text(guarantorInfo, style: TextStyle(fontSize: 16.0, color: colorBlack,),
                        textAlign: TextAlign.center,),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      height: 44.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 85.0,
                            child: Text("Guarantor \nfull name",style: TextStyle(
                                fontSize: _textSize+1, color: colorBlack
                            ),),
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: Container(
                              height: 43.0,
                              padding: EdgeInsets.only(left: 14.0, right: 10.0, top: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: colorRedShade),
                                borderRadius: BorderRadius.circular(10.0),),
                              child: TextField(
                                style: TextStyle(fontSize: _textSize),
                                maxLength: 80,
                                keyboardType: TextInputType.name,
                                decoration: null,
                                autofocus: false,
                                onChanged: (value){
                                  setState(() => _fullNameG = value);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      height: 44.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 85.0,
                            child: Text("Phone number",style: TextStyle(
                                fontSize: _textSize+1, color: colorBlack
                            ),),
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: Container(
                              height: 43.0,
                              padding: EdgeInsets.only(left: 14.0, right: 10.0, top: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: colorRedShade),
                                borderRadius: BorderRadius.circular(10.0),),
                              child: TextField(
                                style: TextStyle(fontSize: _textSize),
                                maxLength: 11,
                                keyboardType: TextInputType.phone,
                                decoration: null,
                                autofocus: false,
                                onChanged: (value){
                                  setState(() => _phoneG = value);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: _imageFile4==null ? Column(
                          children: [
                            SizedBox(height: 15.0,),
                            Image.asset("assets/images/gallery_icon.png"),
                            SizedBox(height: 5.0,),
                            Text('Valid means of identification')
                          ])
                            : Image.file(_imageFile4, fit: BoxFit.fill,),
                        onTap: () => openCameraDialog4(context),
                      ),
                    ),
                    SizedBox(height: 5.0,)
                  ],
                )
            ),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                  child: Text("Proceed", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  color: colorRedShade,
                  onPressed: () {
                    if (_fullNameG!=null && _phoneG!=null && _imageFile4!=null){
                      setState(() {
                        _isBodyOne = false;
                        _isBodyTwo = false;
                        _isBodyThree = true;
                        _isBodyFour = false;
                      });
                    } else{
                      toastMessage("Kindly provide all details");
                    }
                  }
              ),
            ),
          ]),
    );
  }

  Widget _body3(BuildContext context){
    return Visibility(
      visible: _isBodyThree,
      child: _isLoading ? Spinner() : Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 20.0, top: 5.0),
                  child: Text(_discountInfo, style: TextStyle(fontSize: 16.0, color: colorBlack,)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 85.0,
                        child: Text("Percentage charge",style: TextStyle(
                            fontSize: _textSize+1, color: colorBlack
                        ),),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          height: 43.0,
                          padding: EdgeInsets.only(left: 14.0, right: 10.0, top: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: colorRedShade),
                            borderRadius: BorderRadius.circular(10.0),),
                          child: TextField(
                            style: TextStyle(fontSize: _textSize),
                            maxLength: 80,
                            keyboardType: TextInputType.number,
                            decoration: null,
                            autofocus: false,
                            onChanged: (value){
                              setState(() => _percentage = value);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 85.0,
                        child: Text("Rider \nvehicle type",style: TextStyle(
                            fontSize: _textSize+1, color: colorBlack
                        ),),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          height: 42.0,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: colorRedShade),
                            borderRadius: BorderRadius.circular(10.0),),
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: PopupMenuButton(
                            child: Row(
                              children: [
                                Expanded(child: Text(_vehicle, style: TextStyle(
                                    fontSize: _textSize, color: colorBlack, fontWeight: FontWeight.normal),)),
                                Icon(Icons.arrow_drop_down, size: 30.0, color: colorBlack,),
                                SizedBox(width: 12.0,),
                              ],),
                            onSelected: _handleVehicleType,
                            itemBuilder: (BuildContext context){
                              return vehicleType.map((VehicleChoice vChoice){
                                return PopupMenuItem(
                                  value: vChoice,
                                  child: Text(vChoice.vehicleType),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ),
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
                child: Text("Submit Rider ID", style: TextStyle(fontSize: 16.0, color: colorWhite),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                color: colorRedShade,
                onPressed: () {
                  double charge = double.parse(_percentage);

                  if (_isIdVerified == "true"){
                    toastMessageLong("Access denied! Rider has been verified");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => HomePageAgent(),
                    ), (route) => false,
                    );
                  }
                  else if (_isIdVerified == "false"){
                    if(_vehicle.isNotEmpty){
                      if (charge < 21.0){
                        setState(() => _isLoading = true);
                        _uploadImageToStorage(context);
                      } else{
                        toastMessage("Charge cannot exceed 20%");
                      }
                    } else{
                      toastMessage("Please select a vehicle type");
                    }
                  }


                }
            ),
          ),
        ]),
    );
  }


  Widget _topSection(String profileImageLink, String firstName, String lastName, rating, noOfDelivery, profileDesc){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 90.0,
            height: 90.0,
            margin: EdgeInsets.only(right: 10.0),
            child: Image.network(profileImageLink)
        ),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(firstName, style: TextStyle(
                      fontSize: _textSize,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),),
                  SizedBox(width: 5.0),
                  Text(lastName, style: TextStyle(
                      fontSize: _textSize,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),),
                ]),
                SizedBox(height: 6.0),
                Row(children: [
                  Text("Average rating ", style: TextStyle(fontSize: _textSize),),
                  Text(rating, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 6.0),
                Row(children: [
                  Text("No of deliveries ", style: TextStyle(fontSize: _textSize),),
                  Text(noOfDelivery, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 6.0),
                Text(profileDesc, style: TextStyle(fontSize: _textSize),),
              ])
        )
      ],);
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

  Future openCameraDialog3(BuildContext context){
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
                            _getImageFromCamera3();
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
                            _getImageFromGallery3();
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

  Future openCameraDialog4(BuildContext context){
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
                            _getImageFromCamera4();
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
                            _getImageFromGallery4();
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

  Future<void> _getImageFromCamera3() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.camera);
    setState(() => _imageFile3 = File(_image.path));
  }

  Future<void> _getImageFromGallery3() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() => _imageFile3 = File(_image.path));
  }

  Future<void> _getImageFromCamera4() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.camera);
    setState(() => _imageFile4 = File(_image.path));
  }

  Future<void> _getImageFromGallery4() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() => _imageFile4 = File(_image.path));
  }


  Future _fetchDataFromDB() async {

    FirebaseDatabase databaseReference = FirebaseDatabase.instance;
    prefs = await SharedPreferences.getInstance();

    databaseReference.reference().child("profile_info").child(_riderId).once().then((DataSnapshot dataSnapshot) {
      setState(() {
        _profileDesc = dataSnapshot.value["desc"];
        _profileImageUrl = dataSnapshot.value["profileImageUrl"];
        _firstName = dataSnapshot.value["firstName"];
        _lastName = dataSnapshot.value["lastName"];
        _noOfDeliveries = dataSnapshot.value["totalNoOfDeliveries"];
        _rating = dataSnapshot.value["rating"];
        _riderMail = dataSnapshot.value["email"];
        _isIdVerified = dataSnapshot.value["isIdVerified"];

        _riderName = _firstName +" "+_lastName;
        _isQueryComplete = true;

      });
    });

    databaseReference.reference().child("profile_info").child(prefs.getString("currentUser")).once().then((DataSnapshot dataSnapshot){
      setState(() {
        _agencyName = dataSnapshot.value["businessOrAgencyName"];
        _noOfRegisteredRiders = dataSnapshot.value["noOfRegisteredRiders"];
      });
    });

    DatabaseReference iDReference = FirebaseDatabase.instance.reference().child("id_verification");
    iDReference.child(prefs.getString("currentUser")).set({
      "riderId" : "",
    });
  }

  _handleVehicleType(VehicleChoice vehChoice){
    setState(() {
      _vehicle = vehChoice.vehicleType.toString();
    });
  }

  Future _writeDataToRiderDB(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    DatabaseReference profileDB = FirebaseDatabase.instance.reference();

    int prevNoOfRiders = int.parse(_noOfRegisteredRiders);
    var newNoOfRiders = (prevNoOfRiders + 1).toStringAsFixed(0);

    profileDB.child("my_riders").child(prefs.getString("currentUser")).child(_riderId).set({
      "riderId" : _riderId,
      "riderName" : _riderName,
      "riderMail" : _riderMail,
      "profileImage" : _profileImageUrl,
    });

    profileDB.child("profile_info").child(prefs.getString("currentUser")).update({
      "noOfRegisteredRiders" : newNoOfRiders,
    });

    profileDB.child("profile_info").child(_riderId).update({
      "idImageOne" : _imageOneString,
      "idImageTwo" : _imageTwoString,
      "idImageThree" : _imageThreeString,
      "isIdVerified" : "true",
      "businessOrAgencyName" : _agencyName,
      "vehicleType" : _vehicle,
      "agencyPercentage" : _percentage,
      "agencyId" : prefs.getString("currentUser"),
      "guarantorName" : _fullNameG,
      "guarantorPhone" : _phoneG,
      "guarantorID" : _imageFourString,
    }).then((value) {
      setState(() => _isLoading = false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) => RiderVerificationSuccessfull(),
      ), (route) => false,
      );
    });
  }


  Future _uploadImageToStorage(BuildContext context) async {
    String fileName1 = basename(_imageFile1.path);
    String fileName2 = basename(_imageFile2.path);
    String fileName3 = basename(_imageFile3.path);
    String fileName4 = basename(_imageFile4.path);

    StorageReference firebaseStorageRef1 = FirebaseStorage.instance.ref().child('identities/$fileName1');
    StorageReference firebaseStorageRef2 = FirebaseStorage.instance.ref().child('identities/$fileName2');
    StorageReference firebaseStorageRef3 = FirebaseStorage.instance.ref().child('identities/$fileName3');
    StorageReference firebaseStorageRef4 = FirebaseStorage.instance.ref().child('identities/$fileName4');

    StorageUploadTask uploadTask = firebaseStorageRef1.putFile(_imageFile1);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      setState(() => _imageOneString = value);
    });

    StorageUploadTask uploadTask2 = firebaseStorageRef2.putFile(_imageFile2);
    StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
    taskSnapshot2.ref.getDownloadURL().then((value) {
      setState(() => _imageTwoString = value);
    });

    StorageUploadTask uploadTask4 = firebaseStorageRef4.putFile(_imageFile4);
    StorageTaskSnapshot taskSnapshot4 = await uploadTask4.onComplete;
    taskSnapshot4.ref.getDownloadURL().then((value) {
      setState(() => _imageFourString = value);
    });

    StorageUploadTask uploadTask3 = firebaseStorageRef3.putFile(_imageFile3);
    StorageTaskSnapshot taskSnapshot3 = await uploadTask3.onComplete;
    taskSnapshot3.ref.getDownloadURL().then((value) {
      setState(() => _imageThreeString = value);
      _writeDataToRiderDB(context);
    });
  }


}
