import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';

class FoodItemCard extends StatelessWidget {

  final String itemId;

  FoodItemCard(
      {@required this.itemId});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Item item = model.getItemById(itemId);
        return Container(
          margin: EdgeInsets.only(right: 16.0, top: 16.0, bottom: 16.0),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 260.0,
                width: 160.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      offset: Offset(0, 3.0),
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              item.discount <= 0 || item.discount <= 0.0
                  ? Offstage()
                  :

              Positioned(
                right: 0.0,
                child: IconButton(
                  icon: Icon(
                    item.isFavorite ? LineAwesomeIcons.heart :  LineAwesomeIcons.heart_o,
                    color: item.isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    model.toggleItemFavorite(itemId);
                  },
                ),
              ),
              Positioned(
                left: 30,
                top: 40,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                bottom: 15.0,
                left: 15.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${item.name}",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      model.getStoreById(item.storeId).name,
                      style: TextStyle(fontSize: 16.0, color: Colors.black45),
                    ),
                    Text(
                      "Ksh${item.price}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      )),
                  child: Center(
                    child: Icon(
                      LineAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
