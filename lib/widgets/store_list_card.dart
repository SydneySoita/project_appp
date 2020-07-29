import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/store.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';

class StoreListCard extends StatelessWidget {
  final String storeId;

  StoreListCard({this.storeId});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        print("the store id in the list page: $storeId");
        Store store = model.getStoreById(storeId);
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5, color: Colors.black12, offset: Offset(0, 5.0))
            ],
          ),
          child: Text(
            "${store.name}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        );
      },
    );
  }
}
