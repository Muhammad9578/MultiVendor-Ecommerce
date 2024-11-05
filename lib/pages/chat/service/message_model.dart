


import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sendFrom;
  final String sendTo;
  final String otherPic;
  final Timestamp time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String message;

  final String messageType;
  final bool unread;

  Message({
    this.sendFrom,
    this.time,
    this.message,
    this.unread,
    this.sendTo,
    this.otherPic,
    this.messageType,
  });
  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      sendFrom: doc['sendFrom'],
      sendTo:doc['sendTo'],
      otherPic: doc['otherPic'],
      message: doc['message'],
      time: doc['time'],
      unread: doc['unread'],
      messageType:doc['messageType']
    );
  }
}
