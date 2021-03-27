import 'package:flutter/material.dart';
import 'package:quickseen_agent/authentication/sign_in_page.dart';
import 'package:quickseen_agent/authentication/signup_vendor.dart';

class AuthToggle extends StatefulWidget {

  final String auth;
  AuthToggle(this.auth);

  @override
  _AuthToggleState createState() => _AuthToggleState();
}

class _AuthToggleState extends State<AuthToggle> {

  bool showSignIn;
  String _auth;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _auth = widget.auth;
      if(_auth == "signIn"){
        showSignIn = true;
      } else if (_auth == "signUp"){
        showSignIn = false;
      }
    });
    super.initState();
  }

  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return SignInPage(toggleView: toggleView);
    } else{
      return SignUpVendor(toggleView: toggleView);
    }
  }
}
