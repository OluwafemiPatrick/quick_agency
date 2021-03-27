import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/dashboard/data_model.dart';
import 'package:quickseen_agent/agent/dashboard/live_chat.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDashboard extends StatefulWidget {

  final String businessOrAgencyName, profileImageUrl;

  HomeDashboard(this.businessOrAgencyName, this.profileImageUrl);

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {

  SharedPreferences prefs;
  List<MessageData> messageList = [];

  String _logisticAgencyName, _logisticAgencyProfileUrl;

  bool _isQueryComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    _fetchDataFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: AppBar(backgroundColor: colorPrimaryRed)),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorBackground,
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: messageList.length>0 ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            itemCount: messageList.length,
            itemBuilder: (_, index){
              return _newMessages(
                messageList[index].senderName,
                messageList[index].senderProfileUrl,
                messageList[index].riderName,
                messageList[index].chatId,
              );
            }
      ) : Center(child: Text("You do not have any message"))
      )
    );
  }

  Widget _newMessages(String vendorBusinessName, vendorProfileUrl, riderName, chatId){
    return Stack(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 44.0,
                  width: 44.0,
                  margin: EdgeInsets.only(right: 10.0),
                  child: Image.asset("assets/images/profile_image.png")),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Message from: " + vendorBusinessName, style: TextStyle(
                          fontSize: 16.0, color: colorBlack),
                      ),
                      SizedBox(height: 4.0),
                      Text("regarding: " + riderName, style: TextStyle(
                          fontSize: 13.0, color: colorBlack),
                      ),
                      Divider(thickness: 1.5, height: 30.0,)
                    ]),
              ),
            ]),
        FlatButton(
          minWidth: MediaQuery.of(context).size.width,
          child: null,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveChat(chatId, _logisticAgencyName, _logisticAgencyProfileUrl)));
          },
        )
      ],
    );
  }


  Future _fetchDataFromDB() async {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    firebaseDatabase.setPersistenceEnabled(true);

    prefs = await SharedPreferences.getInstance();

    firebaseDatabase.reference().child("chats").child(prefs.getString("currentUser"))
        .once().then((DataSnapshot dataSnapshot) {
      messageList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys){
        MessageData data = new MessageData(
          values [key]["chatId"],
          values [key]["riderName"],
          values [key]["senderName"],
          values [key]["date"],
          values [key]["time"],
          values [key]["senderProfileImage"],
        );
        messageList.add(data);
      }
      setState(() {
        _logisticAgencyProfileUrl = widget.profileImageUrl;
        _logisticAgencyName = widget.businessOrAgencyName;
        _isQueryComplete = true;
      });
    });

  }



}
