import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mos_beauty/pages/editProfile/service/editProfileModel.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profileModel.dart';

class EditProfile extends StatefulWidget {
  final ProfileUser profileUser;

  EditProfile({this.profileUser});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final username = TextEditingController();
  final email = TextEditingController();
  final dateOfBirth = TextEditingController();
  final address = TextEditingController();
  final contactNo = TextEditingController();
  final fullName = TextEditingController();
  final billingAddress = TextEditingController();
  final bankName = TextEditingController();
  final bankNoAccount = TextEditingController();

  final picker = ImagePicker();

  final String male = "Male";
  final String female = "Female";

  String _radioValue; //Initial definition of radio button value
  String choice;

  File imageFile;
  String userImage;
  // final picker = ImagePicker();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Male':
          choice = value;
          break;
        case 'Female':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

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
          userImage = "";
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
          userImage = "";
          imageFile = imageCrop;
        });
      }
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    setState(() {
      userImage = widget.profileUser.image;
      username.text = widget.profileUser.userName;
      email.text = widget.profileUser.email;
      address.text = widget.profileUser.billingAddress;
      contactNo.text = widget.profileUser.contactNo;
      fullName.text = widget.profileUser.fullName;
      dateOfBirth.text =
          DateFormat("dd/mm/yyyy").format(widget.profileUser.dob);
      if (widget.profileUser.gender == "Male") {
        _radioValue = male;
        choice = male;
      } else {
        _radioValue = female;
        choice = female;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.18,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 30, right: 30),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: userImage != ""
                                    ? NetworkImage(
                                        "https://mosbeauty.my/mos/pages/user/pic/${widget.profileUser.image}?v=${DateTime.now().millisecondsSinceEpoch}",
                                      )
                                    : imageFile != null
                                        ? FileImage(imageFile)
                                        : AssetImage(
                                            'assets/images/placeholder-avatar.png'),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: ClipOval(
                            child: Material(
                              color: Colors.pink[300], // button color
                              child: InkWell(
                                splashColor: Colors.pink[300], // inkwell color
                                child: SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: Icon(
                                      Icons.edit,
                                      size: 16,
                                    )),
                                onTap: () {
                                  _showChoiceDialog(context);
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: fullName,
                    readOnly: false,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontFamily: 'Karla',
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: username,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontFamily: 'Karla',
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      disabledColor: Colors.grey,
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: email,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'Karla',
                        ),
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      disabledColor: Colors.grey,
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: address,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'Karla',
                        ),
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      disabledColor: Colors.grey,
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: contactNo,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: "Contact No",
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'Karla',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'Karla',
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 0,
                        ),
                      ),
                      Radio(
                        value: male,
                        groupValue: _radioValue,
                        onChanged: radioButtonChanges,
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'Karla',
                        ),
                      ),
                      Radio(
                        value: female,
                        groupValue: _radioValue,
                        onChanged: radioButtonChanges,
                      ),
                      Text(
                        "Female",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontFamily: 'Karla',
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: dateOfBirth,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    decoration: InputDecoration(
                      labelText: "Date Of Birth",
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontFamily: 'Karla',
                      ),
                    ),
                    onTap: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildBottomPicker(
                            CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              maximumDate: DateTime.now(),
                              initialDateTime: DateTime(1998, 1, 1),
                              onDateTimeChanged: (DateTime newDateTime) {
                                setState(() {
                                  final formatter = DateFormat('dd/MM/yyyy');
                                  dateOfBirth.text =
                                      formatter.format(newDateTime);
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomWidget())
        ],
      ),
    );
  }

  double _kPickerSheetHeight = 216.0;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  GestureDetector bottomWidget() {
    return GestureDetector(
      onTap: () {
        if (imageFile != null) {
          List<int> imageBytes = imageFile.readAsBytesSync();
          String base64Image = base64.encode(imageBytes);
          var jsons = {};
          jsons["full_name"] = fullName.text;
          // jsons["username"] = username.text;
          jsons["email"] = email.text;
          jsons["image"] = base64Image;
          jsons["contactNo"] = contactNo.text;
          jsons["address"] = address.text;
          jsons["billing_address"] = billingAddress.text;
          jsons["dob"] = dateOfBirth.text.replaceAll("/", "-");
          jsons["gender"] = choice;
          jsons["bank_name"] = bankName.text;
          jsons["bank_no_account"] = bankNoAccount.text;
          EditProfileModel.userProfileUpdate(jsons, context);
        } else {
          var jsons = {};
          jsons["full_name"] = fullName.text;
          // jsons["username"] = username.text;
          jsons["email"] = email.text;
          jsons["image"] = widget.profileUser.image;
          jsons["contactNo"] = contactNo.text;
          jsons["address"] = address.text;
          jsons["billing_address"] = billingAddress.text;
          jsons["dob"] = dateOfBirth.text.replaceAll("/", "-");
          jsons["gender"] = choice;
          jsons["bank_name"] = bankName.text;
          jsons["bank_no_account"] = bankNoAccount.text;
          EditProfileModel.userProfileUpdate(jsons, context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[4],
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "SAVE CHANGES",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
}
