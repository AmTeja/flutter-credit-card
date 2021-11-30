import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.user,
    this.tokens,
  });

  UserClass user;
  Tokens tokens;

  factory User.fromJson(Map<String, dynamic> json) => User(
    user: UserClass.fromJson(json["user"]),
    tokens: Tokens.fromJson(json["tokens"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "tokens": tokens.toJson(),
  };
}

class Tokens {
  Tokens({
    this.access,
    this.refresh,
  });

  Access access;
  Access refresh;

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    access: Access.fromJson(json["access"]),
    refresh: Access.fromJson(json["refresh"]),
  );

  Map<String, dynamic> toJson() => {
    "access": access.toJson(),
    "refresh": refresh.toJson(),
  };
}

class Access {
  Access({
    this.token,
    this.expires,
  });

  String token;
  DateTime expires;

  factory Access.fromJson(Map<String, dynamic> json) => Access(
    token: json["token"],
    expires: DateTime.parse(json["expires"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expires": expires.toIso8601String(),
  };
}

class UserClass {
  UserClass({
    this.id,
    this.email,
    this.name,
    this.role,
  });

  String id;
  String email;
  String name;
  String role;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "role": role,
  };
}
