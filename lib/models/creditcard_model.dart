import 'package:flutter/material.dart';

class CreditCardModel {
  final Color color;
  final String cardNumber;
  final String cardHolder;
  final String cardExpiration;

  CreditCardModel(
      {
        this.color,
        this.cardNumber,
        this.cardHolder,
        this.cardExpiration
      });

}