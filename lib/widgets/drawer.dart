import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/items_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';

class DrawerBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        return Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45.0),
                                 image: DecorationImage(
                                   image: AssetImage("assets/images/anonymous.jpg"),
                                   fit: BoxFit.cover,
                                 ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Admin",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              // userStore != null
                              //     ?
//                              Container(
//                                height: 40.0,
//                                width: 155.0,
//                                child: Text(
//                                  "South Africa",
//                                  style: TextStyle(
//                                    fontSize: 16.0,
//                                    fontWeight: FontWeight.normal,
//                                  ),
//                                ),
//                              ),
                              // : Offstage(),
                              SizedBox(
                                height: 5.0,
                              ),
                              // userStore != null
                              //     ?
//                              Text(
//                                "+27247656959",
//                                style: TextStyle(
//                                  fontSize: 16.0,
//                                  fontWeight: FontWeight.normal,
//                                ),
//                              ),
                              // : Offstage(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
//                    Text(
//                      "admin@project.com",
//                      style: TextStyle(
//                        fontSize: 16.0,
//                      ),
//                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      // model.fetchItems()
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ItemsPage(
                          model: model,
                        ),
                      ));
                    },
                    leading: Icon(
                      LineAwesomeIcons.list,
                      size: 25.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Add Food Item",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
//                  ListTile(
//                    onTap: () {
//                      Navigator.of(context).pop();
//                      Navigator.of(context).pushNamed("/orderspage");
//                    },
//                    leading: Icon(
//                      LineAwesomeIcons.clock_o,
//                      size: 25.0,
//                      color: Theme.of(context).primaryColor,
//                    ),
//                    title: Text(
//                      "Orders",
//                      style: TextStyle(
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                  ListTile(
//                    leading: Icon(
//                      LineAwesomeIcons.group,
//                      size: 25.0,
//                      color: Theme.of(context).primaryColor,
//                    ),
//                    title: Text(
//                      "Customers",
//                      style: TextStyle(
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     LineAwesomeIcons.money,
                  //     size: 25.0,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  //   title: Text(
                  //     "Transactions",
                  //     style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed("/add_store_page");
                    },
                    leading: Icon(
                      LineAwesomeIcons.soccer_ball_o,
                      size: 25.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Sellers",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
//                  ListTile(
//                    leading: Icon(
//                      LineAwesomeIcons.gear,
//                      size: 25.0,
//                      color: Theme.of(context).primaryColor,
//                    ),
//                    title: Text(
//                      "Settings",
//                      style: TextStyle(
//                        fontSize: 16.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/login_page');
                      model.logout();
                    },
                    leading: Icon(
                      LineAwesomeIcons.sign_out,
                      size: 25.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    //   },
    // );
  }
}
