import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/food_item_card.dart';
import 'package:wetreats/widgets/item_dialog.dart';
import 'package:wetreats/pages/store_item_page.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage({this.model});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _mediumSpace = SizedBox(height: 16.0);

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool _isFetchingAllInfos = true;

  @override
  void initState() {
    if (widget.model != null) {
      widget.model.fetchAllInfos().then((value){
        _isFetchingAllInfos = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.grey.shade100,
            body: _isFetchingAllInfos ? Center(
              child: CircularProgressIndicator(),
            ) :  ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              itemCount: model.categories.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildStoreListView(model);
                } else {
                  final List<Item> items =
                      model.getItemsByCategory(model.categories[index - 1].id);
                  return items.length == 0
                      ? _buildNoItemsFound()
                      : model
                                  .getItemsByCategory(
                                      model.categories[index - 1].id)
                                  .length >
                              0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${model.categories[index - 1].name}",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                _mediumSpace,
                                Container(
                                  height: 260.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overscroll) {
                                      overscroll.disallowGlow();
                                      return true;
                                    },
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items.length,
                                      itemBuilder:
                                          (BuildContext context, int ind) {
                                        return GestureDetector(
                                          onTap: () {
                                            model
                                                .resetItemValues(items[ind].id);
                                            showSimpleCustomDialog(items[ind]);
                                          },
                                          child: FoodItemCard(
                                            itemId: items[ind].id,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Offstage();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoItemsFound() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text("There are no items yet."),
      ),
    );
  }

  Widget _buildStoreListView(MainModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Available Sellers",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        _mediumSpace,
        Container(
          height: 110.0,
          width: MediaQuery.of(context).size.width,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: model.stores.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext nctx) => StoreItemPage(
                          store: model.stores[index],
                        ) 
                      ),
                    );
                  },
                  child: _buildStoreDesign(
                    model.stores[index].imageUrl,
                    model.stores[index].name,
                  ),
                );
              },
            ),
          ),
        ),
        _mediumSpace,
      ],
    );
  }

  Widget _buildStoreDesign(String imageUrl, String name) {
    return Container(
      width: 110.0,
      margin: EdgeInsets.only(
        right: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5.0,
                    offset: Offset(0, 3.0),
                    color: Colors.black45),
              ],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "$name",
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ],
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
                      topLeft: Radius.circular(15.0))),
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
                      mainKey: scaffoldKey,
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
