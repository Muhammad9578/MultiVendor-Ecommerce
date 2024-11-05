import 'package:flutter/material.dart';
import 'package:mos_beauty/pages/listAllOrders/listAllOrders.dart';
import 'package:mos_beauty/pages/listCancelled/listCancelled.dart';
import 'package:mos_beauty/pages/listCompleted/listCompleted.dart';
import 'package:mos_beauty/pages/listReturn/listReturn.dart';
import 'package:mos_beauty/pages/listToDelivery/listToDelivery.dart';
import 'package:mos_beauty/pages/listToPay/listToPay.dart';
import 'package:mos_beauty/pages/listToReceived/listToReceived.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final borderField = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  @override
  void initState() {
    _controller = new TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            isScrollable: true,
            // automaticIndicatorColorAdjustment: true,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            controller: _controller,
            tabs: [
              Tab(
                text: 'TO\nPAY',
              ),
              Tab(
                text: 'ALL\nORDERS',
              ),
              Tab(
                text: 'TO\nDELIVERY',
              ),
              Tab(
                text: 'TO\nRECEIVED',
              ),
              Tab(
                text: 'COMPLETED',
              ),
              Tab(
                text: 'CANCELLED',
              ),
              Tab(
                text: 'RETURN/REFUND/\nDISPUTE',
              ),
            ],
          ),
        ),
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: new TabBarView(
          controller: _controller,
          children: <Widget>[
            ListToPay(),
            ListAllOrders(),
            ListToDelivery(),
            ListToReceived(),
            ListCompleted(),
            ListCancelled(),
            ListToReturn(),
          ],
        ),
      ),
    );
  }
}
