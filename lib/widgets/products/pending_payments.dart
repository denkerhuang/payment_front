import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pending_payment_card.dart';
import '../../models/payment.dart';
import '../../scoped-models/main.dart';
import '../ui_elements/title_default.dart';

class PendingPayments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PendingPaymentsState();
  }
}

class _PendingPaymentsState extends State<PendingPayments> {
  Widget _buildProductList(BuildContext context, MainModel model) {
    List<Payment> payments = model.displayedPayments;
    Widget productCards;
    if (payments.length > 0) {
      productCards = Column(
        children: <Widget>[
          TitleDefault('Total Pending Amount: ${model.totalAmount}'),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: const Text('Show All'),
                  color: Theme.of(context).primaryColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    setState(() {
                      model.fetchPayments();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                PendingPaymentCard(payments[index], index, model),
            itemCount: payments.length,
          ))
        ],
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(context, model);
      },
    );
  }
}
