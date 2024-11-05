import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:flutter/services.dart';
import 'package:mos_beauty/pages/register/service/registerModel.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String dataPick;
  String dateOfBirthPicker;
  bool loading = false;
  bool checkboxValue = false;
  bool checkboxValue2 = false;
  bool checkboxValueIsEmpty = false;
  bool checkboxValueIsEmpty2 = false;

  InputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: HexColor("#d9ecf2"), width: 2),
  );
  InputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: HexColor("#d9ecf2"), width: 2),
  );
  InputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: HexColor("#d9ecf2"), width: 2),
  );
  InputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: HexColor("#d9ecf2")),
  );

  final username = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final dateOfBirth = TextEditingController();
  bool validateDob = false;
  bool validateGender = false;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
  }

  validationForm() {
    if (_formKey.currentState.validate()) {
      if (password.text == confirmPassword.text) {
        if (dataPick != null && dateOfBirthPicker != null) {
          setState(() {
            dataPick == null ? validateGender = true : validateGender = false;
            dateOfBirthPicker == null
                ? validateDob = true
                : validateDob = false;
          });
          _formKey.currentState.save();
          var jsons = {};

          jsons["user_name"] = username.text;
          jsons["email"] = email.text;
          jsons['full_name'] = firstName.text + ' ' + lastName.text;
          jsons["password"] = password.text;
          jsons["dob"] = dateOfBirthPicker.replaceAll("/", "-");
          jsons["gender"] = dataPick;
          RegisterModel.registerPhp(jsons, context);
        } else {
          setState(() {
            dataPick == null ? validateGender = true : validateGender = false;
            dateOfBirthPicker == null
                ? validateDob = true
                : validateDob = false;
          });
        }
      } else {
        showAlertDialog(context);
      }
    } else {}
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: TextStyle(color: HexColor('#75DFFF'))),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        'Password',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: Text("The password and confirmation password do not match. "),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 130),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/MOSLogo-01.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1 - 30,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: firstInput(),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: lastInput(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        usernameInput(),
                        SizedBox(height: 15),
                        emailInput(),
                        SizedBox(height: 15),
                        dateOfBirthLatest(context),
                        validateDob
                            ? Container(
                                width: double.infinity,
                                height: 30,
                                padding: EdgeInsets.only(left: 25, top: 8),
                                child: Text('Invalid Date Of Birth',
                                    style: TextStyle(
                                        color: Colors.redAccent[700],
                                        fontSize: 12)),
                              )
                            : SizedBox(),
                        SizedBox(height: 15),
                        passwordInput(),
                        SizedBox(height: 15),
                        confirmPasswordInput(),
                        SizedBox(height: 15),
                        buildGender(),
                        validateGender
                            ? Container(
                                width: double.infinity,
                                height: 30,
                                padding: EdgeInsets.only(left: 25, top: 8),
                                child: Text('Invalid Date Of Birth',
                                    style: TextStyle(
                                        color: Colors.redAccent[700],
                                        fontSize: 12)),
                              )
                            : SizedBox(),
                        SizedBox(height: 15),
                        termsAndCondition1(),
                        termAndCondition2(),
                        SizedBox(height: 30),
                        SizedBox(
                          height: 40,
                          width: 200,
                          child: RaisedButton(
                            color: HexColor('#CAF8FC'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              // setState(() {
                              //   loading = true;
                              // });
                              if (checkboxValue && checkboxValue2) {
                                validationForm();
                              } else {
                                setState(() {
                                  !checkboxValue
                                      ? checkboxValueIsEmpty = true
                                      : checkboxValueIsEmpty = false;
                                  !checkboxValue2
                                      ? checkboxValueIsEmpty2 = true
                                      : checkboxValueIsEmpty2 = false;
                                });
                              }
                            },
                            child: Text("SUBMIT"),
                          ),
                        ),
                        SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 15,
                child: SafeArea(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  CheckboxListTile termAndCondition2() {
    return CheckboxListTile(
      value: checkboxValue2,
      onChanged: (val) {
        setState(() => checkboxValue2 = val);
      },
      subtitle: checkboxValueIsEmpty2
          ? Text(
              'Required.',
              style: TextStyle(color: Colors.red),
            )
          : null,
      title: Text(
        "I want to receive newsletter from M.O.S Beauty",
        style: TextStyle(fontSize: 14),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.green,
    );
  }

  CheckboxListTile termsAndCondition1() {
    return CheckboxListTile(
      value: checkboxValue,
      onChanged: (val) {
        setState(() => checkboxValue = val);
      },
      subtitle: checkboxValueIsEmpty
          ? Text(
              'Required.',
              style: TextStyle(color: Colors.red),
            )
          : null,
      title: Container(
        child: Text.rich(
          TextSpan(
            text: 'I have reads the ',
            style: TextStyle(fontSize: 14, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: 'Term & Regulations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // code to open / launch terms of service link here
                    }),
            ],
          ),
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.green,
    );
  }

  Container dateOfBirthLatest(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: HexColor("#d9ecf2"),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: HexColor("#d9ecf2"),
          width: 2,
        ),
      ),
      height: 50,
      padding: EdgeInsets.only(top: 15, left: 30),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
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
                      dateOfBirthPicker = formatter.format(newDateTime);
                    });
                  },
                ),
              );
            },
          );
        },
        child: dateOfBirthPicker == null
            ? Text(
                "Date Of Birth",
                style: TextStyle(color: Colors.black54),
              )
            : Text(
                dateOfBirthPicker,
                style: TextStyle(color: Colors.black),
              ),
      ),
    );
  }

  Container buildGender() {
    return Container(
      width: double.infinity,
      height: 50.0,
      padding: EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        // color: HexColor("#d9ecf2"),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: HexColor("#d9ecf2"),
          width: 2,
        ),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        value: dataPick,
        focusColor: Colors.black,
        iconDisabledColor: Colors.black,
        iconEnabledColor: Colors.black,
        isExpanded: true,
        style: TextStyle(color: Colors.black),
        dropdownColor: HexColor("#d9ecf2"),
        hint: Text(
          "Gender",
          style: TextStyle(color: Colors.black54),
        ),
        items: <String>['Male', 'Female'].map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            dataPick = value;
          });
        },
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

  Widget firstInput() {
    return TextFormField(
      controller: firstName,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      focusNode: FocusNode(),
      validator: (name) {
        if (name == "") {
          return 'Invalid first name';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'First Name',
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget lastInput() {
    return TextFormField(
      controller: lastName,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      focusNode: FocusNode(),
      validator: (name) {
        if (name == "") {
          return 'Invalid last name';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'Last Name',
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget usernameInput() {
    return TextFormField(
      controller: username,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      focusNode: FocusNode(),
      validator: (username) {
        if (username == '') {
          return 'username invalid';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'Username',
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget emailInput() {
    return TextFormField(
      controller: email,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      focusNode: FocusNode(),
      validator: (email) {
        Pattern pattern =
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(email)) {
          return 'Invalid email';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'E-Mail',
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget passwordInput() {
    return TextFormField(
      controller: password,
      obscureText: true,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      focusNode: FocusNode(),
      validator: (password) {
        if (password == "") {
          return 'Invalid password';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget confirmPasswordInput() {
    return TextFormField(
      controller: confirmPassword,
      obscureText: true,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      focusNode: FocusNode(),
      validator: (confirmPassword) {
        if (confirmPassword == "") {
          return 'Invalid confirm password';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'Confirm Password',
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget dateOfBirthInput() {
    return TextFormField(
      controller: dateOfBirth,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.number,
      autocorrect: true,
      validator: (dateOfBirth) {
        if (dateOfBirth == "") {
          return 'Invalid date of birth';
        } else {
          return null;
        }
      },
      inputFormatters: [maskFormatter],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 30),
        hintText: 'dd/mm/yyyy',
        hintStyle: TextStyle(color: Colors.black54),
        filled: false,
        fillColor: HexColor("#d9ecf2"),
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
