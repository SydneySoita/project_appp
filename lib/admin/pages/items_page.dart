import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_item_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/item_card.dart';

class ItemsPage extends StatefulWidget {
  final MainModel model;

  ItemsPage({this.model});
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  // global keys
  GlobalKey<ScaffoldState> _itemsPageScaffoldKey = GlobalKey();

  var textStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _itemsPageScaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: Text("All Items", style: TextStyle(color: Theme.of(context).primaryColor),),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {})
          ],
        ),
        body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: model.itemSize > 0
                      ? _buildListView(model)
                      : _buildIsEmptyWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(MainModel model) {
    return ListView.builder(
      itemCount: model.items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildAddNewButton();
        }
        return ItemCard(
          item: model.items[index - 1],
        );
      },
    );
  }

  Widget _buildIsEmptyWidget() {
    return ListView(
      children: <Widget>[
        _buildAddNewButton(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Center(
            child: Text(
              "There are no items, click on the button above to add new items.",
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: () async {
        final bool response = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => AddItemPage()));
        if (response) {
          _itemsPageScaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
              content: Text(
                "Product added successfully",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          );
        }
      },
      child: Button(
        btnText: "ADD NEW ITEM",
        height: 56.0,
        color: Theme.of(context).primaryColor,
        fontSize: 18,
        fill: true,
      ),
    );
  }
}
