import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/models/store.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/empty_widget.dart';
import 'package:wetreats/widgets/food_item_card.dart';
import 'package:wetreats/widgets/item_dialog.dart';

class StoreItemPage extends StatefulWidget {
  final Store store;
  StoreItemPage({this.store});

  @override
  _StoreItemPageState createState() => _StoreItemPageState();
}

class _StoreItemPageState extends State<StoreItemPage> {
  int counter = 1;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "${widget.store.name}'s Items",
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext ctx) => CartPage(
              //       showAppBar: true,
              //     ),
              //   ),
              // );
            },
          )
        ],
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return model.getItemsByStoreId(widget.store.id).length > 0
              ? Container(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0),
                  color: Colors.grey.shade100,
                  child: GridView.builder(
                    itemCount: model.getItemsByStoreId(widget.store.id).length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          model.resetItemValues(model
                              .getItemsByStoreId(widget.store.id)[index]
                              .id);
                          showSimpleCustomDialog(
                              model.getItemsByStoreId(widget.store.id)[index]);
                        },
                        child: FoodItemCard(
                          itemId: model
                              .getItemsByStoreId(widget.store.id)[index]
                              .id,
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.67,
                    ),
                  ),
                )
              : EmptyWidget(
                  iconData: LineAwesomeIcons.shopping_cart,
                  message: "This store have no items yet",
                );
        },
      ),
    );
  }

  void showSimpleCustomDialog(Item item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return ScopedModelDescendant(
          builder: (BuildContext sctx, Widget child, MainModel model) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0),
                ),
              ),
              child: Container(
                height: 450.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ItemDialog(
                      item: item,
                      model: model,
                      mainKey: _scaffoldKey,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
