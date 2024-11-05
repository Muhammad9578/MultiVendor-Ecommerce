import 'package:flutter/material.dart';
import 'package:mos_beauty/pages/seeReviews/service/reviewModel.dart';

class SeeReview extends StatefulWidget {
  final String itemType;
  final String itemId;
  SeeReview(this.itemType, this.itemId);
  @override
  _SeeReviewState createState() => _SeeReviewState();
}

class _SeeReviewState extends State<SeeReview> {
  List<ReviewData> reviewList = [];
  bool loading = true;

  @override
  void initState() {
    var jsons = {};
    jsons['item_type'] = widget.itemType;
    jsons['item_id'] = widget.itemId;
    ReviewModel.reviewModelPhp(jsons).then((value) {
      setState(() {
        reviewList = value;
        loading = false;
      });
    });
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
          'Review',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : reviewList.isNotEmpty
                ? ListView(
                    children: [
                      Column(
                          children: reviewList
                              .map(
                                (item) => Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  height: 100,
                                  width: double.infinity,
                                  child: Card(
                                    color: Colors.white70,
                                    child: ListTile(
                                      title: Text(item.feedback),
                                      subtitle: Text(item.dateTime.toString()),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ],
                  )
                : Center(child: Text('This item has no reviews.')),
      ),
    );
  }
}
