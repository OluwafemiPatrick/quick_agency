import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

toastMessage(String toastmessage){

  Fluttertoast.showToast(
      msg: toastmessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: colorWhite,
      textColor: colorPrimaryBlue,
      fontSize: 16.0
  );
}


toastMessageLong(String toastmessage){

  Fluttertoast.showToast(
      msg: toastmessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: colorWhite,
      textColor: colorPrimaryBlue,
      fontSize: 16.0
  );
}