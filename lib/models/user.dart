class User{
  int? id;
  String? name, image, email, token;

  User({this.id, this.name, this.email, this.image, this.token});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      email:json['email'],
      token: json['token'],
      image: json['image']
    );
  }

  Map<String, dynamic> toMap() => {"id": id, "name" : name, "email" : email,"image": image, "token": token};
}