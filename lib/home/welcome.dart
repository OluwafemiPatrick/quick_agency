import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickseen_agent/authentication/authentication_toggle.dart';
import 'package:quickseen_agent/shared/colors.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String _text = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/images/welcome_background.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.46,
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
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text(_text, style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),)
                      ),
                    )),
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
                    SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
