import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickseen_agent/home/home_agent.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:quickseen_agent/shared/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetails extends StatefulWidget {

  final String profileImageUrl, profileDesc;
  ProfileDetails(this.profileImageUrl, this.profileDesc);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}


class _ProfileDetailsState extends State<ProfileDetails> {

  File _imageFile;

  String _profileDesc, _profileImageLink;
  double _textSize = 16.0;

  bool _isLoading = false;


  @override
  void initState() {
    _retrieveProfileDetailsFromPreviousPage();
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
            title: Text('Profile Update', style: TextStyle(color: colorWhite),)
        ),
        body: _isLoading ? Spinner() : Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileImageChange(),
                        _profileDescChange(),
                      ]),
                ),
                _proceedButton(),
              ]),
        )
    );
  }

  Widget _profileDescChange(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile bio", style: TextStyle(fontSize: _textSize-1,
            fontWeight: FontWeight.bold, color: colorPrimaryBlue, fontStyle: FontStyle.normal
        ),),
        SizedBox(height: 6.0),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
              maxLines: 4,
              maxLength: 180,
              maxLengthEnforced: true,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration( hintText: _profileDesc),
              onChanged: (value){
                setState(() => _profileDesc = value);
              }),
        ),
      ],);
  }

  Widget _profileImageChange(){
    return  GestureDetector(
      child: Container(
          width: 150.0,
          height: 150.0,
          margin: EdgeInsets.only(bottom: 10.0),
          child: _imageFile==null ? Image.network(_profileImageLink)
              : Image.file(_imageFile, fit: BoxFit.contain)
      ),
      onTap: (){
        openCameraDialog(context);
      },
    );
  }

  Widget _proceedButton(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: colorRedShade,
          child: Text("Save Changes", style: TextStyle(fontSize: _textSize-1, color: Colors.white),),
          onPressed: () async {
            _uploadProfileDetailsToDB();
          }
      ),
    );
  }


  Future openCameraDialog(BuildContext context){
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
                            _getImageFromCamera();
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
                            _getImageFromGallery();
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

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.camera);
    setState(() => _imageFile = File(_image.path));
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() => _imageFile = File(_image.path));
  }


  _retrieveProfileDetailsFromPreviousPage() async {
    setState(() {
      _profileImageLink = widget.profileImageUrl;
      _profileDesc = widget.profileDesc;
    });
  }


  Future _uploadProfileDetailsToDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseReference profileDatabaseReference = FirebaseDatabase.instance.reference().child("profile_info");
    StorageReference _storageReference = FirebaseStorage.instance.ref().child(prefs.getString("currentUser"));

    setState(() => _isLoading = true);
    if (_imageFile != null){
      StorageUploadTask uploadTask = _storageReference.putFile(_imageFile);
      await uploadTask.onComplete;
      _storageReference.getDownloadURL().then((value) {
        setState(() => _profileImageLink = value);
      }).then((value) {
        profileDatabaseReference.child(prefs.getString("currentUser")).update({
          "desc": _profileDesc,
          "profileImageUrl": _profileImageLink,
        }).then((value) {
          setState(() => _isLoading = false);
          toastMessage("Success");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) => HomePageAgent(),
          ), (route) => false,
          );
        });
      });
    }
    else if (_imageFile == null){
      profileDatabaseReference.child(prefs.getString("currentUser")).update({
        "desc": _profileDesc,
        "profileImageUrl": _profileImageLink,
      }).then((value) {
        setState(() => _isLoading = false);
        toastMessage("Success");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) => HomePageAgent(),
        ), (route) => false,
        );
      });
    }
  }



}
