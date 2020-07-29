import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_item_page.dart';
import 'package:wetreats/admin/pages/add_store_page.dart';
import 'package:wetreats/admin/pages/categories_page.dart';
import 'package:wetreats/admin/pages/dashboard.dart';
import 'package:wetreats/admin/pages/items_page.dart';
import 'package:wetreats/admin/pages/stores_page.dart';
import 'package:wetreats/pages/cart_page.dart';
import 'package:wetreats/pages/checkout_page.dart';
import 'package:wetreats/pages/deals_page.dart';
import 'package:wetreats/pages/favorite_page.dart';
import 'package:wetreats/pages/home_page.dart';
import 'package:wetreats/pages/login_page.dart';
import 'package:wetreats/pages/order_page.dart';
import 'package:wetreats/pages/profile_page.dart';
import 'package:wetreats/pages/singup_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/screens/main_screen.dart';



class WeTreats extends StatefulWidget {
  @override
  _WeTreatsState createState() => _WeTreatsState();
}

class _WeTreatsState extends State<WeTreats> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "",
        theme: ThemeData(
          primaryColor: Color(0xFF222831),
          accentColor: Colors.blueAccent,
          fontFamily: "SourceSerif",
        ),
        routes: {
          "/": (BuildContext context) =>
          !_isAuthenticated ? LoginPage() : _model.userInfo.userType == "customer" ?
          MainScreen(model: _model,)
          : Dashboard(model: _model,),
          "/deals_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : DealsPage(),
          "/cart_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : CartPage(),
          "/profile_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : ProfilePage(),
          "/favorite_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : FavoritePage(),
          "/home_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : HomePage(
                model: _model,
              ),
          "/login_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : LoginPage(),
          "/signup_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : SignUpPage(),
          "/order_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : OrderPage(),
          "/add_item_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : AddItemPage(),
          "/items_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : ItemsPage(),
          "/categories_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : CategoriesPage(),
          "/dashboard": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : Dashboard(model: _model,),
          "/mainscreen": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : MainScreen(
                model: _model,
              ),
          "/add_store_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : CreateStorePage(),
          "/stores_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : StoresPage(),
              "/checkout_page": (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : CheckoutPage(),
        },
      ),
    );
  }
}
