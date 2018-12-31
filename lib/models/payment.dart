import 'package:flutter/material.dart';

class Payment {
  final String paymentId;
  final String receiver;
  final double amount;

  Payment({this.paymentId, @required this.receiver, this.amount});

  Payment.fromJson(Map<String, dynamic> json)
      : paymentId = json['PaymentId'],
        receiver = json['Receiver'],
        amount = json['Amount'];
}
