import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/store_list_card.dart';

class StoreListPage extends StatefulWidget {
  @override
  StoreListPageState createState() => StoreListPageState();
}

class StoreListPageState extends State<StoreListPage> {
  String name;
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldStateKey,
            // backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "Select Store",
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(LineAwesomeIcons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: model.stores.length,
              itemBuilder: (BuildContext listBuilderContext, int index) {
                return GestureDetector(
                  onTap: () async {
                    final String storeId = model.stores[index].id;
                    Navigator.of(context).pop(storeId);
                  },
                  child: StoreListCard(
                    storeId: model.stores[index].id,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
