import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/payment.dart';
import '../../scoped-models/main.dart';
import '../ui_elements/title_default.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(BuildContext context, MainModel model) {
    List<Payment> payments = model.displayedPayments;
    Widget productCards;
    if (payments.length > 0) {
      productCards = Column(
        children: <Widget>[
          TitleDefault('Total Amount: ${model.totalAmount}'),
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
                    Navigator.pushReplacementNamed(context, '/payments');
                  },
                ),
                SizedBox(
                  width: 8.0,
                ),
                RaisedButton(
                  child: const Text('Square Account'),
                  color: Theme.of(context).primaryColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, '/payments');
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(payments[index], index),
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
