import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/pages/home_page.dart';
import 'package:mos_beauty/pages/login/service/loginModel.dart';
import 'package:mos_beauty/pages/register/sing_up.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:mos_beauty/Theme/yommie_theme.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/pages/forgotPassword/forgot_password.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'Login',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: false,
        ),
        backgroundColor: Colors.transparent,
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: ResponsiveFlutter.of(context).verticalScale(100),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/MOSLogo-01.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            ResponsiveFlutter.of(context).verticalScale(20)),
                    TextField(
                      controller: username,
                      autocorrect: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.black,
                        ),
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: false,
                        fillColor: HexColor("#d9ecf2"),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(color: HexColor("#d9ecf2"), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: HexColor("#d9ecf2")),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: password,
                      autocorrect: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.black,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.black54),
                        filled: false,
                        fillColor: HexColor("#d9ecf2"),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(color: HexColor("#d9ecf2"), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: HexColor("#d9ecf2")),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: RaisedButton(
                        color: HexColor('#CAF8FC'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          var jsons = {};
                          jsons["username"] = username.text;
                          jsons["password"] = password.text;
                          LoginModel.loginPhp(jsons, context).then((value) {
                            print('value at Login page is $value');
                            setState(() {
                              loading = false;
                            });

                            // print(" value at login $value");
                          });
                        },
                        child: Text("LOGIN"),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ForgotPassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password",
                            style: YommieTheme.display1,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          color: Colors.black54,
                          width: 2,
                          height: 14,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: YommieTheme.display1,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
