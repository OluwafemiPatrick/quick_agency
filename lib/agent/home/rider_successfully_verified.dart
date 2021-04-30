import 'package:flutter/material.dart';
import 'package:quickseen_agent/home/home_agent.dart';
import 'package:quickseen_agent/shared/colors.dart';

class RiderVerificationSuccessfull extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar(backgroundColor: colorPrimaryRed,)),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          color: colorBackground,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Image.asset("assets/images/success.png"),
                    ),
                    Text("Success!",
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),

                    SizedBox(height: 25.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Rider verification was successful. Kindly ask rider to re-open the app on his device for changes to take effect",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: FlatButton(
                    height: 40.0,
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text("Return to homepage", style: TextStyle(fontSize: 18.0, color: colorWhite),),
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
            ],
          ),
        )
    );
  }

}
