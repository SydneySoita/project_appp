import "package:flutter/material.dart";
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/categories_page.dart';
import 'package:wetreats/admin/pages/items_page.dart';
import 'package:wetreats/admin/pages/persons_page.dart';
import 'package:wetreats/admin/pages/stores_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/drawer.dart';

class Dashboard extends StatefulWidget {
  final MainModel model;

  Dashboard({this.model});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String title;
  double unitPrice;
  int quantity;

  bool isfetchingAll = true;
  bool _showChartsDashboard = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget widgetReturned = Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      widget.model.fetchAllInfos().then((bool response) {
        isfetchingAll = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "myApp",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  onPressed: () {},
                  icon: _buildNotificationButton(model),
                );
              },
            ),
          ],
        ),
        body: _showChartsDashboard
            ? _buildChartsDashboard()
            : _buildHomeDashboard(),
        drawer: DrawerBuilder(),
      ),
    );
  }

  Widget _buildNotificationButton(MainModel model) {
    return Container(
      width: 30.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            // top: 13.0,
            child: Icon(
              LineAwesomeIcons.bell,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
          ),
          model.items.length > 0
              ? Positioned(
                  // top: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 12.0,
                    width: 12.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(model.items.length.toString(),
                          style: TextStyle(
                              fontSize: 8.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildChartsDashboard() {
    return Container(
      color: Colors.red,
    );
  }

  Widget _buildHomeDashboard() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext ctxt, Widget child, MainModel model) {
        // model.fetchAll();
        return isfetchingAll
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            height: 5.0,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: buildCardItem(
                          model.items.length.toString(),
                          "Food Items",
                          LineAwesomeIcons.list_ol,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ItemsPage(
                                model: model,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: buildCardItem(
                          model.getCustomersUserInfo().length.toString(),
                          "Customers",
                          LineAwesomeIcons.group,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PersonsPage(
                                isUser: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: buildCardItem(
                          model.stores.length.toString(),
                          "Sellers",
                          LineAwesomeIcons.home,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => StoresPage(
                                model: model,
                              )
                            )
                          );
                        },
                      ),
                      GestureDetector(
                        child: buildCardItem(
                          model.getStaffUserInfo().length.toString(),
                          "Admin",
                          LineAwesomeIcons.group,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PersonsPage(
                                isUser: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          child: buildCardItem(
                            model.categories.length.toString(),
                            "Categories",
                            LineAwesomeIcons.list,
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CategoriesPage(
                                  model: model,
                                ),
                              ))),
                      GestureDetector(
                        child: buildCardItem(
                          "0",
                          "Orders",
                          LineAwesomeIcons.list_alt,
                        ),
                        onTap: () => Navigator.of(context).pushNamed("/brands"),
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }

  Widget buildCardItem(String value, String name, IconData iconData) {
    return Container(
      height: 90.0,
      width: (MediaQuery.of(context).size.width / 2.0) - 12.0,
      child: Card(
        color: Colors.white,
        elevation: 5.0,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  iconData,
                  size: 40,
                  color: Theme.of(context).accentColor,
                ),
                VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      value,
                      style: TextStyle(
                          fontSize: 18.0, color: Theme.of(context).accentColor),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
