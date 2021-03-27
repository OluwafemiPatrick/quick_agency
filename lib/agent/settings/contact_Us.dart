import 'package:flutter/material.dart';
import 'package:quickseen_agent/shared/colors.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            backgroundColor: colorPrimaryRed,
            iconTheme: IconThemeData(color: colorWhite, size: 10),
            centerTitle: true,
            title: Text('Contact Us', style: TextStyle(color: colorWhite),)
        ),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: null,
        )
    );
  }
}
