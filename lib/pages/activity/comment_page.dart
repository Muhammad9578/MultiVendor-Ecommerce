import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/pages/activity/services/activityModel.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profileModel.dart';
import 'package:mos_beauty/utils/pallete.dart';

class CommentPage extends StatefulWidget {
  final MediaSocialData item;
  final ProfileUser profileUser;
  CommentPage(this.item, this.profileUser);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  MediaSocialData item;
  bool isActive = false;
  bool hasBorder = false;
  List<CommentData> listOfComment = [];
  final comment = TextEditingController();
  bool loading = true;
  List showComment = [];

  @override
  void initState() {
    _checkUserIdNull();
    super.initState();
  }

  _checkUserIdNull() {
    if (widget.profileUser.userId != null) {
      var jsons = {};
      item = widget.item;
      jsons['post_id'] = item.id;
      ActivityModel.socialComment(jsons, context).then((value) {
        if (mounted) {
          setState(() {
            listOfComment = value;
            loading = false;
          });
        }
      });
    } else {
      
    }
  }

  _getUserTypeImage(MediaSocialData item) {
    switch (item.userType) {
      case 'user':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/user/account/profile/pic/' +
                    item.userImage);
        break;
      case 'influencer':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/user/account/profile/pic/' +
                    item.userImage);
        break;
      case 'merchant':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos/pages/merchant/pic/' +
                    item.userImage);
        break;
      case 'staff':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos/pages/staff-merchant/pic/' +
                    item.userImage);
        break;
      default:
        return CachedNetworkImageProvider(
            'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png');
    }
  }

  _getUserCommentTypeImage(CommentData item) {
    switch (item.userType) {
      case 'user':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/user/account/profile/pic/' +
                    item.userImage);
        break;
      case 'influencer':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/user/account/profile/pic/' +
                    item.userImage);
        break;
      case 'merchant':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos/pages/merchant/pic/' +
                    item.userImage);
        break;
      case 'staff':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos/pages/staff-merchant/pic/' +
                    item.userImage);
        break;
      default:
        return CachedNetworkImageProvider(
            'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png');
    }
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  _sendApiToAddComment() {
    var jsons = {};
    jsons['post_id'] = item.id;
    jsons['comment_text'] = comment.text;
    jsons['date_time'] = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());
    //String time = timeAgoSinceDate(jsons['date_time']);
    showComment.add(jsons);
    comment.clear();
    if (mounted) {
      setState(() {
        item.countComment++;
      });
    }
    ActivityModel.socialAddComment(jsons, context);
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
          "Comment",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leadingWidth: 80,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Palette.facebookBlue,
                                          child: CircleAvatar(
                                            radius: hasBorder ? 17.0 : 20.0,
                                            backgroundColor: Colors.grey[200],
                                            backgroundImage:
                                                _getUserTypeImage(item),
                                          ),
                                        ),
                                        isActive
                                            ? Positioned(
                                                bottom: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  height: 15.0,
                                                  width: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: Palette.online,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 2.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.userName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                item.dateTime + '.',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Icon(
                                                Icons.public,
                                                color: Colors.grey[600],
                                                size: 12.0,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.more_horiz),
                                    //   onPressed: () {},
                                    // )
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Text(item.content),
                                item.mediaType != null
                                    ? const SizedBox.shrink()
                                    : const SizedBox(
                                        height: 6.0,
                                      ),
                              ],
                            ),
                          ),
                          item.mediaType != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child:
                                      // Image.network(
                                      //     'https://mosbeauty.my/mos.website/social-feed/uploads/' +
                                      //         item.mediaContent)
                                      CachedNetworkImage(
                                    imageUrl:
                                        'https://mosbeauty.my/mos.website/social-feed/uploads/' +
                                            item.mediaContent,
                                    // placeholder: (context, url) =>
                                    //     CircularProgressIndicator(),
                                    // errorWidget: (context, url, error) =>
                                    //     Icon(Icons.error),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Palette.facebookBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.thumb_up,
                                    size: 10.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Expanded(
                                  child: Text(
                                    // '${post.likes}',
                                    '${item.countLike}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                Text(
                                  //'${post.comments} Comments',
                                  '${item.countComment} Comments',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 8.0),
                                // Text(
                                //   //'${post.shares} Shares',
                                //   '2 Shares',
                                //   style: TextStyle(color: Colors.grey[600]),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: listOfComment.map((CommentData e) {
                        return Container(
                          margin: EdgeInsets.only(top: 8),
                          height: 70,
                          color: Colors.white,
                          width: double.infinity,
                          child: ListTile(
                            leading: Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _getUserCommentTypeImage(e),
                                ),
                              ),
                            ),
                            title: Text(
                              e.content,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            subtitle: Text(
                              e.dateTime + " ( " + e.userName + " )",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    showComment.isNotEmpty
                        ? Column(
                            children: showComment
                                .map(
                                  (e) => Container(
                                    margin: EdgeInsets.only(top: 8),
                                    height: 70,
                                    color: Colors.white,
                                    width: double.infinity,
                                    child: ListTile(
                                      leading: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: widget.profileUser.image !=
                                                    ""
                                                ? CachedNetworkImageProvider(
                                                    'https://mosbeauty.my/mos/pages/user/pic/' +
                                                        widget
                                                            .profileUser.image)
                                                : AssetImage(
                                                    'assets/images/user1.jpg',
                                                  ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        e['comment_text'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        timeAgoSinceDate(e['date_time']) +
                                            " ( " +
                                            widget.profileUser.userName +
                                            " )",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                )
                                .toList())
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
                Align(alignment: Alignment.bottomCenter, child: bottomWidget())
              ],
            ),
    );
  }

  InkWell bottomWidget() {
    return InkWell(
      onTap: () {},
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: kElevationToShadow[2],
            color: Colors.white,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: widget.profileUser.image != ""
                        ? CachedNetworkImageProvider(
                            'https://mosbeauty.my/mos/pages/user/pic/' +
                                widget.profileUser.image)
                        : AssetImage(
                            'assets/images/user1.jpg',
                            // height: 70,
                            // width: 70,
                            // fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 10),
                  child: TextField(
                    controller: comment,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey),
                        hintText: "Add a comment",
                        suffixIcon: IconButton(
                          onPressed: () => _sendApiToAddComment(),
                          icon: Icon(Icons.send),
                        ),
                        fillColor: Colors.white70),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
