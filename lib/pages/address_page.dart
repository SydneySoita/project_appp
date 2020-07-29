import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/pages/add_shipping_address.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class AddressesPage extends StatefulWidget {
  final MainModel model;

  AddressesPage({this.model});
  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
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
          title: Text(
            "Delivery Addresses",
            style: TextStyle(
                fontSize: 16.0, color: Theme.of(context).primaryColor),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {})
          ],
        ),
        body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: model.shippingAddresses.length > 0
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
      itemCount: model.shippingAddresses.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildAddNewButton();
        }

        String fullName = model.shippingAddresses[index - 1].firstName +
            " " +
            model.shippingAddresses[index - 1].lastName;
        return Container(
          margin: EdgeInsets.only(top: 16.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          height: 112.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3.0),
                color: Colors.black12,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$fullName",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${model.shippingAddresses[index - 1].address}",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${model.shippingAddresses[index - 1].phoneNumber}",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40.0,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext pCtx) => AddShippingAddressPage(
                            shippingAddress: model.shippingAddresses[index - 1],
                          ),
                        ),
                      ),
                      child: _buildItemCardButton(
                        Colors.white,
                        LineAwesomeIcons.edit,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showLoadingProgress(context, "Deleting address...");
                        model
                            .deleteShippingAddress(
                                model.shippingAddresses[index - 1].id)
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
              )
            ],
          ),
        );
      },
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

  Widget _buildIsEmptyWidget() {
    return ListView(
      children: <Widget>[
        _buildAddNewButton(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Center(
            child: Text(
              "You have no address yet.",
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
        // final bool response = await
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AddShippingAddressPage(),
          ),
        );
        // if (response) {
        //   _itemsPageScaffoldKey.currentState.showSnackBar(
        //     SnackBar(
        //       backgroundColor: Theme.of(context).primaryColor,
        //       duration: Duration(seconds: 2),
        //       content: Text(
        //         "Product added successfully",
        //         style: TextStyle(color: Colors.white, fontSize: 16.0),
        //       ),
        //     ),
        //   );
        // }
      },
      child: Button(
        btnText: "ADD NEW ADDRESS",
        height: 56.0,
        color: Theme.of(context).primaryColor,
        fontSize: 18,
        fill: true,
      ),
    );
  }
}
