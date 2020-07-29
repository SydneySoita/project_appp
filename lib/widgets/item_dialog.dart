import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';

class ItemDialog extends StatefulWidget {
  final Item item;
  final MainModel model;
  final GlobalKey<ScaffoldState> mainKey;
  ItemDialog({this.item, this.model, this.mainKey});

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  int counter = 1;

  // text editing controller
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = widget.model.orderItemQuantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        return Column(
          children: <Widget>[
            Container(
              height: 160.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 160.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: widget.item.imageUrl == null
                        ? BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Colors.black12,
                            )),
                          )
                        : null,
                    child: widget.item.imageUrl != null
                        ? Image.network(
                            widget.item.imageUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                              size: 100.0,
                              color: Colors.black12,
                            ),
                          ),
                  ),
//                  Container(
//                    height: 30.0,
//                    width: 60.0,
//                    decoration: BoxDecoration(
//                      color: Theme.of(context).primaryColor,
//                    ),
//                    child: Center(
////                      child: Text(
////                        "Ksh${widget.item.price.toStringAsFixed(2)}",
////                        style: TextStyle(
////                          color: Colors.white,
////                          fontSize: 16.0,
////                          fontWeight: FontWeight.bold,
////                        ),
////                      ),
//                    ),
//                  )
                ],
              ),
            ),
            Container(
              height: 290.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${widget.item.name}",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        "Ksh${model.totalItemPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Expanded(
                    child: Text(
                      Functions.capitalizeString(
                          Functions.shortText(widget.item.description, 110)),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          LineAwesomeIcons.minus_circle,
                          size: 26.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          model.decreaseQuantityByOne(widget.item.id);
                          _textEditingController.text =
                              model.orderItemQuantity.toString();
                        },
                      ),
                      Container(
                        width: 100.0,
                        height: 26.0,
                        child: TextFormField(
                          controller: _textEditingController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          LineAwesomeIcons.plus_circle,
                          size: 26.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          model.increaseQuantityByOne(widget.item.id);
                          _textEditingController.text =
                              model.orderItemQuantity.toString();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Button(
                          btnText: "CANCEL",
                          fill: true,
                          color: Colors.redAccent,
                          bold: true,
                          fontSize: 16.0,
                          height: 35.0,
                          width: 80,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          model.changeChargeResult();
                          model.addOrderItem(widget.item.id);
                          Navigator.of(context).pop();
                          widget.mainKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text(
                              "Item added to cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),);
                        },
                        child: Button(
                          btnText: "ADD",
                          fill: true,
                          color: Theme.of(context).primaryColor,
                          bold: true,
                          fontSize: 16.0,
                          height: 35.0,
                          width: 80,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}