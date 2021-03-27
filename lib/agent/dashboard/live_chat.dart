import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickseen_agent/agent/dashboard/data_model.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LiveChat extends StatefulWidget {

  final String chatId, senderName, profileUrl;
  LiveChat(this.chatId, this.senderName, this.profileUrl);

  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  SharedPreferences prefs;
  String _chatId, _message, _time, _date, _profileUrl, _senderName, _userId;

  bool _isLoading = false;

  @override
  void initState() {
    _retrieveDataFromPreviousPage();
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
            title: Text("QuickChat", style: TextStyle(color: colorWhite),)
        ),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Image.asset("assets/images/chat_background.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,),
              Column(
                children: [
                  Expanded(child: _buildBody(context)),
                  _bottomSection(),
                ]),
            ]),
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(_chatId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container(color: colorBackground);
          return _buildList(context, snapshot.data.docs);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot documentSnapshot) {
    final record = LiveChatData.fromSnapshot(documentSnapshot);
    int data;

    if (_userId == record.senderId){
      data = 1;
    } else{
      data = 0;
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
          mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Bubble(
                radius: Radius.circular(15.0),
                color: data == 0 ? colorWhite : Colors.grey[400],
                elevation: 0.0,
                child: Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 4.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.message, style: TextStyle(fontSize: 16.0, color: colorBlack),),
                        SizedBox(height: 8.0,),
                        Text(data==0 ? record.senderName : "me",
                          style: TextStyle(fontSize: 12.0, color: colorBlack),
                        ),
                        SizedBox(width: 5.0,),
                        Row(
                          children: [
                            Text(record.date, style: TextStyle(fontSize: 12.0, color: colorBlack),),
                            SizedBox(width: 6.0,),
                            Text(record.time, style: TextStyle(fontSize: 12.0, color: colorBlack),),
                          ],
                        ),
                      ],
                    )
                )
            ),

          ]),
    );

  }


  Widget _bottomSection(){
    return _isLoading ? Spinner() : Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              decoration: new BoxDecoration(color: colorWhite,
                  borderRadius: new BorderRadius.all(Radius.circular(16.0))),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                autofocus: false,
                autocorrect: true,
                decoration: InputDecoration(hintText: "Type a message"),
                style: TextStyle(fontSize: 16.0, color: colorPrimaryBlue),
                onChanged: (value) => setState(() => _message = value),
              ),
            ),
          ),
          SizedBox(width: 6.0),
          Container(
            width: 46.0,
            decoration: new BoxDecoration(color: colorPrimaryGreen,
                borderRadius: new BorderRadius.all(Radius.circular(25.0))),
            child: FlatButton(
              child: Icon(Icons.send, color: colorWhite, size: 22.0,),
              onPressed: () {
                if(_message!=null || _message.isNotEmpty){
                  _generateDateAndTime();
                }
              },
            ),
          )
        ],),
    );
  }


  Future _sendMessageToDb (String senderName, date, time, profileImageUrl, message, senderId) async {
    final savedRouteRef = FirebaseFirestore.instance.collection(_chatId);
    setState(() => _isLoading = true);

    return await savedRouteRef.doc(currentTimeInSeconds()).set({
      'message': message,
      'time': time,
      'date': date,
      'profileImageUrl': profileImageUrl,
      'senderName': senderName,
      'senderId': senderId,
    }).then((value) {
      setState(() {
        _isLoading = false;
        _message = "";
      });
    });
  }


  _generateDateAndTime() async {
    DateTime now = DateTime.now();
    setState(() {
      _date = DateFormat('EEE d MMM').format(now);
      _time = DateFormat('kk:mm').format(now);
    });
    _sendMessageToDb(_senderName, _date, _time, _profileUrl, _message, _userId);

  }

  static String currentTimeInSeconds() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    return (ms / 1000).round().toString();
  }

  _retrieveDataFromPreviousPage() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _chatId = widget.chatId;
      _senderName = widget.senderName;
      _profileUrl = widget.profileUrl;
      _userId = prefs.getString("currentUser");
    });
  }

}
