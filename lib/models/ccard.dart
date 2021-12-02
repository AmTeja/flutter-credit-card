// To parse this JSON data, do
//
//     final cCard = cCardFromJson(jsonString);

import 'dart:convert';

CCard cCardFromJson(String str) => CCard.fromJson(json.decode(str));

String cCardToJson(CCard data) => json.encode(data.toJson());

class CCard {
  CCard({
    this.results,
    this.page,
    this.limit,
    this.totalPages,
    this.totalResults,
  });

  List<Result> results;
  int page;
  int limit;
  int totalPages;
  int totalResults;

  factory CCard.fromJson(Map<String, dynamic> json) => CCard(
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    totalResults: json["totalResults"],
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalResults": totalResults,
  };
}

class Result {
  Result({
    this.category,
    this.name,
    this.cardExpiration,
    this.cardHolder,
    this.cardNumber,
    this.id,
  });

  String category;
  String name;
  String cardExpiration;
  String cardHolder;
  String cardNumber;
  String id;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    category: json["category"],
    name: json["name"],
    cardExpiration: json["cardExpiration"],
    cardHolder: json["cardHolder"],
    cardNumber: json["cardNumber"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "name": name,
    "cardExpiration": cardExpiration,
    "cardHolder": cardHolder,
    "cardNumber": cardNumber,
    "id": id,
  };
}
