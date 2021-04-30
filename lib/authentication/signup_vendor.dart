import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:quickseen_agent/home/wrapper.dart';
import 'package:quickseen_agent/service/auth.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:quickseen_agent/shared/toast_message.dart';


class SignUpVendor extends StatefulWidget {

  final Function toggleView;
  SignUpVendor({this.toggleView});

  @override
  _SignUpVendorState createState() => _SignUpVendorState();
}

class _SignUpVendorState extends State<SignUpVendor> {

  final _formKey = new GlobalKey<FormState>();
  final QuickAuthService _auth = QuickAuthService();

  bool _isChecked = false;
  bool _isLoading = false;
  bool _obscureText = true;

  String _firstName = "";
  String _lastName = "";
  String _businessName = "";
  String _email = "";
  String _phoneNumber = "";
  String _password = "";
  String _confirmPassword = "";
  String _errorMessage = "";
  String _bySigningUp = "By signing up, I agree to the terms of service and privacy policy of Quickseen.";
  String _profileDesc = "A new logistic agency on QuickSeen.";


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
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Image.asset("assets/icon/app_logo.png", height: 70.0, width: 70.0),
            SizedBox(height: 15.0,),
            Text("Sign up to QuickSeen", style: TextStyle(color: colorPrimaryBlue,
                fontSize: 17.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold)),
            SizedBox(height: 35.0,),
            Expanded(child: Form(
              key: _formKey,
              child: ListView(
                  children: [
                    firstNameInput(),
                    lastNameInput(),
                    businessNameInput(),
                    showEmailInput(),
                    countryCodeSelector(),
                    showPasswordInput(),
                    showConfirmPasswordInput(),
                    showCheckBox(),
                    SizedBox(height: 30.0,),
                    signUpButton(),
                    SizedBox(height: 15.0,),
                    Text("Already have an account?", style: TextStyle(fontSize: 15.0, color: colorBlack),
                      textAlign: TextAlign.center,),
                    logInButton(),

                    Text(_errorMessage, style: TextStyle(color: colorPrimaryBlue, fontSize: 14.0),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 5.0,),
                  ] ),
              ),
            ),
          ] ),
      ),
    );
  }

  Widget firstNameInput() {
    return new TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: new InputDecoration(
          hintText: "First name",
          icon: Icon(
            Icons.person,
            color: colorPrimaryRed,
          )),
      validator: (value) => value.isEmpty ? "First name cannot be empty" : null,
      onSaved: (value) => _firstName = value.trim(),
      onChanged: (value) {
        setState(() => _firstName = value);
      },
    );
  }

  Widget lastNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Last name",
            icon: Icon(
              Icons.person,
              color: colorPrimaryRed,
            )),
        validator: (value) =>
        value.isEmpty ? "Last name cannot be empty" : null,
        onSaved: (value) => _lastName = value.trim(),
        onChanged: (value) {
          setState(() => _lastName = value);
        },
      ),
    );
  }

  Widget businessNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Logistic agency name",
            icon: Icon(
              Icons.add_business,
              color: colorPrimaryRed,
            )),
        validator: (value) =>
        value.isEmpty ? "Logistic agency name cannot be empty" : null,
        onSaved: (value) => _businessName = value.trim(),
        onChanged: (value) {
          setState(() => _businessName = value);
        },
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
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

  Widget countryCodeSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.phone,
                color: colorPrimaryRed,
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: InternationalPhoneInput(
                  decoration:
                  InputDecoration.collapsed(hintText: '080 12345678'),
                  onPhoneNumberChange: onPhoneNumberChange,
                  initialPhoneNumber: _phoneNumber,
                  enabledCountries: ['+234'],
                  showCountryCodes: true,
                  showCountryFlags: false,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 40.0),
            color: Colors.black,
            width: double.infinity,
            height: 0.75,
          )
        ],
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Stack(
        children: [
          TextFormField(
            maxLines: 1,
            obscureText: _obscureText,
            autofocus: false,
            decoration: InputDecoration(
                hintText: "Password",
                icon: Icon(Icons.lock,
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

  Widget showConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Stack(
        children: [
          TextFormField(
            maxLines: 1,
            obscureText: _obscureText,
            autofocus: false,
            decoration: InputDecoration(
                hintText: "Confirm Password",
                icon: Icon(
                  Icons.lock,
                  color: colorPrimaryRed,
                )),
            validator: (value) =>
            _password != _confirmPassword ? "Passwords do not match" : null,
            onSaved: (value) => _confirmPassword = value.trim(),
            onChanged: (value) {
              setState(() => _confirmPassword = value);
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

  Widget showCheckBox() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, left: 5.0),
      child: Row(
        children: [
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: Checkbox(
                value: this._isChecked,
                checkColor: colorWhite,
                activeColor: colorPrimaryRed,
                onChanged: (bool value) {
                  setState(() {
                    this._isChecked = value;
                  });
                }),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              _bySigningUp,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpButton(){
    return FlatButton(
      height: 50.0,
      minWidth: MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: colorRedShade,
      child: Text("Sign Up", style: TextStyle(
          fontSize: 18.0, color: colorWhite),),
      onPressed: () async {

        if (_formKey.currentState.validate()) {
          if (_isChecked == true && _phoneNumber != null) {
            setState(() => _isLoading = true);
            dynamic result = await _auth.signUpWithEmailAndPassword(_email, _password, _firstName, _lastName, _phoneNumber, _businessName, "agency", _profileDesc);
            if (result == null){
              setState(() {
                _isLoading = false;
                _errorMessage = "Sign in failed, please try again";
              });
            } else if (result != null){
              Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (BuildContext context) => Wrapper(),
              ), (route) => false,
              );
              toastMessage("Welcome $_businessName");
            }
          }
          else {
            setState(() => _errorMessage = "All fields are required");
          }
        }
      },
    );
  }

  Widget logInButton(){
    return Container(
      height: 30.0,
      child: FlatButton(
        color: Colors.transparent,
        child: Text("Log in here", style: TextStyle(
          fontSize: 17.0, color: colorPrimaryBlue,)),
          onPressed: () => widget.toggleView()
      ),
    );
  }

/**
  Future firebaseVerification() {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final _codeController = TextEditingController();

    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          Navigator.of(context).pop();
          toastMessage("Phone number verified");
          await _auth.signUpWithEmailAndPassword(
              _email, _password, _firstName, _lastName, _phoneNumber, _businessName, "vendor", _profileDesc);
        },

        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
            _errorMessage = "We could not verify your phone, please try again";
          });
        },

        codeSent: (String verificationId, int resendToken) {
          setState(() => _isLoading = false);
          return showDialog(
              context: context,
              builder: (BuildContext context){
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 240.0,
                    child: Column(
                        children: <Widget>[
                          Text("We sent a code to " + _phoneNumber, style: TextStyle(fontSize: 15.0, color: Colors.black),),
                          SizedBox(height: 5.0),
                          Text("Please enter it below.",style: TextStyle(fontSize: 14.0, color: Colors.black),),
                          Container(
                            width: 120.0,
                            padding: const EdgeInsets.only(top: 15.0, bottom:5.0),
                            child: new TextField(
                              autofocus: false,
                              controller: _codeController,
                            ),
                          ),
                          Container(
                            height: 32.0,
                            width: 220.0,
                            margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 15.0),
                            child: FlatButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                color: colorRedShade,
                                child: Text("Verify", style: TextStyle(fontSize: 14.0, color: Colors.white),),
                                onPressed: () async {
                                  final code = _codeController.text.trim();
                                  Navigator.of(context).pop();
                                  AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                                  await _auth.signUpWithEmailAndPassword(
                                      _email, _password, _firstName, _lastName, _phoneNumber, _businessName, "vendor", _profileDesc);
                                }
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 32.0,
                                  child: FlatButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      color: colorPrimaryBlue,
                                      child: Text("Change number",
                                        style: TextStyle(fontSize: 12.0, color: Colors.white),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: FlatButton(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      color: colorPrimaryGreen,
                                      child: Text("Resend code",
                                        style: TextStyle(fontSize: 12.0, color: Colors.white),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        firebaseVerification();
                                      }
                                  ),
                                ),
                              ]),
                        ]),
                  ),
                );
              }
          );
        },

        codeAutoRetrievalTimeout:(String verificationId){ },
    );

  }
*/

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() => _phoneNumber = internationalizedPhoneNumber);
  }


}
