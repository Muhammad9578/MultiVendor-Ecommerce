import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/pages/walletPoint/services/walletPointModel.dart';
import 'package:mos_beauty/utils/format.dart';

class WalletPoint extends StatefulWidget {
  @override
  _WalletPointState createState() => _WalletPointState();
}

class _WalletPointState extends State<WalletPoint> {
  WalletUser walletUser;
  bool loading = true;
  int onTapType = 1;

  @override
  void initState() {
    _getTypePoint('mosPoint');
    super.initState();
  }

  _getTypePoint(type) {
    var jsons = {};
    jsons["type"] = type;
    WalletPointModel().eWalletUserPhp(jsons).then((value) {
      if (this.mounted) {
        setState(() {
          walletUser = value;
          loading = false;
        });
      }
    });
  }

  sendTypeApiProcess() {
    if (onTapType == 2) {
      //TODO process withdraw
    } else {
      //TODO process paymentgateway
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Wallet',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.only(left: 10, right: 10),
              children: [
                selectTypePoint(),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  onTapType == 1
                                      ? 'MOS POINT'
                                      : onTapType == 2
                                          ? 'MOS GOLD'
                                          : 'E-TOPUP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onTapType != 1
                                  ? FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                      color: Colors.white,
                                      textColor: Colors.red,
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () => sendTypeApiProcess(),
                                      child: Text(
                                        onTapType == 2
                                            ? "WITHDRAW".toUpperCase()
                                            : "TOP UP".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          Text(
                            onTapType != 1
                                ? 'RM ${Format().currency(walletUser.mosPoint.toDouble(), decimal: false)}'
                                : '${Format().currency(walletUser.mosPoint.toDouble(), decimal: false)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                                letterSpacing: 2),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'MEMBER ID',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            walletUser.memberId,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                                letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                walletUser.transactionHistory.isNotEmpty
                    ? Column(
                        children: walletUser.transactionHistory
                            .map((item) => Container(
                                  height: 80,
                                  margin: EdgeInsets.only(bottom: 1),
                                  width: double.infinity,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        item.referType,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        DateFormat('dd/MM/yyyy hh:mm a')
                                            .format(item.datetime),
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      trailing: Text(
                                        item.action == "add"
                                            ? "+" + item.currentPoint + " pts"
                                            : "-" + item.currentPoint + " pts",
                                        style: TextStyle(
                                          color: item.action == "add"
                                              ? Colors.blue
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      )
                    : Text(
                        'No transaction history...',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      )
              ],
            ),
    );
  }

  Container selectTypePoint() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      height: 35,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          mosPoint(1),
          SizedBox(width: 10),
          mosGold(2),
          SizedBox(width: 10),
          eTopUp(3),
        ],
      ),
    );
  }

  Widget eTopUp(mosType) {
    return InkWell(
      onTap: () {
        if (this.mounted) {
          setState(() {
            _getTypePoint('eTopUp');
            onTapType = mosType;
          });
        }
      },
      child: Container(
        height: 50,
        width: 110,
        decoration: BoxDecoration(
          color: onTapType == mosType ? Colors.grey : HexColor('#CAF3FF'),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: Text(
            'E-TOPUP',
            style: TextStyle(
                color: onTapType == mosType ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget mosGold(mosType) {
    return InkWell(
      onTap: () {
        if (this.mounted) {
          setState(() {
            _getTypePoint('mosGold');
            onTapType = mosType;
          });
        }
      },
      child: Container(
        height: 50,
        width: 110,
        decoration: BoxDecoration(
          color: onTapType == mosType ? Colors.grey : HexColor('#CAF3FF'),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: Text(
            'MOS GOLD',
            style: TextStyle(
                color: onTapType == mosType ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget mosPoint(mosType) {
    return InkWell(
      onTap: () {
        if (this.mounted) {
          setState(() {
            _getTypePoint('mosPoint');
            onTapType = mosType;
          });
        }
      },
      child: Container(
        height: 50,
        width: 110,
        decoration: BoxDecoration(
          color: onTapType == mosType ? Colors.grey : HexColor('#CAF3FF'),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Center(
          child: Text(
            'MOS POINT',
            style: TextStyle(
                color: onTapType == mosType ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
