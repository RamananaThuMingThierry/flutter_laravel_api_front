import 'package:flutter_laravel_api/models/user.dart';

class Commentaires{
  int? id;
  String? commentaires;
  User? user;

  Commentaires({this.id, this.commentaires, this.user});

  factory Commentaires.fromJson(Map<String, dynamic> json){
    return Commentaires(
        id: json['id'],
        commentaires: json['Commentaires'],
        user: User(
            id: json['id'],
            name: json['name'],
            image: json['image']
        )
    );
  }

  Map<String, dynamic> toMap() => {"id": id, "Commentaires": Commentaires, "user": user};
}