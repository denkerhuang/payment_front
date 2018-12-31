import 'package:flutter/material.dart';

class Payment {
  final String paymentId;
  final String receiver;
  final String description;
  final double amount;

  Payment({this.paymentId, @required this.receiver, this.description, @required this.amount});

  Payment.fromJson(Map<String, dynamic> json)
      : paymentId = json['PaymentId'],
        receiver = json['Receiver'],
        description = json['Description'],
        amount = json['Amount'];
}
