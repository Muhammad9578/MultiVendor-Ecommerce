import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/pages/listAllOrders/service/purchasesModel.dart';
import 'package:mos_beauty/pages/return/service/returnModel.dart';
import 'package:mos_beauty/pages/viewShop/viewshop_page.dart';
import 'package:mos_beauty/utils/format.dart';

//* this page from list all orders
class ReturnPage extends StatefulWidget {
  final dynamic childItem;
  ReturnPage({this.childItem});
  @override
  _ReturnPageState createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  ListItem childItem;
  int _groupValue = -1;
  String reason0 = "Did not receive the order";
  String reason1 = "Received an incompleted product";
  String reason2 = "Received the wrong product";
  String reason3 = "Received a product with physical damage";
  String reason4 = "Received a faulty product";
  String reason5 = "Received a counterfelt product";
  TextEditingController reasonDescription = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    childItem = widget.childItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Return',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: ListView(
              children: [
                itemInfo(),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                itemReason(),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                itemDescription(),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                yourEmailAddress(),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomWidget())
        ],
      ),
    );
  }

  Container itemDescription() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: TextField(
                controller: reasonDescription,
                maxLines: 8,
                decoration: InputDecoration.collapsed(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(3.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: "Return / Refund Reason ... (optional)"),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Container yourEmailAddress() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            'Your Email Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: TextField(
                controller: email,
                maxLines: 8,
                decoration: InputDecoration.collapsed(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(3.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText:
                        "Set your email address so that we can contact you."),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Container itemReason() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 360,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'Reason : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _myRadioButton(
            title: reason0,
            value: 0,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: reason1,
            value: 1,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: reason2,
            value: 2,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: reason3,
            value: 3,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: reason4,
            value: 4,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: reason5,
            value: 5,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
        ],
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      // contentPadding: EdgeInsets.only(left: 1),
      dense: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  Container itemInfo() {
    return Container(
      color: Colors.white,
      height: 150,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    height: double.infinity,
                    width: 110,
                    child: checkItemTypeImage()),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                            childItem.merchantImage),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                childItem.merchantName,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 20.0,
                              height: 40.0,
                              child: RaisedButton(
                                color: Colors.greenAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ViewShop(
                                      merchantId: childItem.merchantId,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Visit Shop",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                childItem.itemName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              'RM ' +
                                  Format().currency(
                                      double.parse(childItem.priceDiscount),
                                      decimal: true),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                    Text(
                                      'Type',
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 110,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.childItem.quantity),
                                    textType(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  textType() {
    switch (childItem.itemType) {
      case Type.SERVICE:
        return Text('Service');
        break;
      case Type.PRODUCT:
        return Text('Product');
        break;
      case Type.COURSES:
        return Text('Courses');
        break;
      default:
    }
  }

  checkItemTypeImage() {
    switch (widget.childItem.itemType) {
      case Type.SERVICE:
        return CachedNetworkImage(
          imageUrl: 'https://mosbeauty.my/mos/pages/service/uploads/' +
              widget.childItem.itemImage,
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
        break;
      case Type.PRODUCT:
        return CachedNetworkImage(
          imageUrl: 'https://mosbeauty.my/mos/pages/product/uploads/' +
              widget.childItem.itemImage,
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
        break;
      case Type.COURSES:
        return CachedNetworkImage(
          imageUrl: 'https://mosbeauty.my/mos/pages/courses/uploads/' +
              widget.childItem.itemImage,
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
        break;
      default:
    }
  }

  sendToApi() {
    if (_groupValue >= 0) {
      var jsons = {};
      jsons['purchases_id'] = widget.childItem.purchasesId;
      jsons['purchases_item_id'] = widget.childItem.purchasesItemId;
      jsons['reason'] = dataReason();
      jsons['description'] = reasonDescription.text;
      jsons['email'] = email.text;
      ReturnModel.returnModel(jsons, context);
    } else {
      showAlertDialogTwoButton(context, 'Please select reason.');
    }
  }

  showAlertDialogTwoButton(BuildContext context, title) {
    // set up the buttons
    Widget okButton = FlatButton(
      child: Text("Ok", style: TextStyle(color: HexColor('#75DFFF'))),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        okButton,
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

  String dataReason() {
    switch (_groupValue) {
      case 0:
        return reason0;
        break;
      case 1:
        return reason1;
        break;
      case 2:
        return reason2;
        break;
      case 3:
        return reason3;
        break;
      case 4:
        return reason4;
        break;
      case 5:
        return reason5;
        break;
      default:
    }
  }

  InkWell bottomWidget() {
    return InkWell(
      onTap: () => sendToApi(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.only(bottom: 10, left: 30, right: 30),
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[4],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                color: Colors.red,
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Submit",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
