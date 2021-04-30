import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickseen_agent/authentication/authentication_toggle.dart';
import 'package:quickseen_agent/shared/colors.dart';


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {


  @override
  void initState() {
    _checkPermission();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  _checkPermission() async {
    var permissionStatus = await Permission.locationAlways.status;

    if (!permissionStatus.isGranted){
      requestPermissionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: AppBar(backgroundColor: colorPrimaryRed)
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.52,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/images/welcome_bg.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.47,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/full_logo.png"),
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),

                    Text('Affordable, reliable, fast, and safe.',
                      style: TextStyle(color: colorBlack),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthToggle("signUp")));
                      },
                      child: Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: colorRedShade),
                        child: Center(
                          child: Text("Create an account", style: TextStyle(
                              color: colorWhite, fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthToggle("signIn")));
                      },
                      child: Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: colorBoxBackground),
                        child: Center(
                          child: Text(
                            "Login to account",
                            style: TextStyle(
                                color: colorRedShade,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future requestPermissionDialog(BuildContext context) async {
    var locationPermission = Permission.locationAlways;
    String message = "Dear user, we need access to your location.";
    String message2 = "This app collects location data to enable key features work properly even when the app is closed or not in use."
        " Your data is well protected, and will not be shared with any third party platform or service.";

    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              padding: const EdgeInsets.only(left:5.0, right: 5.0, top: 10.0, bottom: 5.0),
              height: 190.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  children: <Widget>[
                    Text(message, style: TextStyle(
                        fontSize: 17.0, color: colorPrimaryBlue, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center),
                    SizedBox(height: 10.0),
                    Expanded(child: Text(message2, textAlign: TextAlign.center,)),
                    Container(
                      height: 32.0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                                height: 32.0,
                                minWidth: 120.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                color: colorPrimaryGreen,
                                child: Text("Decline", style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.normal),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                            ),
                            FlatButton(
                                height: 32.0,
                                minWidth: 120.0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                color: colorRedShade,
                                child: Text("Accept", style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.normal),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  locationPermission.request();
                                }
                            ),
                          ]),
                    )
                  ]),
            ),
          );
        }
    );
  }


}
