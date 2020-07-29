import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/category_card.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class CategoriesPage extends StatefulWidget {
  final MainModel model;
  final bool isAddingItem;

  CategoriesPage({this.model, this.isAddingItem});
  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  String name;
  bool _isLoading = true;

  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();

  var errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: BorderSide(
      color: Colors.red,
      width: 1,
      style: BorderStyle.solid,
    ),
  );

  var textFormFieldOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: BorderSide(
      color: Color(0xFFD3D3D3),
      width: 1,
      style: BorderStyle.solid,
    ),
  );

  @override
  void initState() {
    if (widget.model != null) {
      widget.model.fetchCategories().then((_) {
        _isLoading = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldStateKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            "Categories",
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
        body: ScopedModelDescendant(
          builder: (BuildContext ctx, Widget child, MainModel model) {
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: model.categorySize + 1.compareTo(0),
              itemBuilder: (BuildContext listBuilderContext, int index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      _showAddCategoryDialog(context);
                    },
                    child: Button(
                      btnText: "ADD NEW CATEGORY",
                      height: 56.0,
                      color: Theme.of(context).primaryColor,
                      bold: true,
                      letterSpacing: 1,
                      fontSize: 18,
                      fill: true,
                    ),
                  );
                }
                return _isLoading
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (widget.isAddingItem) {
                            final String categoryId =
                                model.categories[index - 1].id;
                            Navigator.of(context).pop(categoryId);
                          }
                        },
                        child: CategoryCard(
                          category: model.categories[index - 1],
                          mainModel: model,
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryNameTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "Name",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        String errorMessage;
        if (value.isEmpty) {
          errorMessage = "Item name is required";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        name = value;
      },
    );
  }

  Widget _buildCategoryButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Button(
            btnText: "CANCEL",
            color: Colors.redAccent,
            height: 35.0,
            width: 80.0,
            bold: true,
            fill: true,
          ),
        ),
        ScopedModelDescendant(
          builder: (BuildContext ctx, Widget child, MainModel model) {
            return GestureDetector(
              onTap: () {
                _onSubmit(model.addCategory, context);
                Navigator.of(context).pop();
                if (model.isCatLoading) {
                  showLoadingProgress(context, "Adding category...");
                }
                // print("Something is really happening");
              },
              child: Button(
                btnText: "ADD",
                color: Theme.of(context).primaryColor,
                height: 35.0,
                width: 80.0,
                bold: true,
                fill: true,
              ),
            );
          },
        ),
      ],
    );
  }

  void _onSubmit(Function addCategory, BuildContext ctx) async {
    if (_categoryFormKey.currentState.validate()) {
      _categoryFormKey.currentState.save();

      Map<String, dynamic> categoryData = {
        'name': name,
      };

      final bool response = await addCategory(categoryData);
      if (response) {
        Navigator.of(ctx).pop();
        _scaffoldStateKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(ctx).primaryColor,
            duration: Duration(seconds: 2),
            content: Text(
              "$name is added sucessfully",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        );
      } else if (!response) {
        Navigator.of(ctx).pop();
        _scaffoldStateKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text(
              "Failed to add category",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
  }

  void _showAddCategoryDialog(BuildContext ctx) {
    Dialog _addCategoryDialog = Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        height: 180,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Enter category name",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Form(
              key: _categoryFormKey,
              child: _buildCategoryNameTextFormField(),
            ),
            _buildCategoryButtons(ctx)
          ],
        ),
      ),
    );

    showDialog(
        context: ctx, barrierDismissible: false, child: _addCategoryDialog);
  }
}
