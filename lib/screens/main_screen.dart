import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_item_page.dart';
import 'package:wetreats/admin/pages/add_person_page.dart';
import 'package:wetreats/admin/pages/categories_page.dart';
import 'package:wetreats/admin/pages/dashboard.dart';
import 'package:wetreats/admin/pages/item_detials_page.dart';
import 'package:wetreats/admin/pages/items_page.dart';
import 'package:wetreats/admin/pages/persons_page.dart';
import 'package:wetreats/admin/pages/store_list_page.dart';
import 'package:wetreats/pages/cart_page.dart';
import 'package:wetreats/pages/deals_page.dart';
import 'package:wetreats/pages/home_page.dart';
import 'package:wetreats/pages/profile_page.dart';
import 'package:wetreats/pages/favorite_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';

class MainScreen extends StatefulWidget {
  final MainModel model;

  MainScreen({this.model});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> mainscreenScaffoldKey = GlobalKey();
  int currentTab = 0;

  // Pages declarations
  HomePage _homePage;
  DealsPage _dealsPage;
  CartPage _orderPage;
  ProfilePage _profilePage;
  FavoritePage _favoritePage;


  AddItemPage _addItemPage;
//  AddPersonPage _addPersonPage;
//  CategoriesPage _categoriesPage;
//  Dashboard _dashboard;
//  ItemDetailsPage _itemDetailsPage;
//  ItemsPage _itemsPage;
//  PersonsPage _personsPage;
//  StoreListPage _storeListPage;
//  Stores



  List<Widget> pages;

  Widget currentPage;

  @override
  void initState() {
    _homePage = HomePage(model: widget.model);
    _dealsPage = DealsPage(
      mainScreenScaffoldKey: mainscreenScaffoldKey,
    );
    _orderPage = CartPage(
      showAppBar: false,
    );
    _profilePage = ProfilePage();
    _favoritePage = FavoritePage(
      mainScreenScaffoldKey: mainscreenScaffoldKey,
    );

    pages = [
      _homePage,
      _orderPage,
      _profilePage
    ];
    currentPage = _homePage;
    if (widget.model != null) {
      widget.model.fetchAllInfos();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            key: mainscreenScaffoldKey,
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                currentTab == 0
                    ? "myApp"
//                    : currentTab == 1
//                        ? "Discount Deals"
//                        : currentTab == 2
//                            ? "Favorites"
                            : currentTab == 1
                                ? "Items In Your Cart"
                                : "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              centerTitle: true,
              actions: <Widget>[
                currentTab != 4
                    ? IconButton(
                        icon: _buildShoppingCartButton(model),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext ctx) => CartPage(
                                showAppBar: true,
                              ),
                            ),
                          );
                        },
                      )
                    : Offstage(),
                currentTab != 4
                    ? IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext ctx) => CartPage(
                                showAppBar: true,
                              ),
                            ),
                          );
                        },
                      )
                    : Offstage(),
                currentTab != 4
                    ? IconButton(
                        icon: Icon(LineAwesomeIcons.sign_out),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/login_page');
                          model.logout();
                        },
                      )
                    : Offstage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              // showSelectedLabels: false,
              // showUnselectedLabels: false,
              currentIndex: currentTab,
              onTap: (index) {
                setState(() {
                  currentTab = index;
                  currentPage = pages[index];
                });
              },
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    LineAwesomeIcons.home,
                  ),
                  title: Text("Home"),
                ),
//                BottomNavigationBarItem(
//                  icon: Icon(
//                    LineAwesomeIcons.gift,
//                  ),
//                  title: Text("Deals"),
//                ),
//                BottomNavigationBarItem(
//                  icon: Icon(
//                    LineAwesomeIcons.heart,
//                  ),
//                  title: Text("Favorite"),
//                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    LineAwesomeIcons.list_alt,
                  ),
                  title: Text("Orders"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    LineAwesomeIcons.male,
                  ),
                  title: Text("Profile"),
                ),
              ],
            ),
            body: currentPage,
          );
        },
      ),
    );
  }

  Widget _buildShoppingCartButton(MainModel model) {
    return Container(
      width: 30.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Icon(
              LineAwesomeIcons.shopping_cart,
              color: Colors.black,
              size: 30.0,
            ),
          ),
          1 > 0
              ? Positioned(
                  left: 15.0,
                  child: Container(
                    height: 12.0,
                    width: 12.0,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        model.orderItems.length.toString(),
                        style: TextStyle(
                          fontSize: 8.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : Offstage(),
        ],
      ),
    );
  }
}
