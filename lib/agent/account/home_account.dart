import 'package:flutter/material.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAccount extends StatefulWidget {

  final String profileImageLink, businessName, phoneNumber, emailAdd, walletBalance, bioDesc,
      address, totalMoneyEarned, totalWithdrawal, isIdVerified, noOfRegisteredRiders;
  final String profileImageUrl, address1, address2, address3, address4, address5, address6, address7, address8, address9, address10;

  HomeAccount(
      this.profileImageLink,
      this.businessName,
      this.phoneNumber,
      this.emailAdd,
      this.walletBalance,
      this.bioDesc,
      this.address,
      this.totalMoneyEarned,
      this.totalWithdrawal,
      this.isIdVerified,
      this.noOfRegisteredRiders,
      this.profileImageUrl,
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
    );

  @override
  _HomeAccountState createState() => _HomeAccountState();
}


class _HomeAccountState extends State<HomeAccount> {

  SharedPreferences prefs;

  String _profileImageLink, _businessName, _phoneNumber, _emailAdd, _walletBalance, _bioDesc, _address, _totalMoneyEarned,
      _totalWithdrawal, _isIdVerified, _address1, _address2, _address3, _address4, _address5, _address6, _address7, _address8,
      _address9, _address10, _noOfRegisteredRiders;

  double _textSize = 16.0;

  @override
  void initState() {
    _retrieveDataFromHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar(backgroundColor: colorPrimaryRed)),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: ListView(children: [
            _body(),
            SizedBox(height: 15.0),
            _accountDetails(),
            SizedBox(height: 15.0),
            _addresses(),
          ],),
        )
    );
  }

  Widget _body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.0),
        Container(
            width: 140.0,
            height: 140.0,
            child: Image.network(_profileImageLink, fit: BoxFit.fill)
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: colorPrimaryRed, size: 22.0),
            Text(_isIdVerified, style: TextStyle(fontSize: _textSize-1,
                fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            SizedBox(width: 8.0),
          ],),
        SizedBox(height: 6.0),
        Text(_businessName, style: TextStyle(fontSize: _textSize),),
        SizedBox(height: 6.0),
        Text(_emailAdd, style: TextStyle(fontSize: _textSize),),
        SizedBox(height: 6.0),
        Text(_phoneNumber, style: TextStyle(fontSize: _textSize),),
        SizedBox(height: 6.0),
        Text(_bioDesc, style: TextStyle(fontSize: _textSize)),
      ],) ;
  }

  Widget _accountDetails(){
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Account Details", style: TextStyle(fontSize: _textSize, color: colorPrimaryRed,
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No of registered riders", style: TextStyle(fontSize: _textSize),),
              SizedBox(width: 10.0),
              Text(_noOfRegisteredRiders, style: TextStyle(fontSize: _textSize,
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            ]),
          SizedBox(height: 8.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total commission earned", style: TextStyle(fontSize: _textSize),),
                SizedBox(width: 10.0),
                Text(naira, style: TextStyle(fontSize: _textSize,
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                SizedBox(width: 4.0),
                Text(_totalMoneyEarned, style: TextStyle(fontSize: _textSize,
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              ]),
          SizedBox(height: 8.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Total money withdrawn", style: TextStyle(fontSize: _textSize),),
              SizedBox(width: 10.0),
              Text(naira, style: TextStyle(fontSize: _textSize,
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              SizedBox(width: 4.0),
              Text(_totalWithdrawal, style: TextStyle(fontSize: _textSize,
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            ]),
          SizedBox(height: 8.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Wallet balance", style: TextStyle(fontSize: _textSize),),
              SizedBox(width: 10.0),
              Text(naira, style: TextStyle(fontSize: _textSize,
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              SizedBox(width: 4.0),
              Text(_walletBalance, style: TextStyle(fontSize: _textSize,
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          ]),
        ],
      ),
    );
  }

  Widget _addresses(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Address(es)", style: TextStyle(fontSize: _textSize, color: colorPrimaryRed,
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          SizedBox(height: 6.0),
          Text(_address, style: TextStyle(fontSize: _textSize),),
          SizedBox(height: 6.0),
          // Text(_address1, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address2, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address3, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address4, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address5, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address6, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address7, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address8, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address9, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 6.0),
          // Text(_address10, style: TextStyle(fontSize: _textSize),),
          // SizedBox(height: 10.0),
        ],
      ),
    );
  }

  _retrieveDataFromHomePage(){
    setState(() {
      _profileImageLink = widget.profileImageLink;
      _businessName = widget.businessName;
      _phoneNumber = widget.phoneNumber;
      _emailAdd = widget.emailAdd;
      _walletBalance = widget.walletBalance;
      _bioDesc = widget.bioDesc;
      _address = widget.address;
      _totalMoneyEarned = widget.totalMoneyEarned;
      _totalWithdrawal = widget.totalWithdrawal;
      _isIdVerified = widget.isIdVerified;
      _noOfRegisteredRiders = widget.noOfRegisteredRiders;
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
    });
  }


}
