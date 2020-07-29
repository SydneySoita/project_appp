import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_store_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/store_card.dart';

class StoresPage extends StatefulWidget {
  final MainModel model;

  StoresPage({this.model});
  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  // global keys
  GlobalKey<ScaffoldState> _storesPageScaffoldKey = GlobalKey();

  var textStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _storesPageScaffoldKey,
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
          title: Text(
            "All Stores",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {})
          ],
        ),
        body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: model.stores.length > 0
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
      itemCount: model.stores.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildAddNewButton();
        }
        return StoreCard(
          store: model.stores[index - 1],
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
              "There are no stores available, click on the button above to add new stores.",
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
            builder: (BuildContext context) => CreateStorePage(),
          ),
        );

        if (response) {
          _storesPageScaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "New store detials added successfully",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
      child: Button(
        btnText: "ADD NEW STORE",
        height: 56.0,
        color: Theme.of(context).primaryColor,
        fontSize: 18,
        fill: true,
      ),
    );
  }
}
