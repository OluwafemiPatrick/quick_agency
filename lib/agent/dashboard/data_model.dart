import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  String chatId, riderName, senderName, date, time, senderProfileUrl;

  MessageData(this.chatId, this.riderName, this.senderName, this.date,
      this.time, this.senderProfileUrl);

}


class LiveChatData {

  final String message;
  final String time;
  final String date;
  final String profileImageUrl;
  final String senderName;
  final String senderId;

  final DocumentReference reference;

  LiveChatData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['message'] != null),
        assert(map['time'] != null),
        assert(map['date'] != null),
        assert(map['profileImageUrl'] != null),
        assert(map['senderName'] != null),
        assert(map['senderId'] != null),

        message = map['message'],
        time = map['time'],
        date = map['date'],
        profileImageUrl = map['profileImageUrl'],
        senderName = map['senderName'],
        senderId = map['senderId'];

  LiveChatData.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);


}