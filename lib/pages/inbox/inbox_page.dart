import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/pages/chat/chatScreen.dart';
import 'package:mos_beauty/pages/chat/service/message_model.dart';
import 'package:mos_beauty/pages/home/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  Stream messageListStream;
  String spliteId2;

  List<Message> messagess = [];
  List<String> msgIds = [];
  List<String> msgNames;
  List<String> msgUrls;
  HashMap<String, Message> lastMsg = new HashMap();
  Message eachMessage;
  String currentId;
  String otherUserId;
  String otherUserName;
  String otherAvatarUrl;
  String currentName;
  String currentUserImage;

  @override
  void initState() {
    // TODO: implement initState
    retrieveMessageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderBar(context: context),
        Divider(
          height: 1,
          thickness: 1,
        ),
        Container(
          width: double.infinity,
          height: 80,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.chat,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {}),
                  Text(
                    'Chat ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  )
                ],
              ),
              // Container(
              //   height: double.infinity,
              //   width: 1,
              //   color: Colors.grey,
              // ),
              Column(
                children: [
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.ticketAlt,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {}),
                  Text(
                    'Notification ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
        //newMethod(),
        Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: lastMsg.length > 0
                ? ListView.builder(
                    itemCount: lastMsg.length,
                    itemBuilder: (context, int index) {
                      otherUserId = msgIds[index];
                      print(
                          "List item $index : $otherUserId and oother username $otherUserName");
                      otherUserName = msgNames[index];
                      otherAvatarUrl = msgUrls[index];
                      // print(
                      // "current otheruserid: $otherUserId length of msgs: ${lastMsg.length}\n${lastMsg.keys}");
                      eachMessage = lastMsg[otherUserId];
                      return InboxPageItem(msgIds[index], eachMessage,
                          currentName, currentId, currentUserImage);
                    })
                : Center(
                    // child: Text(
                    //   'No notification yet',
                    //   style: TextStyle(color: Colors.blueGrey),
                    // ),
              child:CircularProgressIndicator(),
                  ))
      ],
    );

    /*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HeaderBar(context: context),
        Container(
          height: 80,
          width: double.infinity,
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: SizedBox(
                width: 45,
                child: Center(
                  child: Icon(
                    Icons.notification_important,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
              ),
              title: Text(
                'Promotions',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Our birthday\' comming and but you get asdasd',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
        ),
        Container(
          height: 80,
          width: double.infinity,
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: SizedBox(
                width: 45,
                child: Center(
                  child: Icon(
                    Icons.notification_important,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
              ),
              title: Text(
                'Social Updates',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Our birthday\' comming and but you get asdasd',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'Order Updates',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                fontSize: 16),
          ),
        ),
        Container(
          height: 170,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              Container(
                height: double.infinity,
                width: 80,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ClipOval(
                      child: Image.asset(
                        "assets/images/courses1.jpeg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Confirm Receipt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please check that all items for your order 20113VHEE43U90 have been delivered. If you are satisfied with your order, click on Order Received to release payment to the seller.',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 170,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              Container(
                height: double.infinity,
                width: 80,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ClipOval(
                      child: Image.asset(
                        "assets/images/courses2.jpg",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Refund',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please check that all items for your order 20113VHEE43U90 have been delivered. If you are satisfied with your order, click on Order Received to release payment to the seller.',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 80,
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ); */
  }

  Container newMethod() {
    return Container(
      height: 170,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Container(
            height: double.infinity,
            width: 80,
            child: Column(
              children: [
                SizedBox(height: 10),
                ClipOval(
                  child: Image.asset(
                    "assets/images/courses1.jpeg",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Confirm Receipt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please check that all items for your order 20113VHEE43U90 have been delivered. If you are satisfied with your order, click on Order Received to release payment to the seller.',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 80,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  retrieveMessageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentId = prefs.getString("userId");
      currentName = prefs.getString("userName");
      currentUserImage = prefs.getString('image');
    });

    print('Current name and id:$currentName($currentId)');
    QuerySnapshot el = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where("users", arrayContains: '$currentName($currentId)')
        .get();
    for (DocumentSnapshot element in el.docs) {
      //List<dynamic> idString = element.data.values.toList().elementAt(0);

      // print(
      //     "First: ${element.data("users")[0]}\nSecond: ${element.data["users"][1]}");

      String personCombineId = element.get("users")[0];
      if (personCombineId.substring(0, personCombineId.lastIndexOf("(")) ==
          currentName) {
        personCombineId = element.get("users")[1];
      }
      otherUserId = personCombineId.substring(
          personCombineId.lastIndexOf("(") + 1,
          personCombineId.lastIndexOf(")"));
      print("Othere user Id id here $otherUserId");
      msgIds.add(otherUserId);
      QuerySnapshot snapshot = await element.reference
          .collection("chats")
          .orderBy("time", descending: true)
          .get();

      messagess.add(Message.fromDocument(snapshot.docs.elementAt(0)));
      if (!lastMsg.containsKey(otherUserId)) {
        lastMsg.addAll(
            {otherUserId: Message.fromDocument(snapshot.docs.elementAt(0))});
      }

      print("Shouldve added msg");
    }

    msgNames = List<String>(msgIds.length);
    msgUrls = List<String>(msgIds.length);
    // QuerySnapshot usersSnapshot =
    //     await FirebaseFirestore.instance.collection("Users").get();
    // CollectionReference usersRef =
    //     FirebaseFirestore.instance.collection("Users");
    // msgNames = List<String>(msgIds.length);
    // msgUrls = List<String>(msgIds.length);
    // for (var i = 0; i < msgIds.length; i++) {
    //   Map<String, dynamic> ref = usersSnapshot.docs
    //       .firstWhere((element) => element.id == msgIds[i])
    //       .data();
    //   print("Iteration $i : id = ${msgIds[i]}");
    //   msgNames[i] = ref["name"];
    //   print("Name: ${msgNames[i]}");
    //   msgUrls[i] = ref["avatarUrl"];
    // }
    setState(() {});
  }
}

class InboxPageItem extends StatelessWidget {
  Message eachMessage;
  String currentName;
  String otherUserId;
  String currentUserImage;
  String currentUserId;

  InboxPageItem(
    this.otherUserId,
    this.eachMessage,
    this.currentName,
    this.currentUserId,
    this.currentUserImage,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
                serviceProviderId: otherUserId,
                userName: eachMessage.sendTo,
                avatarUrl: eachMessage.otherPic,
                currentUserId: currentUserId,
                currentUserName: currentName,
                currentUserImage: currentUserImage),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
          decoration: BoxDecoration(color: Color(0xFFFFEFEE)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(eachMessage.otherPic)
                      //chats[index].sender
                      ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        eachMessage.sendTo,
                        //chats[index].sender
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      Text(
                        (eachMessage.messageType == 'File' ||
                                eachMessage.messageType == 'Picture')
                            ? eachMessage.sendTo == currentName
                                ? "${eachMessage.sendTo} send you a Attachment"
                                : "You send an Attachment"
                            : eachMessage.messageType == 'Video'
                                ? "${eachMessage.sendTo} send you a Video"
                                : eachMessage.message,
                        //chats[index].message
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    timeago.format(eachMessage.time.toDate()),
                    //${chats[index].time}'

                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  eachMessage.unread
                      ? Container(
                          width: 40.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Text(
                              'New',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Text(''),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
