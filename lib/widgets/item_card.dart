import "package:flutter/material.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_item_page.dart';
import 'package:wetreats/admin/pages/item_detials_page.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  ItemCard({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    width: 90.0,
                    height: 90.0,
                    decoration: item == null || item.imageUrl == null
                        ? BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.black12),
                          )
                        : null,
                    child: item == null || item.imageUrl == null
                        ? Center(
                            child: Icon(
                              LineAwesomeIcons.image,
                              color: Colors.black12,
                              size: 50.0,
                            ),
                          )
                        : Image.network(
                            item.imageUrl,
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
                          ),
                  ),
                  Expanded(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Functions.capitalizeString(
                            Functions.shortText(
                              item.name,
                              25,
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: Container(
                          width: 200.0,
                          child: Text(
                            Functions.capitalizeString(
                              Functions.shortText(
                                item.description,
                                47,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                            ),
                          ),
                        )),
                        Text(
                          "Ksh${item.price}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Container(
                width: 40.0,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext pCtx) => AddItemPage(
                            item: item,
                          ),
                        ),
                      ),
                      child: _buildItemCardButton(
                        Colors.white,
                        LineAwesomeIcons.edit,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ItemDetailsPage(
                              item: item,
                            ),
                          ),
                        );
                      },
                      child: _buildItemCardButton(
                        Colors.white,
                        LineAwesomeIcons.eye,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showLoadingProgress(context, "Deleting item...");
                        model
                            .deleteItem(item.id)
                            .then((_) => Navigator.of(context).pop());
                      },
                      child: _buildItemCardButton(
                        Colors.red,
                        LineAwesomeIcons.trash,
                        haveBorder: false,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemCardButton(Color color, IconData iconData,
      {bool haveBorder = true}) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        border: haveBorder
            ? Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              )
            : null,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: color,
        ),
      ),
    );
  }
}
