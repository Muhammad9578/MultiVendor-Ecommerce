import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mos_beauty/pages/chat/service/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
//  final User user;
//
//  ChatScreen({this.user});

  String serviceProviderId;
  String avatarUrl;
  String userName;

  String currentUserName;
  String currentUserId;
  String currentUserImage;

  final ImagePicker _picker = ImagePicker();

  ChatScreen(
      {this.serviceProviderId,
      this.userName,
      this.avatarUrl,
      this.currentUserId,
      this.currentUserName,
      this.currentUserImage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool sendButtonVisible = false;
  String baseName;
  PickedFile _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;

  final ImagePicker _picker = ImagePicker();
  firebase_storage.Reference firebaseStorage =
      FirebaseStorage.instance.ref().child('MediaFiles');

  String tempFilename = "TempRecording";

  String onlineStatus;
  static List<Message> messages = [];
  Message eachMessage;
  CollectionReference messageColl =
      FirebaseFirestore.instance.collection('ChatRoom');
  TextEditingController messageController = new TextEditingController();
  File defaultAudioFile;
  String currentTime = "00:00";
  String completeTime = "00:00";
  CollectionReference chatCol;
  bool typing = false;
  bool holdMic = true;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    // TODO: implement initState

    checkallpermission();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);

    print(
        "Current Name ${widget.currentUserName} id ${widget.currentUserId}    and other user Id =${widget.serviceProviderId} ${widget.userName} ");
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');

    flickManager.dispose();
    // _controller.dispose();

    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  // @override
  // void deactivate() {
  //   if (_controller != null) {
  //     _controller.setVolume(0.0);
  //     _controller.removeListener(listener);
  //     _controller.pause();
  //   }
  //   super.deactivate();
  // }

  checkallpermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage
    ].request();

    if (statuses[Permission.camera].isGranted) {
      if (statuses[Permission.microphone].isGranted) {
        // openCamera();
      } else {
        // Toast("Camera needs to access your microphone, please provide permission", position: Gravity.);
      }
    } else {
      // Toast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
    }
  }

  checkpermission() async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    var galleryStatus = await Permission.storage.status;
    if (!cameraStatus.isGranted) await Permission.camera.request();

    if (!microphoneStatus.isGranted) await Permission.microphone.request();
    if (!galleryStatus.isGranted) await Permission.storage.request();
  }

  bool  click = false;
  FlickManager flickManager;

  VoidCallback listener;
  @override
  Widget build(BuildContext context) {
//    retrieveMessage();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: widget.userName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  // TextSpan(text: '\n'),
                  // TextSpan(text: onlineStatus)
                ],
              ))),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.95,
              child: StreamBuilder<QuerySnapshot>(
                  stream: messageColl
                      .doc('${widget.currentUserName}&${widget.userName}')
                      .collection('chats')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {

                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
//                       eachMessage=messages[index];

                          bool isMe =
                              snapshot.data.docs[index].get('sendFrom') ==
                                  widget.currentUserName;

                          String msgType =
                              snapshot.data.docs[index].get('messageType');
                          print("messageType $msgType ");

                          if (msgType == "Video") {

                            flickManager = FlickManager(
                              videoPlayerController:
                              VideoPlayerController.network("${snapshot.data.docs[index].get('message')}")
                              ,
                            );


                            // _controller = VideoPlayerController.network(
                            //    "${snapshot.data.docs[index].get('message')}"
                            //
                            // );
                            //     _controller.initialize();
        // .whenComplete(() {
                          // _controller.addListener(listener);
                          // _controller.setVolume(1.0);
                            //   setState(() {
                            // //
                            //   });
                            // });
                            // _playVideo(snapshot.data.docs[index].get('message'));

                          }

                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.end,
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.end,
                              children: [
                                msgType == "Picture"
                                    ? Align(
                                        alignment: isMe
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          margin: isMe
                                              ? EdgeInsets.only(right: 15.0)
                                              : EdgeInsets.only(left: 15.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot.data.docs[index]
                                                        .get('message'),
                                                  ),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                      )
                                    : msgType == "Video"
                                        ? Container(
                                  alignment: isMe? Alignment.topRight:Alignment.topLeft,

                                  margin:const EdgeInsets.only(top:50.0,bottom: 20.0),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                    MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.5,
                                    minWidth:
                                    MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.3,
                                    maxHeight: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.3,
                                    minHeight: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.2,
                                  ),
                                          child: FlickVideoPlayer(
                                                     flickManager: flickManager,
                                                 ),
                                        )
                                        : msgType == "File"
                                            ? isMe?FilePreviewer(message:'${snapshot.data.docs[index].get('message')}'): Container(
                                                alignment: isMe
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: 75.0,
                                                color: Colors.grey,
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height: 75.0,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      minWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    // decoration: BoxDecoration(
                                                    //   color: Colors.grey,
                                                    //   borderRadius:
                                                    //   BorderRadius.circular(15),
                                                    //   boxShadow: [
                                                    //     BoxShadow(
                                                    //         color: Colors.grey
                                                    //             .withOpacity(0.5),
                                                    //         spreadRadius: 2,
                                                    //         blurRadius: 5)
                                                    //   ],
                                                    // ),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          child: Icon(
                                                            Icons
                                                                .arrow_circle_down_outlined,
                                                            size: 45.0,
                                                            color: Colors.white,
                                                          ),
                                                          onTap: () async {
                                                            // File downloadToFile = File('${appDocDir.path}/Mos_Beauty${snapshot.data.docs[index].get('fileName')}');
                                                            //
                                                            //   await firebase_storage.FirebaseStorage.instance
                                                            //       .ref().child("PictureMedia/${snapshot.data.docs[index].get('message')}")
                                                            //       .writeToFile(downloadToFile);

                                                            final appDocDir =
                                                                await getExternalStorageDirectory();
                                                            final taskId =
                                                                await FlutterDownloader
                                                                    .enqueue(
                                                              url:
                                                                  '${snapshot.data.docs[index].get('message')}',
                                                              savedDir:
                                                                  appDocDir
                                                                      .path,
                                                              fileName:
                                                                  '${snapshot.data.docs[index].get('fileName')}',
                                                              showNotification:
                                                                  true,
                                                              // show download progress in status bar (for Android)
                                                              openFileFromNotification:
                                                                  true, // click on notification to open downloaded file (for Android)
                                                            );
                                                          },
                                                        ),
                                                        Text(
                                                            snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'fileName'),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    18.0)),
                                                      ],
                                                    )),
                                              )
                                            : Container(
                                                alignment: isMe
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 5)
                                                    ],
                                                  ),
                                                  child: Text(
                                                      snapshot.data.docs[index]
                                                          .get('message'),
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ),
                                SizedBox(height:30.0),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeago.format(snapshot.data.docs[index]
                                          .get('time')
                                          .toDate()),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black45),
                                    ),
                                    SizedBox(width: 8.0),
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                            )
                                          ]),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(widget
                                                    .currentUserImage ==
                                                ""
                                            ? 'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png'
                                            : 'https://mosbeauty.my/mos/pages/user/pic/${widget.currentUserImage}'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        });
                  }),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(

                // padding: EdgeInsets.symmetric(horizontal: 8),

                width: MediaQuery.of(context).size.width,
                // height:70.0,
                color: Colors.white,
                child: Row(children: <Widget>[
                  Container(
                    width: 40.0,
                    height: 70.0,
                    color: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.photo),
                      iconSize: 25,
                      color: Colors.white,
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 70.0,
                    child: TextField(
                      controller: messageController,
                      onChanged: (text) {
                        setState(() {
                          typing = true;
                        });
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Enter message here'),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    width: 40.0,
                    height: 70.0,
                    color: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 25,
                      color: Colors.white,
                      onPressed: () {
                        sendMessage("Text", messageController.text, "");
                      },
                    ),
                  ),
                ])),
          )
        ],
      ),
    );
  }

  // String _randomString(int length) {
  //   return random.randomNumeric(length);
  // }

  uploadPic(String path, String extension, String messageType,
      String fileName) async {
    File file = File(path);

    // setState(() {
    //   baseName = basename(path);
    // });

    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("PictureMedia/$fileName");
    firebase_storage.UploadTask uploadTask = reference.putFile(file);
    var downUrl = await (await uploadTask).ref.getDownloadURL();
    // print( "Chat Screen URL "+uploadTask.snapshot.ref.name);
    sendMessage(messageType, downUrl, fileName);
  }

  void sendMessage(String messageType, String message, String fileName) async {
    CollectionReference ref = messageColl
        .doc('${widget.currentUserName}&${widget.userName}')
        .collection("chats");
    List<String> userMap = [
      '${widget.currentUserName}(${widget.currentUserId})',
      '${widget.userName}(${widget.serviceProviderId})'
    ];
    await messageColl.doc('${widget.currentUserName}&${widget.userName}').set({
      "users": userMap,
      "chatRoomId": '${widget.currentUserName}&${widget.userName}'
    });
    ref.doc().set({
      'sendFrom': "${widget.currentUserName}",
      'time': DateTime.now(),
      'message': '$message',
      "otherPic": widget.avatarUrl,
      "sendTo": widget.userName,
      'unread': true,
      'fileName': fileName,
      'messageType': messageType,
    });
    messageColl
        .doc('${widget.userName}&${widget.currentUserName}')
        .collection("chats")
        .doc()
        .set({
      'sender': "${widget.currentUserName}",
      'time': DateTime.now(),
      'message': '$message',
      "otherPic": 'https://mosbeauty.my/mos/pages/user/pic/${widget.currentUserImage}',
      "sendTo": widget.userName,
      'unread': true,
      'fileName': fileName,
      'messageType': messageType,
    });
    messageController.text = '';
  }

  void _onImageButtonPressed(ImageSource gallery,
      {BuildContext context}) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'mp4', 'pdf', 'doc'],
    );
    print(
        " path ${result.files[0].path} extension ${result.files[0].extension} Type ${result.count} fileName ${result.names[0]}");
    switch (result.files[0].extension) {
      case 'png':
        uploadPic(result.files[0].path, result.files[0].extension, "Picture",
            result.names[0]);
        break;
      case 'jpg':
        uploadPic(result.files[0].path, result.files[0].extension, "Picture",
            result.names[0]);
        break;
      case 'mp4':
        uploadPic(result.files[0].path, result.files[0].extension, "Video",
            result.names[0]);
        break;
      case 'pdf':
        uploadPic(result.files[0].path, result.files[0].extension, "File",
            result.names[0]);
        break;
      case 'doc':
        uploadPic(result.files[0].path, result.files[0].extension, "File",
            result.names[0]);
        break;
    }
  }
}
// ignore: must_be_immutable
class FilePreviewer extends StatelessWidget {
  String message;
  FilePreviewer({this.message});
  @override
  Widget build(BuildContext context) {
    return PDF.network(
      message,
      height: MediaQuery.of(context).size.height*0.25,
      width: MediaQuery.of(context).size.width/2,
    );
  }
}

