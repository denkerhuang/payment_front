import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
// import '../ui_elements/title_default.dart';
import '../../models/payment.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatefulWidget {
  final Payment payment;
  final int productIndex;
  final MainModel model;

  ProductCard(this.payment, this.productIndex, this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductCardState();
  }
}

class _ProductCardState extends State<ProductCard> {
  // final Product product = Product();

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
            SizedBox(
              width: 8.0,
            ),
            PriceTag(widget.payment.amount.toString())
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
