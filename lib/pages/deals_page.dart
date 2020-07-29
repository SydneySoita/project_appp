import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/food_item_card.dart';
import 'package:wetreats/widgets/item_dialog.dart';

class DealsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> mainScreenScaffoldKey;
  DealsPage({this.mainScreenScaffoldKey});

  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          color: Colors.grey.shade100,
          child: GridView.builder(
            itemCount: model.getDiscountItems().length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  model.resetItemValues(model.getDiscountItems()[index].id);
                  showSimpleCustomDialog(model.getDiscountItems()[index]);
                },
                child: FoodItemCard(
                  itemId: model.getDiscountItems()[index].id,
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.67,
            ),
          ),
        );
      },
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
                      topLeft: Radius.circular(15.0),),),
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
                      mainKey: widget.mainScreenScaffoldKey,
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
