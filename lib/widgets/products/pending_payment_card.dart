import 'package:flutter/material.dart';

import './price_tag.dart';
// import '../ui_elements/title_default.dart';
import '../../models/payment.dart';
import '../../scoped-models/main.dart';

class PendingPaymentCard extends StatefulWidget {
  final Payment payment;
  final int productIndex;
  final MainModel model;

  PendingPaymentCard(this.payment, this.productIndex, this.model);

  @override
  State<StatefulWidget> createState() {
    return _PendingPaymentCardState();
  }
}

class _PendingPaymentCardState extends State<PendingPaymentCard> {
  // final Product product = Product();

  void _submitForm() {
    print('confirm paymentId: ' + widget.payment.paymentId);
    widget.model.confirmPayment(widget.payment.paymentId);
    // widget.model.fetchPayments();
  }

  Widget _buildStatusComponet(BuildContext context, MainModel model) {
    if (widget.payment.amount > 0) {
      return RaisedButton(
        color: Colors.green,
        textColor: Colors.white,
        child: Text('Confirm'),
        onPressed: () => _submitForm(),
      );
    } else {
      return Text(
        '     Pending     ',
        style: TextStyle(color: Colors.red),
      );
    }
  }

  Widget _buildTitlePriceRow(BuildContext context, MainModel model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          model.setReceiver(widget.payment.receiver);
          model.fetchPayments();
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.payment.receiver,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.payment.description,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ]),
            ),
            // SizedBox(
              // width: 16.0,
            // ),
            PriceTag(widget.payment.amount.toString()),
            _buildStatusComponet(context, model)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          _buildTitlePriceRow(context, widget.model),
          // AddressTag('Union Square, San Francisco'),
          // Text(product.userEmail),
          // _buildActionButtons(context)
        ],
      ),
    );
    ;
  }
}
