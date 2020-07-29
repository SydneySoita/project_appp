import 'package:flutter/material.dart';
import 'package:wetreats/widgets/order_history_item_card.dart';


class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          children: <Widget>[
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
            OrderHistoryItemCard(),
          ],
        ),
      ),
    );
  }
}
