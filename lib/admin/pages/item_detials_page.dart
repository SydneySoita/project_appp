import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';

class ItemDetailsPage extends StatefulWidget {
  final Item item;

  ItemDetailsPage({@required this.item});

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  var _smallVerticalSpace = SizedBox(
    height: 10.0,
  );

  var _largeVerticalSpace = SizedBox(
    height: 50.0,
  );

  var _mediumVerticalSpace = SizedBox(
    height: 25.0,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext sctx, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "${widget.item.name}",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(LineAwesomeIcons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.item.imageUrl
                                ),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.black12,
                                offset: Offset(0, 3.0),
                              ),
                            ]),
                      ),
                      // Positioned(
                      //   bottom: 10.0,
                      //   right: 10.0,
                      //   child: Row(
                      //     children: <Widget>[
                      //       _buildImageIconButton(
                      //         LineAwesomeIcons.heart_o,
                      //       ),
                      //       SizedBox(
                      //         width: 10.0,
                      //       ),
                      //       _buildImageIconButton(
                      //         LineAwesomeIcons.cart_plus,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  _smallVerticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${widget.item.name}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Ksh${widget.item.price}",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _mediumVerticalSpace,
                  Text(
                    "Item Description:",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.item.description}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  _mediumVerticalSpace,
                  Text(
                    "Av. Quantity",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.item.quantity}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                  _mediumVerticalSpace,
                  Text(
                    "Discount",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.item.discount}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                  _mediumVerticalSpace,
                  Text(
                    "Category",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${model.getCategoryNameById(widget.item.categoryId)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                  _mediumVerticalSpace,
                  Text(
                    "Store",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.getStoreById(widget.item.storeId).name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageIconButton(IconData icon) {
    return Container(
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
      child: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
