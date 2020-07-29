import "package:flutter/material.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/models/order_items.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem orderItem;

  OrderItemCard({this.orderItem});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        Item theItem = model.getItemById(orderItem.itemId);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          height: 120.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5.0, offset: Offset(0, 3), color: Colors.black12),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10.0),
                width: 90.0,
                height: 90.0,
                decoration: theItem.imageUrl == null
                    ? BoxDecoration(
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 1,
                          color: Colors.black12,
                        ),
                      )
                    : null,
                child: theItem.imageUrl != null
                    ? Image.network(
                        theItem.imageUrl,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          LineAwesomeIcons.image,
                          color: Colors.black12,
                          size: 50.0,
                        ),
                      ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${theItem.name}",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Ksh${orderItem.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    Expanded(
                        child: Container(
                      width: 200.0,
                      child: Text(
                        Functions.capitalizeString(
                            Functions.shortText(theItem.description, 60)),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                        ),
                      ),
                    )),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 30.0,
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  model.decreaseOrderItemQuantityByOne(
                                      orderItem.itemId);
                                },
                                child: Icon(
                                  LineAwesomeIcons.minus_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                "${orderItem.quantity}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  model.increaseOrderItemQuantityByOne(
                                      orderItem.itemId);
                                },
                                child: Icon(
                                  LineAwesomeIcons.plus_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            model.removeOrderItem(orderItem.itemId);
                          },
                          child: Icon(
                            LineAwesomeIcons.trash,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
