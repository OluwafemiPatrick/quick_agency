import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickseen_agent/service/firebase_methds.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickAuthService {

  SharedPreferences prefs;
  FirebaseMethods _fireMethods = new FirebaseMethods();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/quickseen-d0404.appspot.com/o/Webp.net-resizeimage%20(15).png?alt=media&token=76537909-1c89-4f72-9e11-ba3c9efeb0d3";

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("profile_info");
    prefs = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;

      profileRef.child(user.uid.toString()).once().then((DataSnapshot snapshot) {
        prefs.setString("phoneNumber", snapshot.value["phoneNumber"]);
        prefs.setString("isIdVerified", snapshot.value["isIdVerified"]);
        prefs.setString("isPhoneVerified", snapshot.value["isPhoneVerified"]);
      });
      prefs.setString("currentUser", user.uid.toString());
      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign up with email and password
  Future signUpWithEmailAndPassword(String email, password, firstName, lastName, phoneNumber, businessName, userType, profileDesc) async {
    prefs = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      _fireMethods.uploadProfileDetailsToDB(firstName, lastName, email, user.uid.toString(), phoneNumber,
          password, userType, "3.5", profileDesc, "", _profileImageUrl, businessName,
          "false", "true", "", "", "", "0.00", "0.00", "0.00", "0", "", "", "");

      _fireMethods.uploadAddressToDB("empty", "empty", "empty", "empty", "empty", "empty", "empty", "empty",
          "empty", "empty", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

      prefs.setString("currentUser", user.uid.toString());

      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    prefs = await SharedPreferences.getInstance();
    try {
      prefs.remove("currentUser");
      prefs.remove("isIdVerified");
      prefs.remove("isPhoneVerified");
      prefs.remove("phoneNumber");

      return await _auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

}
