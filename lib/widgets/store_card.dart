import "package:flutter/material.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_store_page.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/store.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  StoreCard({this.store});

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
                    decoration: store == null || store.imageUrl == null
                        ? BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.black12),
                          )
                        : null,
                    child: store == null || store.imageUrl == null
                        ? Center(
                            child: Icon(
                              LineAwesomeIcons.image,
                              color: Colors.black12,
                              size: 50.0,
                            ),
                          )
                        : Image.network(
                            store.imageUrl,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Functions.capitalizeString(
                            Functions.shortText(
                              store.name,
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
                                  store.description,
                                  47,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
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
                      onTap: () async {
                        final bool response = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext pCtx) => CreateStorePage(
                              store: store,
                            ),
                          ),
                        );
                        if (response) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text(
                              "Store details updated successfully",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ));
                        }
                      },
                      child: _buildStoreCardButton(
                        Colors.white,
                        LineAwesomeIcons.edit,
                      ),
                    ),
                    _buildStoreCardButton(
                      Colors.white,
                      LineAwesomeIcons.eye,
                    ),
                    GestureDetector(
                      onTap: () {
                        showLoadingProgress(context, "Deleting store...");
                        model.deleteStore(store.id).then((bool response) {
                          Navigator.of(context).pop();
                          if (response) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Theme.of(context).primaryColor,
                                content: Text(
                                  "Store deleted successfully",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }else if(!response){
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                  "Failed to delete store",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: _buildStoreCardButton(
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

  Widget _buildStoreCardButton(Color color, IconData iconData,
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
