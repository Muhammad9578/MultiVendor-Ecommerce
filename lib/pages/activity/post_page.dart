import 'dart:convert';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:mos_beauty/pages/activity/services/activityModel.dart';

class PostPage extends StatefulWidget {
  final bool havePost;
  PostPage({this.havePost});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File imageFile;
  final caption = TextEditingController();
  final picker = ImagePicker();

  _openGallery(BuildContext context) async {
    var pitcure =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 600);
    if (pitcure != null) {
      File imageCrop = await ImageCropper.cropImage(
          sourcePath: pitcure.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (mounted) {
        this.setState(() {
          imageFile = imageCrop;
        });
      }
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var pitcure =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pitcure != null) {
      File imageCrop = await ImageCropper.cropImage(
        sourcePath: pitcure.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (mounted) {
        setState(() {
          imageFile = imageCrop;
        });
      }
    }
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Add Image",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Choose from gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Take photo"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _sendApi() {
    if (imageFile != null) {
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);
      var jsons = {};
      jsons["mediaImage"] = base64Image;
      jsons["mediaContent"] = caption.text;
      ActivityModel.socialPost(jsons, context);
    } else {
      var jsons = {};
      jsons["mediaImage"] = "";
      jsons["meidaContent"] = caption.text;
      ActivityModel.socialPost(jsons, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ),
        ),
        title: Text(
          "New post",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leadingWidth: 80,
        actions: [
          InkWell(
            onTap: () => _sendApi(),
            child: Center(
              child: Text('Post',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16)),
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => _showChoiceDialog(context),
            child: Container(
              margin: EdgeInsets.all(25),
              height: 250,
              width: double.infinity,
              decoration: new BoxDecoration(
                color: Colors.white,
                image: new DecorationImage(
                  image: imageFile != null
                      ? FileImage(imageFile)
                      : AssetImage("assets/images/upload.png"),
                  fit: imageFile != null ? BoxFit.cover : BoxFit.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: TextField(
              controller: caption,
              keyboardType: TextInputType.multiline,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Caption",
                  fillColor: Colors.white70),
            ),
          )
        ],
      ),
    );
  }
}
