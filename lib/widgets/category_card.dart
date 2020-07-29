import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
// import 'package:purpass/src/functions/helper_functions.dart';
// import 'package:purpass/src/models/category.dart';
// import 'package:purpass/src/scoped-models/main.dart';
// import 'package:purpass/src/widgets/loading_dialog.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/category.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final MainModel mainModel;
  CategoryCard({this.category, this.mainModel});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${Functions.titleCase(category.name)}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          GestureDetector(
            onTap: () async {
              showLoadingProgress(context, "Deleting category...");
              final bool response = await mainModel.deleteCategory(category.id);
              if (response) {
                Navigator.of(context).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: Duration(seconds: 2),
                    content: Text("Category deleted successfully"),
                  ),
                );
              } else if (!response) {
                Navigator.of(context).pop();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: Duration(seconds: 2),
                    content: Text("Failed to delete category"),
                  ),
                );
              }
            },
            child: Icon(
              LineAwesomeIcons.trash,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
