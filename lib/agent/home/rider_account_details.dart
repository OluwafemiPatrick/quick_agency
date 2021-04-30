import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/home/home_data_model.dart';
import 'package:quickseen_agent/home/home_agent.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/strings.dart';
import 'package:quickseen_agent/shared/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RiderProfileDetails extends StatefulWidget {

  final String riderId, agencyId, agencyBusinessName, agencyProfileUrl;

  RiderProfileDetails(this.riderId, this.agencyId, this.agencyBusinessName,
      this.agencyProfileUrl);

  @override
  _RiderProfileDetailsState createState() => _RiderProfileDetailsState();

}

class _RiderProfileDetailsState extends State<RiderProfileDetails> {

  List<ReviewDataModelRider> reviewData = [];
  List<OrderData> orderList = [];

  SharedPreferences prefs;

  String _riderProfileUrl="", _firstName="", _lastName="", _noOfDeliveries="0", _totalMoneyEarned="0.00", _rating="3.5",
      _percentageCharge="", _riderId, _agencyId, _guarantorName, _guarantorPhone, _riderPhone;

  String _noOfRegisteredRiders;
  bool _isReviewVisible = true;
  final double _textSize = 15.0;


  @override
  void initState() {
    _retrieveDataFromPreviousPage();
    _fetchDataFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: colorPrimaryRed,
          iconTheme: IconThemeData(color: colorWhite, size: 10),
          centerTitle: true,
          title: Text('Rider Profile Details', style: TextStyle(color: colorWhite),)
      ),
      body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10.0, 10, 5.0, 5.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              _topSection(_riderProfileUrl, _firstName, _lastName, _rating, _noOfDeliveries, _percentageCharge,
                    _totalMoneyEarned, _riderId),
                Divider(thickness: 1.5, height: 15.0,),
                Container(
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        child: Text(" Reviews", style: _isReviewVisible
                            ? TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: colorPrimaryRed)
                            : TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: colorBlack)),
                        onPressed: (){
                          setState(() => _isReviewVisible = true);
                        },
                      ),
                      Container(width: 2.0, height: 40.0, color: colorPrimaryBlue,),
                      FlatButton(
                        child: Text(" Deliveries", style: !_isReviewVisible
                            ? TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: colorPrimaryRed)
                            : TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: colorBlack)),
                        onPressed: (){
                          setState(() => _isReviewVisible = false);
                        },
                      ),
                    ],),
                ),
                Divider(thickness: 1.5, height: 15.0,),
                Expanded(
                  child: _isReviewVisible ? _reviewScreen() : _orderScreen(),
                ),
                Divider(thickness: 1.5),
                Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                      minWidth: 110.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      color: colorPrimaryBlue,
                      child: Text("Revoke Verification", style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.normal),),
                      onPressed: () {
                        revokeRiderDialog(context);
                      }
                  ),
                )
              ])
      ),
    );
  }

  Widget _reviewScreen(){
    return Container(
        child: reviewData.length>0 ? ListView.builder(
          itemCount: reviewData.length,
          itemBuilder: (_, index) {
            return _bottomSection(
              reviewData[index].profileImageUrl,
              reviewData[index].vendorBusinessName,
              reviewData[index].reviewText,
              reviewData[index].rating,
            );
          },
        ) :  Center(child: Text("No review found"))
    );
  }

  Widget _orderScreen(){
    return Container(
      child: orderList.length>0 ? ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (_, index){
          return _itemDisplay(
            orderList[index].packageDeliveryStatus,
            orderList[index].package,
            orderList[index].riderName,
            orderList[index].price,
            orderList[index].pickUpAt,
            orderList[index].dropOffAdd,
            orderList[index].packageId,
          );
        }) : Center(child: Text("Rider does not have any order", style: TextStyle(fontSize: 18.0),))
    );
  }

  Widget _topSection(String profileImageLink, firstName, lastName, rating, noOfDelivery, percentageCharge,
      totalMoneyEarned, riderId){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 80.0,
            height: 100.0,
            margin: EdgeInsets.only(top: 2.0, right: 10.0),
            child: Image.network(profileImageLink)
        ),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(firstName, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic
                  ),),
                  SizedBox(width: 4.0),
                  Text(lastName, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic
                  ),),
                ]),
                SizedBox(height: 3.0),
                Row(children: [
                  Text("Average rating ", style: TextStyle(fontSize: _textSize),),
                  Text(rating, style: TextStyle(fontSize: _textSize, color: colorPrimaryRed,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 3.0),
                Row(children: [
                  Text("Phone ", style: TextStyle(fontSize: _textSize),),
                  Text(_riderPhone, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 3.0),
                Row(children: [
                  Text("No of deliveries ", style: TextStyle(fontSize: _textSize),),
                  Text(noOfDelivery, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 3.0),
                Row(children: [
                  Text("Percentage charge ", style: TextStyle(fontSize: _textSize),),
                  Text(percentageCharge +"%", style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 3.0),
                Row(children: [
                  Text("Total money earned ", style: TextStyle(fontSize: _textSize),),
                  Text(naira + " " +totalMoneyEarned, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 8.0),
                Row(children: [
                  Text("Guarantor ", style: TextStyle(fontSize: _textSize-1),),
                  Text(_guarantorName, style: TextStyle(fontSize: _textSize-1,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
                SizedBox(height: 3.0),
                Row(children: [
                  Text("Guarantor phone ", style: TextStyle(fontSize: _textSize),),
                  Text(_guarantorPhone, style: TextStyle(fontSize: _textSize,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                ]),
              ])
        )
      ],);
  }


  Widget _itemDisplay(String packageDeliveryStatus, String productName, String riderName,
      String amount, String pickUpLoc, String dropOffLoc, String packageId){
    return Column(
      children: [
        SizedBox(height: 2.0,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90.0,
              height: 100.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundColor: _packageDeliveryColor(packageDeliveryStatus),
                        child: null,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: Text(_packageDeliveryTest(packageDeliveryStatus), style: TextStyle(
                          fontSize: _textSize-1, color: colorBlack ),),
                    ),
                  ]),
            ),
            SizedBox(width: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName, style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue,
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  SizedBox(height: 4.0),
                  Text(riderName, style: TextStyle(fontSize: _textSize, color: colorPrimaryBlue)),
                  SizedBox(height: 4.0),
                  Container(child: Text(pickUpLoc, style: TextStyle(fontSize: _textSize, color: colorBlack))),
                  SizedBox(height: 4.0),
                  Container(child: Text(dropOffLoc, style: TextStyle(fontSize: _textSize, color: colorBlack))),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(naira, style: TextStyle(fontSize: _textSize, color: colorBlack)),
                      SizedBox(width: 4.0),
                      Text(amount, style: TextStyle(fontSize: _textSize, color: colorBlack)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(thickness: 1.5, height: 20.0,)
      ],);
  }


  Widget _bottomSection(String profileImageLink, String vendorName, String reviewText, String rating){
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: 80.0,
                height: 80.0,
                margin: EdgeInsets.only(top: 15.0, right: 10.0),
                padding: EdgeInsets.all(5.0),
                child: Image.asset(profileImageLink)
            ),
            Expanded(
              child: Column(
                  children: [
                    Row(children: [
                      Expanded(child: Text(vendorName, style: TextStyle(fontSize: _textSize,
                          fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                      ),),
                      Row(children: [
                        Icon(Icons.star, color: colorPrimaryRed, size: 22.0),
                        Text(rating, style: TextStyle(fontSize: _textSize,
                            fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                        SizedBox(width: 8.0),
                      ],),
                    ]),
                    SizedBox(height: 4.0),
                    Text(reviewText, style: TextStyle(fontSize: _textSize),),
                  ]),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Container(
          height: 0.7,
          color: colorPrimaryBlue,
        ),
        SizedBox(height: 14.0),
      ],
    );
  }


  Future _fetchDataFromDB() async {
    FirebaseDatabase databaseReference = FirebaseDatabase.instance;
    prefs = await SharedPreferences.getInstance();

    databaseReference.reference().child("profile_info").child(_riderId).once().then((DataSnapshot snapshot){
      setState(() {
        _percentageCharge = snapshot.value["agencyPercentage"];
        _riderProfileUrl = snapshot.value["profileImageUrl"];
        _firstName = snapshot.value["firstName"];
        _lastName = snapshot.value["lastName"];
        _noOfDeliveries = snapshot.value["totalNoOfDeliveries"];
        _totalMoneyEarned = snapshot.value["totalMoneyEarned"];
        _guarantorName = snapshot.value["guarantorName"];
        _guarantorPhone = snapshot.value["guarantorPhone"];
        _riderPhone = snapshot.value["phoneNumber"];
      });
    });

    databaseReference.reference().child("profile_info").child(_agencyId).once().then((DataSnapshot snapshot){
      setState(() {
        _noOfRegisteredRiders = snapshot.value["noOfRegisteredRiders"];
        print ("NUMBER OF REGISTERED RIDERS " + snapshot.value["noOfRegisteredRiders"]);
      });
    });

    databaseReference.reference().child("review").child(_riderId).once().then((DataSnapshot dataSnapShot) {
      reviewData.clear();
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        ReviewDataModelRider data = new ReviewDataModelRider(
          values [key]["profileImageUrl"],
          values [key]["vendorBusinessName"],
          values [key]["rating"],
          values [key]["ratingText"],
        );
        reviewData.add(data);
      }
    });

    databaseReference.reference().child("orders").child(_riderId).once().then((DataSnapshot dataSnapShot){
      orderList.clear();
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys){
        OrderData data = new OrderData(
          values [key]["package"],
          values [key]["riderName"],
          values [key]["pickUpAt"],
          values [key]["dropOffAt"],
          values [key]["pricing"],
          values [key]["packageDeliveryStatus"],
          values [key]["packageId"],
        );
        orderList.add(data);
      }
    });

  }

  _packageDeliveryColor(String orderStat){
    Color _color;
    if (orderStat == "pending_order"){
      _color = colorBrown;
    }
    if (orderStat == "active_order"){
      _color = colorPrimaryGreen;
    }
    if (orderStat == "awaiting_review"){
      _color = colorPrimaryYellow;
    }
    else if (orderStat == "completed_order"){
      _color = colorPrimaryBlue;
    }
    return _color;
  }

  _retrieveDataFromPreviousPage() async {
    setState(() {
      _riderId = widget.riderId;
      _agencyId = widget.agencyId;
    });
  }

  Future revokeRiderDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 10.0),
              height: 180.0,
              child: Column(
                  children: <Widget>[
                    Text("Revoke rider verification?", style: TextStyle(
                        fontSize: 18.0, color: colorPrimaryBlue, fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 15.0),
                    Expanded(
                      child: Text("You will no longer earn commissions on the deliveries of this rider,"
                          " and rider will not be able to deliver new packages.",style: TextStyle(
                        fontSize: 14.0, color: colorPrimaryBlue,
                      ),),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            minWidth: 120.0,
                              height: 30.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              color: colorPrimaryGreen,
                              child: Text("Dismiss", style: TextStyle(fontSize: 14.0, color: Colors.white),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }
                          ),
                          FlatButton(
                            minWidth: 120.0,
                              height: 30.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              color: colorRedShade,
                              child: Text("Proceed", style: TextStyle(fontSize: 14.0, color: Colors.white),),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _revokeVerificationButton();
                              }
                          ),
                        ])
                  ]),
            ),
          );
        }
    );
  }


  Future _revokeVerificationButton () async {

    DatabaseReference profileDB = FirebaseDatabase.instance.reference();
    int prevNoOfRiders = int.parse(_noOfRegisteredRiders);
    var newNoOfRiders = (prevNoOfRiders - 1).toStringAsFixed(0);

    profileDB.child("my_riders").child(prefs.getString("currentUser")).child(_riderId).remove();

    profileDB.child("profile_info").child(prefs.getString("currentUser")).update({
      "noOfRegisteredRiders" : newNoOfRiders,
    });

    print (newNoOfRiders.toString() + "NEW NO OF RIDERS");
    profileDB.child("profile_info").child(_riderId).update({
      "idImageOne" : "",
      "idImageTwo" : "",
      "idImageThree" : "",
      "isIdVerified" : "false",
      "businessOrAgencyName" : "",
      "vehicleType" : "",
      "agencyPercentage" : "",
      "agencyId" : "",
    }).then((value) {
      setState(() => _isReviewVisible = true);
      toastMessage("Success");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) => HomePageAgent(),
      ), (route) => false,
      );
    });
  }

  String _packageDeliveryTest(String orderStat){
    String text;
    if (orderStat == "pending_order"){
      text = "Pending order";
    }
    if (orderStat == "active_order"){
      text = "Active order";
    }
    if (orderStat == "awaiting_review"){
      text = "Awaiting review";
    }
    else if (orderStat == "completed_order"){
      text = "Completed";
    }
    return text;
  }



}
