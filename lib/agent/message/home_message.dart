import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickseen_agent/agent/message/data_model.dart';
import 'package:quickseen_agent/agent/message/live_chat.dart';
import 'package:quickseen_agent/shared/colors.dart';
import 'package:quickseen_agent/shared/spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeChat extends StatefulWidget {

  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {

  List<MessageData> messageList = [];
  SharedPreferences prefs;

  int _loadTime = 0;
  bool _isQueryComplete = false;


  @override
  void initState() {
    _fetchChatsFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(messageList.length<1 && _loadTime<2){
      _fetchChatsFromDB();
      _loadTime++;
    }
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: AppBar(backgroundColor: colorPrimaryRed,)),
        body: Container(
          color: colorBackground,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10.0, 4, 8.0, 5.0),
          child: _messages(),
        )
    );
  }


  Widget _messages(){
    return _isQueryComplete ? RefreshIndicator(
      onRefresh: () async {
        setState(() => _isQueryComplete = false);
        _fetchChatsFromDB();
      },
      child: messageList.length>0 ? ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          itemCount: messageList.length,
          itemBuilder: (_, index){
            return _messageList(
              messageList[index].senderName,
              messageList[index].senderProfileUrl,
              messageList[index].senderUId,
              messageList[index].receiverName,
              messageList[index].receiverProfileUrl,
              messageList[index].receiverUId,
              messageList[index].message,
              messageList[index].date,
              messageList[index].time,
              messageList[index].chatId,
            );
          }
      ) :  Center(child: Text("You do not have any message", style: TextStyle(fontSize: 18.0),)
      ),
    ) : Spinner();

  }

  Widget _messageList(String senderName, senderProfileUrl, senderUId, receiverName, receiverProfileUrl,
      receiverUId, message, date, time, chatId){
    return Stack(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 44.0,
                  width: 44.0,
                  margin: EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.all(Radius.circular(24.0))
                  ),
                  child: Image.network(senderProfileUrl)),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(senderName, style: TextStyle(
                                    fontSize: 16.0, color: colorBlack),
                                ),
                                SizedBox(height: 5.0),
                                Text(message,
                                  style: TextStyle(fontSize: 14.0, color: colorBlack),
                                  maxLines: 1,
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: 60.0,
                          height: 35.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2.0,),
                              Text(time, style: TextStyle(fontSize: 12.0, color: colorBrown),),
                              SizedBox(height: 3.0,),
                              Text(date, style: TextStyle(fontSize: 11.0, color: colorBrown),)
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(thickness: 1.5,)
                  ],
                ),
              ),
            ]),
        FlatButton(
          minWidth: MediaQuery.of(context).size.width,
          child: null,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LiveChat(
                chatId, senderUId, senderName, senderProfileUrl, receiverName, receiverProfileUrl)));
          },
        )
      ],
    );
  }


  Future _fetchChatsFromDB() async {

    FirebaseDatabase databaseReference = FirebaseDatabase.instance;
    prefs = await SharedPreferences.getInstance();

    Timer(
      Duration(seconds: 8), () {
      setState(() => _isQueryComplete = true);
    },
    );

    databaseReference.reference().child("chats").child(prefs.getString("currentUser"))
        .once().then((DataSnapshot dataSnapshot) {
      messageList.clear();
      setState(() => _isQueryComplete = true);
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys){
        MessageData data = new MessageData(
          values [key]["chatId"],
          values [key]["senderName"],
          values [key]["senderProfileUrl"],
          values [key]["senderUId"],
          values [key]["receiverName"],
          values [key]["receiverProfileUrl"],
          values [key]["receiverUId"],
          values [key]["date"],
          values [key]["time"],
          values [key]["message"],
        );
        messageList.add(data);
      }
    });
  }



}
