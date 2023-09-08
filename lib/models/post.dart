import 'package:flutter_laravel_api/models/user.dart';

class Posts{
  int? id;
  String? body, image;
  int? likesCount, commentairesCount;
  bool?  selfLiked;
  User? user;

  Posts({this.id, this.body, this.likesCount, this.image, this.commentairesCount, this.user, this.selfLiked});

  factory Posts.fromJson(Map<String, dynamic> json){
    return Posts(
        id: json['id'],
        body: json['body'],
        likesCount:json['likesCount'],
        commentairesCount: json['commentairesCount'],
        image: json['image'],
        selfLiked: json['likesCount'].toString().length > 0,
        user: User(
            id: json['id'],
            name: json['name'],
            image: json['image']
        )
    );
  }

  Map<String, dynamic> toMap() => {"id": id, "body" : body, "likesCount" : likesCount,"image": image, "commentairesCount": commentairesCount, "user": user, "selfLiked" : selfLiked};
}