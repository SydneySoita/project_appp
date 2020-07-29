import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/empty_widget.dart';
import 'package:wetreats/widgets/order_item_card.dart';

class CartPage extends StatefulWidget {
  final bool showAppBar;

  CartPage({this.showAppBar});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _largeSpace = SizedBox(height: 10.0);
  var _mediumSpace = SizedBox(height: 10.0);

  var textStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: widget.showAppBar ?  AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(LineAwesomeIcons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Items In Your Cart",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                ),
              ),
              centerTitle: true,
            ) : null,
            bottomNavigationBar: model.orderItems.length > 0 ? Container(
                    height: 210.0,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, -3.0))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Subtotal", style: textStyle),
                            Text(
                              "Ksh${model.subTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _mediumSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Discount", style: textStyle),
                            Text(
                              "- Ksh${model.discount.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _mediumSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Tax", style: textStyle),
                            Text(
                              "Ksh${model.tax.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _mediumSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Total Price", style: textStyle),
                            Text(
                              "Ksh${model.totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        _largeSpace,
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/checkout_page");
                            },
                            child: Button(
                              btnText: "PROCESS ORDER",
                              width: 160.0,
                              height: 45.0,
                              color: Theme.of(context).primaryColor,
                              fill: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: model.orderItems.length > 0 ?  ListView.builder(
                itemCount: model.orderItems.length,
                itemBuilder: (BuildContext lctx, int index) {
                  return OrderItemCard(
                    orderItem: model.orderItems[index],
                  );
                },
              ) : EmptyWidget(iconData: LineAwesomeIcons.shopping_cart, message: "You haven't added any items yet.",),
            ),
          );
        },
      ),
    );
  }


}
