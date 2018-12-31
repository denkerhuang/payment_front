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
        // Navigator.pushReplacementNamed(context, '/products/${payment.receiver}');
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
            Text(widget.payment.receiver),
            SizedBox(
              width: 8.0,
            ),
            PriceTag(widget.payment.amount.toString())
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(context,
                    '/product/' + model.allProducts[widget.productIndex].id),
              ),
              IconButton(
                icon: Icon(model.allProducts[widget.productIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model
                      .selectProduct(model.allProducts[widget.productIndex].id);
                  model.toggleProductFavoriteStatus();
                },
              ),
            ]);
      },
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
