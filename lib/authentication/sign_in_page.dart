import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickseen_agent/home/wrapper.dart';
import 'package:quickseen_agent/service/auth.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:quickseen_agent/shared/toast_message.dart';


class SignInPage extends StatefulWidget {

  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = new GlobalKey<FormState>();
  final QuickAuthService _auth = QuickAuthService();

  String _password = "";
  String _email = "";
  String _errorMessage = "";

  bool _isLoading = false;
  bool _obscureText = true;

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
      body: _isLoading ? Spinner() : Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.49,
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
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                      Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: Text("Sign in to QuickSeen", style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold, color: colorPrimaryBlue),),
                      ),
                      Expanded(
                        child: Container(
                          child: ListView(
                              children: [
                                showEmailInput(),
                                showPasswordInput(),
                                SizedBox(height: 5.0,),
                                Text(_errorMessage, style: TextStyle(color: colorPrimaryBlue, fontSize: 14.0),
                                  textAlign: TextAlign.center,),
                                SizedBox(height: 10.0,),
                                signInButton(),
                                SizedBox(height: 5.0,),
                                Text("Don't have an account?", style: TextStyle(fontSize: 14.0, color: colorBlack),
                                  textAlign: TextAlign.center,),
                                signUpButton(),
                              ] ),
                        ),
                      ),
                    ] ),
                ),
              ),
            )
          ]),
      ),
    );
  }

  Widget showEmailInput() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Email",
            icon: Icon(
              Icons.mail,
              color: colorPrimaryRed,
            )),
        validator: (value) => value.isEmpty ? "Email cannot be empty" : null,
        onSaved: (value) => _email = value.trim(),
        onChanged: (value) {
          setState(() => _email = value);
        },
      ),
    );
  }

  Widget showPasswordInput() {
    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      child: Stack(
        children: [
          TextFormField(
            maxLines: 1,
            obscureText: _obscureText,
            autofocus: false,
            decoration: InputDecoration(
                hintText: "Password",
                icon: Icon(
                  Icons.lock,
                  color: colorPrimaryRed,
                )),
            validator: (value) =>
            value.length < 6 ? "Password cannot be less than 6 chars" : null,
            onSaved: (value) => _password = value.trim(),
            onChanged: (value) {
              setState(() => _password = value);
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(top: 15.0, right: 10.0),
              height: 20.0,
              width: 30.0,
              child: FlatButton(
                child: Icon(_obscureText==true ? Icons.visibility : Icons.visibility_off, color: colorPrimaryGrey),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signInButton(){
    return FlatButton(
      height: 50.0,
      minWidth: MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: colorRedShade,
      child: Text("Log In", style: TextStyle(
          fontSize: 18.0, color: colorWhite),),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          setState(() =>_isLoading = true);

          dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
          if (result == null){
            setState(() {
              _isLoading = false;
              _errorMessage = "Sign in failed, please try again";
            });
          }else if (result != null){
            Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(
              builder: (BuildContext context) => Wrapper(),
            ), (route) => false,
            );
            toastMessage("Welcome back");
          }

        } else {
          setState(() => _errorMessage = "All fields are required");
        }

      },
    );
  }

  Widget signUpButton(){
    return Container(
      height: 30.0,
      child: FlatButton(
        color: Colors.transparent,
        child: Text("Sign up here", style: TextStyle(
          fontSize: 17.0, color: colorPrimaryBlue,)),
        onPressed: () => widget.toggleView()
      ),
    );
  }

}
