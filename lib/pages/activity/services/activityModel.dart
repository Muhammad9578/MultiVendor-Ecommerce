import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mos_beauty/provider/rest.dart';

class ActivityModel {
  static Future<List<MediaSocialData>> activityModel(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'social-media.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final mediaSocialData = mediaSocialDataFromJson(response);
        return mediaSocialData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future socialLike(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'social-like.php');
      var statusCode = result[0];
      var response = result[1];
      print(response);
      if (statusCode == 200) {
        print(response);
      } else {
        print(response);
      }
    } catch (e) {
      return e;
    }
  }

  static Future socialPost(jsons, context) async {
    try {
      var result = await GetAPI.providers(jsons, 'social-post.php');
      var statusCode = result[0];
      var response = result[1];
      print(response);
      if (statusCode == 200) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      return e;
    }
  }

  static Future<List<CommentData>> socialComment(jsons, context) async {
    try {
      var result = await GetAPI.providers(jsons, 'social-view-comment.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final commentData = commentDataFromJson(response);
        return commentData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future socialAddComment(jsons, context) async {
    try {
      var result = await GetAPI.providers(jsons, 'social-comment.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        print(response);
      } else {
        print(response);
      }
    } catch (e) {
      return e;
    }
  }
}

List<MediaSocialData> mediaSocialDataFromJson(String str) =>
    List<MediaSocialData>.from(
        json.decode(str).map((x) => MediaSocialData.fromJson(x)));

String mediaSocialDataToJson(List<MediaSocialData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MediaSocialData {
  MediaSocialData({
    this.id,
    this.content,
    this.mediaType,
    this.mediaContent,
    this.postBy,
    this.dateTime,
    this.userName,
    this.fullName,
    this.userImage,
    this.userType,
    this.countLike,
    this.countComment,
    this.doneLike,
  });

  String id;
  String content;
  String mediaType;
  String mediaContent;
  String postBy;
  String dateTime;
  dynamic userName;
  String fullName;
  String userImage;
  String userType;
  int countLike;
  int countComment;
  bool doneLike;

  factory MediaSocialData.fromJson(Map<String, dynamic> json) =>
      MediaSocialData(
        id: json["id"],
        content: json["content"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        mediaContent:
            json["media_content"] == null ? null : json["media_content"],
        postBy: json["post_by"],
        dateTime: json["date_time"],
        userName: json["user_name"],
        fullName: json["full_name"],
        userImage: json["user_image"],
        userType: json["user_type"],
        countLike: json["countLike"],
        countComment: json["countComment"],
        doneLike: json["doneLike"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "media_type": mediaType == null ? null : mediaType,
        "media_content": mediaContent == null ? null : mediaContent,
        "post_by": postBy,
        "date_time": dateTime,
        "user_name": userName,
        "full_name": fullName,
        "user_image": userImage,
        "user_type": userType,
        "countLike": countLike,
        "countComment": countComment,
        "doneLike": doneLike,
      };
}

List<CommentData> commentDataFromJson(String str) => List<CommentData>.from(
    json.decode(str).map((x) => CommentData.fromJson(x)));

String commentDataToJson(List<CommentData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentData {
  CommentData({
    this.commentId,
    this.content,
    this.userId,
    this.childOf,
    this.dateTime,
    this.readAt,
    this.userName,
    this.fullName,
    this.userType,
    this.userImage,
  });

  String commentId;
  String content;
  String userId;
  dynamic childOf;
  String dateTime;
  dynamic readAt;
  String userName;
  String fullName;
  String userType;
  String userImage;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        commentId: json["comment_id"],
        content: json["content"],
        userId: json["user_id"],
        childOf: json["child_of"],
        dateTime: json["date_time"],
        readAt: json["read_at"],
        userName: json["user_name"],
        fullName: json["full_name"],
        userType: json["user_type"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "content": content,
        "user_id": userId,
        "child_of": childOf,
        "date_time": dateTime,
        "read_at": readAt,
        "user_name": userName,
        "full_name": fullName,
        "user_type": userType,
        "user_image": userImage,
      };
}
