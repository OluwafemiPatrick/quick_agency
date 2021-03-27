import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMethods{

  final profileDatabaseReference = FirebaseDatabase.instance.reference().child("profile_info");
  final packageDetailsReference = FirebaseDatabase.instance.reference().child("package_details");

  SharedPreferences prefs;


  Future uploadProfileDetailsToDB(String firstName, String lastName, String email, String userId, String phoneNumber,
      String password, String userCategory, String rating, String desc, String address, String profileImageUrl,
      String businessOrAgencyName, isIdVerified, isPhoneVerified, idImageOne, idImageTwo, idImageThree, totalMoneyEarned,
      totalMoneyWithdraw, totalBalance, noOfRegisteredRiders, addressLatLng, contactAgentName, contactAgentPhone,
      ) async {

    prefs = await SharedPreferences.getInstance();

    profileDatabaseReference.child(prefs.getString("currentUser")).set({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "userId": userId,
      "phoneNumber": phoneNumber,
      "password": password,
      "userCategory": userCategory,
      "rating": rating,
      "desc": desc,
      "address": address,

      "profileImageUrl": profileImageUrl,
      "businessOrAgencyName": businessOrAgencyName,
      "isIdVerified": isIdVerified,
      "isPhoneVerified": isPhoneVerified,
      "idImageOne": idImageOne,
      "idImageTwo": idImageTwo,
      "idImageThree": idImageThree,

      "totalMoneyEarned": totalMoneyEarned,
      "totalMoneyWithdraw": totalMoneyWithdraw,
      "totalBalance": totalBalance,
      "noOfRegisteredRiders": noOfRegisteredRiders,
      "addressLatLng": addressLatLng,
      "contactAgentName": contactAgentName,
      "contactAgentPhone": contactAgentPhone,
    });
  }


  Future uploadAddressToDB(String address1, address2, address3, address4, address5, address6, address7, address8, address9, address10,
      contactName1, contactName2, contactName3, contactName4, contactName5, contactName6, contactName7, contactName8, contactName9,
      contactName10, contactNum1, contactNum2, contactNum3, contactNum4, contactNum5, contactNum6, contactNum7, contactNum8,
      contactNum9, contactNum10) async {
    DatabaseReference addressRef = FirebaseDatabase.instance.reference().child("address");

    prefs = await SharedPreferences.getInstance();

    addressRef.child(prefs.getString("currentUser")).set({
      "address1": address1,
      "address2": address2,
      "address3": address3,
      "address4": address4,
      "address5": address5,
      "address6": address6,
      "address7": address7,
      "address8": address8,
      "address9": address9,
      "address10": address10,

      "contactName1": contactName1,
      "contactName2": contactName2,
      "contactName3": contactName3,
      "contactName4": contactName4,
      "contactName5": contactName5,
      "contactName6": contactName6,
      "contactName7": contactName7,
      "contactName8": contactName8,
      "contactName9": contactName9,
      "contactName10": contactName10,

      "contactNum1": contactNum1,
      "contactNum2": contactNum2,
      "contactNum3": contactNum3,
      "contactNum4": contactNum4,
      "contactNum5": contactNum5,
      "contactNum6": contactNum6,
      "contactNum7": contactNum7,
      "contactNum8": contactNum8,
      "contactNum9": contactNum9,
      "contactNum10": contactNum10,

    });
  }


}