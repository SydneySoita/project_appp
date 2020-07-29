import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/empty_widget.dart';
import 'package:wetreats/widgets/food_item_card.dart';
import 'package:wetreats/widgets/item_dialog.dart';

class FavoritePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> mainScreenScaffoldKey;
  FavoritePage({this.mainScreenScaffoldKey});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.userFavoriteItems.length > 0 ? Container(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          color: Colors.grey.shade100,
          child: GridView.builder(
            itemCount: model.userFavoriteItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  model.resetItemValues(model.userFavoriteItems[index].id);
                  showSimpleCustomDialog(model.userFavoriteItems[index]);
                },
                child: FoodItemCard(
                  itemId: model.userFavoriteItems[index].id,
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.67,
            ),
          ),
        ) : EmptyWidget(iconData: LineAwesomeIcons.heartbeat, message: "You haven't favorited any item.");
      },
    );
  }

  void showSimpleCustomDialog(Item item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return ScopedModelDescendant(
          builder: (BuildContext sctx, Widget child, MainModel model) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),),),
              child: Container(
                height: 450.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ItemDialog(
                      item: item,
                      model: model,
                      mainKey: widget.mainScreenScaffoldKey,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}




//
//import 'dart:io';
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';
//import 'package:line_awesome_icons/line_awesome_icons.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:wetreats/admin/pages/categories_page.dart';
//import 'package:wetreats/admin/pages/store_list_page.dart';
//import 'package:wetreats/functions/functions.dart';
//import 'package:wetreats/models/item.dart';
//import 'package:wetreats/scoped-model/main_scoped_model.dart';
//import 'package:wetreats/services/permission_service.dart';
//import 'package:wetreats/widgets/button.dart';
//import 'package:wetreats/widgets/loading_progress_dialog.dart';
//
//class AddItemPage extends StatefulWidget {
//  final Item item;
//
//  AddItemPage({this.item});
//
//  @override
//  _AddItemPageState createState() => _AddItemPageState();
//}
//
//var dateFormat = DateFormat('y-MM-dd');
//var timeFormat = DateFormat.Hm();
//
//class _AddItemPageState extends State<AddItemPage> {
//  bool _allowLowStockNotification = false;
//  bool _editAllowStockNotification = true;
//  GlobalKey<FormState> _addItemFormKey = GlobalKey();
//  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//
//  // Item detials
//  String _itemName;
//  String _sku;
//  String _description;
//  String _categoryId;
//  String _storeId;
//  int _quantity;
//  int _lowQuantity;
//  double _price;
//  double _discount;
//  double _vat;
//  String _imageUrl;
//
//  File _uploadedImage;
//
//  var errorBorder = OutlineInputBorder(
//    borderRadius: BorderRadius.only(
//        topLeft: Radius.circular(20.0),
//        bottomRight: Radius.circular(20.0)
//    ),
//    borderSide: BorderSide(
//      color: Colors.red,
//      width: 1,
//      style: BorderStyle.solid,
//    ),
//  );
//
//  var textFormFieldOutlineBorder = OutlineInputBorder(
//    borderRadius: BorderRadius.only(
//        topLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
//    borderSide: BorderSide(
//      color: Color(0xFFD3D3D3),
//      width: 1,
//      style: BorderStyle.solid,
//    ),
//  );
//
//  @override
//  void initState() {
//    if (widget.item != null) {
//      if (widget.item.categoryId != null) {
//        _categoryId = widget.item.categoryId;
//      }
//      if (widget.item.storeId != null) {
//        _storeId = widget.item.storeId;
//      }
//      if(widget.item.lowStock == null){
//        _editAllowStockNotification = false;
//      }
//    }
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: () {
//        Navigator.of(context).pop(false);
//        return Future.value(false);
//      },
//      child: SafeArea(
//        child: GestureDetector(
//          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
//          child: ScopedModelDescendant(
//            builder: (BuildContext context, Widget child, MainModel model) {
//              return Scaffold(
//                key: _scaffoldKey,
//                backgroundColor: Colors.white,
//                resizeToAvoidBottomPadding: true,
//                appBar: AppBar(
//                  elevation: 0,
//                  backgroundColor: Colors.white,
//                  title: Text(widget.item != null ? "Update Item": "Add New Item", style: TextStyle(color: Colors.black, fontSize: 16.0),),
//                  centerTitle: true,
//                  leading: IconButton(
//                    icon: Icon(LineAwesomeIcons.close),
//                    onPressed: () {
//                      Navigator.of(context).pop(false);
//                    },
//                  ),
//                  iconTheme: IconThemeData(color: Colors.black),
//                ),
//                body: SingleChildScrollView(
//                  padding: EdgeInsets.symmetric(horizontal: 16.0),
//                  child: Form(
//                    key: _addItemFormKey,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        _buildImageContainer(),
//                        SizedBox(
//                          height: 40.0,
//                        ),
//                        _buildItemNameTextFormField(),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildDescriptionTextFormField(),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildPriceTextFormField(),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildCategoryListTile(model),
//                        _buildStoreListTile(model),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildQuantityTextFormField(),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildDiscountTextFormField(),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildVatTextFormField(),
//                        SizedBox(
//                          height: 15.0,
//                        ),
//                        _buildItemSKUTextFormField(),
//                        _buildLowStockSwitchButton(),
//                        _allowLowStockNotification ||
//                            _editAllowStockNotification && widget.item != null
//                            ? _buildLowStockQuantityTextFormField()
//                            : Offstage(),
//                        SizedBox(
//                          height: 60.0,
//                        ),
//                        _buildSubmitButton(model),
//                        SizedBox(
//                          height: 60.0,
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              );
//            },
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildImageContainer() {
//    if (widget.item != null) {
//      if (widget.item.imageUrl != null) {
//        _imageUrl = widget.item.imageUrl;
//      }
//    }
//    return GestureDetector(
//      onTap: () {
//        _showImageOptionsDialog(context);
//      },
//      child: Container(
//        margin: EdgeInsets.only(right: 10.0),
//        width: 130.0,
//        height: 130.0,
//        decoration: BoxDecoration(
//          image: _uploadedImage != null
//              ? DecorationImage(
//            image: FileImage(_uploadedImage),
//            fit: BoxFit.cover,
//          )
//              : null,
//          color: Color(0xFFEAECEE),
//          borderRadius: BorderRadius.circular(0.0),
//        ),
//        child: _imageUrl != null && _uploadedImage == null
//            ? Image.network(
//          _imageUrl,
//          loadingBuilder: (BuildContext context, Widget child,
//              ImageChunkEvent loadingProgress) {
//            if (loadingProgress == null) return child;
//            return Center(
//              child: CircularProgressIndicator(
//                value: loadingProgress.expectedTotalBytes != null
//                    ? loadingProgress.cumulativeBytesLoaded /
//                    loadingProgress.expectedTotalBytes
//                    : null,
//              ),
//            );
//          },
//          fit: BoxFit.cover,
//        )
//            : _uploadedImage != null
//            ? Image.file(
//          _uploadedImage,
//          fit: BoxFit.cover,
//        )
//            : Icon(
//          LineAwesomeIcons.image,
//          size: 50.0,
//          color: Colors.white,
//        ),
//      ),
//    );
//  }
//
//  Widget _buildItemNameTextFormField() {
//    String itemName;
//    if (widget.item != null) {
//      itemName = Functions.capitalizeString(widget.item.name);
//    }
//    return TextFormField(
//      initialValue: itemName != null ? itemName : null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        errorBorder: errorBorder,
//        focusedErrorBorder: errorBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//        hintText: "Name",
//      ),
//      keyboardType: TextInputType.text,
//      validator: (String value) {
//        String errorMessage;
//        if (value.isEmpty) {
//          errorMessage = "Item name is required";
//        }
//        return errorMessage;
//      },
//      onSaved: (String value) {
//        _itemName = value;
//      },
//    );
//  }
//
//  Widget _buildItemSKUTextFormField() {
//    String sku;
//    if (widget.item != null) {
//      if (widget.item.sku != null) {
//        sku = widget.item.sku;
//      }
//    }
//    return TextFormField(
//      initialValue: sku ?? null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        errorBorder: errorBorder,
//        focusedErrorBorder: errorBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//        hintText: "SKU",
//      ),
//      keyboardType: TextInputType.text,
//      onSaved: (String value) {
//        _sku = value;
//      },
//    );
//  }
//
//  Widget _buildQuantityTextFormField() {
//    String itemQuantity;
//    if (widget.item != null) {
//      if (widget.item.quantity != null) {
//        itemQuantity = widget.item.quantity.toString();
//      }
//    }
//    return TextFormField(
//      initialValue: itemQuantity != null ? itemQuantity : null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//        hintText: "Quantity",
//      ),
//      keyboardType: TextInputType.number,
//      onSaved: (String value) {
//        if (value.isNotEmpty) {
//          _quantity = int.parse(value);
//        }
//      },
//    );
//  }
//
//  Widget _buildLowStockQuantityTextFormField() {
//    String itemLowStock;
//    if(widget.item != null){
//      if(widget.item.lowStock != null){
//        itemLowStock = widget.item.lowStock.toString();
//      }
//    }
//    return TextFormField(
//      initialValue: itemLowStock != null ? itemLowStock : null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        errorBorder: errorBorder,
//        focusedErrorBorder: errorBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//        hintText: "Low Stock Quantity",
//      ),
//      keyboardType: TextInputType.number,
//      validator: (String value) {
//        String errorMessage;
//        if (_allowLowStockNotification && value.isEmpty) {
//          errorMessage = "Set the low stock quantity";
//        }
//        return errorMessage;
//      },
//      onSaved: (String value) {
//        if (value.isNotEmpty) {
//          _lowQuantity = int.parse(value);
//        }
//      },
//    );
//  }
//
//  Widget _buildPriceTextFormField() {
//    return TextFormField(
//      initialValue: widget.item != null ? widget.item.price.toString() : null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        errorBorder: errorBorder,
//        focusedErrorBorder: errorBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//        hintText: "Price",
//      ),
//      keyboardType: TextInputType.number,
//      validator: (String value) {
//        String errorMessage;
//        if (value.isEmpty) {
//          errorMessage = "Item price is required";
//        }
//        return errorMessage;
//      },
//      onSaved: (String value) {
//        if (value.isNotEmpty) {
//          _price = double.parse(value);
//        }
//      },
//    );
//  }
//
//  Widget _buildDiscountTextFormField() {
//    String itemDiscount;
//    if (widget.item != null) {
//      if (widget.item.discount != null) {
//        itemDiscount = widget.item.discount.toString();
//      }
//    }
//    return TextFormField(
//      initialValue: itemDiscount != null ? itemDiscount : null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//        hintText: "Discount",
//      ),
//      keyboardType: TextInputType.number,
//      onSaved: (String value) {
//        if (value.isNotEmpty) {
//          _discount = double.parse(value);
//        }
//      },
//    );
//  }
//
//  Widget _buildVatTextFormField() {
//    String vat;
//    if (widget.item != null) {
//      if (widget.item.vat != null) {
//        vat = widget.item.vat.toString();
//      }
//    }
//    return TextFormField(
//      initialValue: vat != null ? vat : null,
//      decoration: InputDecoration(
//        hintText: "Value Added Tax",
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
//      ),
//      keyboardType: TextInputType.number,
//      onSaved: (String value) {
//        if (value.isNotEmpty) {
//          _vat = double.parse(value);
//        }
//      },
//    );
//  }
//
//  Widget _buildDescriptionTextFormField() {
//    String itemDescription;
//    if (widget.item != null) {
//      itemDescription = Functions.capitalizeString(widget.item.description);
//    }
//    return TextFormField(
//      initialValue: itemDescription != null ? itemDescription : null,
//      decoration: InputDecoration(
//        enabledBorder: textFormFieldOutlineBorder,
//        focusedBorder: textFormFieldOutlineBorder,
//        errorBorder: errorBorder,
//        focusedErrorBorder: errorBorder,
//        hintText: "Description",
//      ),
//      keyboardType: TextInputType.text,
//      maxLines: 5,
//      validator: (String value) {
//        String errorMessage;
//        if (value.isEmpty) {
//          errorMessage = "Item description is required";
//        }
//        return errorMessage;
//      },
//      onSaved: (String value) {
//        _description = value;
//      },
//    );
//  }
//
//  Widget _buildCategoryListTile(MainModel model) {
//    return ListTile(
//      title: Text(
//        "Select Category",
//        style: TextStyle(
//          fontSize: 18.0,
//        ),
//      ),
//      onTap: () async {
//        final String categoryId = await Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (BuildContext context) => CategoriesPage(model: model, isAddingItem: true,),
//          ),
//        );
//        if (categoryId != null) {
//          _categoryId = categoryId;
//        }
//      },
//      trailing: Icon(LineAwesomeIcons.arrow_right),
//    );
//  }
//
//  Widget _buildStoreListTile(MainModel model) {
//    return ListTile(
//      title: Text(
//        "Select Store",
//        style: TextStyle(
//          fontSize: 18.0,
//        ),
//      ),
//      onTap: () async {
//        final String storeId = await Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (BuildContext context) => StoreListPage(),
//          ),
//        );
//        if (storeId != null) {
//          _storeId = storeId;
//        }
//      },
//      trailing: Icon(LineAwesomeIcons.arrow_right),
//    );
//  }
//
//  Widget _buildLowStockSwitchButton() {
//    return SwitchListTile(
//      value: widget.item != null
//          ? _editAllowStockNotification
//          : _allowLowStockNotification,
//      title: Text("Set low stock notification"),
//      onChanged: (bool allowLowStockNotification) {
//        setState(() {
//          if (widget.item != null) {
//            _editAllowStockNotification = allowLowStockNotification;
//          } else {
//            _allowLowStockNotification = allowLowStockNotification;
//          }
//        });
//      },
//    );
//  }
//
//  Widget _buildSubmitButton(MainModel model) {
//    String btnText = "add item";
//    if (widget.item != null) {
//      btnText = "update item";
//    }
//    return GestureDetector(
//      onTap: () {
//        _onSubmitForm(model.addItem, model.updateItem);
//        if (model.isLoading) {
//          showLoadingProgress(context,
//              widget.item != null ? "Updating item..." : "Adding item...");
//        }
//      },
//      child: Button(
//        btnText: btnText,
//        height: 50,
//        width: MediaQuery.of(context).size.width,
//        fontSize: 18.0,
//        // bold: true,
//        color: Theme.of(context).primaryColor,
//        fill: true,
//      ),
//    );
//  }
//
//  void _onSubmitForm(Function addItem, Function updateItem) async {
//    String currentDate = dateFormat.format(DateTime.now());
//    String currentTime = timeFormat.format(DateTime.now());
//    if (_addItemFormKey.currentState.validate()) {
//      _addItemFormKey.currentState.save();
//
//      // Dismiss the keyboard
//      FocusScope.of(context).requestFocus(new FocusNode());
//
//      if (widget.item == null) {
//        // the item data to send to the database
//        Map<String, dynamic> itemData = {
//          'name': _itemName,
//          'description': _description,
//          'categoryId': _categoryId,
//          'storeId': _storeId,
//          'quantity': _quantity,
//          'price': _price,
//          'lowStock': _lowQuantity,
//          'discount': _discount != null ? _discount : 0.0,
//          'vat': _vat != null ? _vat : 0.0,
//          'sku': _sku,
//          'createdTime': currentTime,
//          'createdDate': currentDate,
//        };
//
//        final bool response = await addItem(itemData, _uploadedImage);
//        if (response) {
//          Navigator.of(context).pop();
//          Navigator.of(context).pop(true);
//        } else {
//          Navigator.of(context).pop();
//          _scaffoldKey.currentState.showSnackBar(
//            SnackBar(
//              backgroundColor: Colors.redAccent,
//              duration: Duration(seconds: 2),
//              content: Text(
//                "Failed to add product",
//                style: TextStyle(color: Colors.white, fontSize: 16.0),
//              ),
//            ),
//          );
//        }
//      } else if (widget.item != null) {
//        Map<String, dynamic> itemData = {
//          'name': _itemName,
//          'description': _description,
//          'categoryId': _categoryId,
//          'quantity': _quantity,
//          'price': _price,
//          'lowStock': _lowQuantity,
//          'storeId': _storeId,
//          'discount': _discount != null ? _discount : 0.0,
//          'imageUrl': widget.item.imageUrl,
//          'imagePath': widget.item.imagePath,
//          'vat': _vat != null ? _vat : 0.0,
//          'sku': _sku,
//          'createdTime': widget.item.createdTime,
//          'createdDate': widget.item.createdDate,
//          'updatedTime': currentTime,
//          'updatedDate': currentDate,
//        };
//
//        final response =
//        await updateItem(itemData, widget.item.id, _uploadedImage);
//
//        if (response) {
//          Navigator.of(context).pop();
//          Navigator.of(context).pop(true);
//        } else {
//          Navigator.of(context).pop();
//          _scaffoldKey.currentState.showSnackBar(
//            SnackBar(
//              backgroundColor: Colors.redAccent,
//              duration: Duration(seconds: 2),
//              content: Text(
//                "Failed to update product",
//                style: TextStyle(color: Colors.white, fontSize: 16.0),
//              ),
//            ),
//          );
//        }
//      }
//    }
//  }
//
//  void _showImageOptionsDialog(BuildContext ctx) {
//    Dialog _imageOptionsDialog = Dialog(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(10.0),
//      ),
//      child: Container(
//        height: _uploadedImage != null ? 225.0 : 180.0,
//        // width: ,
//        color: Colors.white,
//        child: Column(
//          children: <Widget>[
//            ListTile(
//              leading: Icon(LineAwesomeIcons.camera),
//              title: Text(
//                "Take a photo",
//                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//              ),
//              onTap: () async {
//                print("Printing from take photo");
//                Navigator.of(context).pop();
//                final bool cameraStatus =
//                await PermissionsService().hasCameraPermission();
//                if (!cameraStatus) {
//                  bool granted =
//                  await PermissionsService().requestCameraPermission(
//                    onPermissionDenied: () {
//                      print("Permission has been denied");
//                    },
//                  );
//                  if (granted) {
//                    _getImage(context, ImageSource.camera);
//                  }
//                } else {
//                  _getImage(context, ImageSource.camera);
//                }
//              },
//            ),
//            ListTile(
//              leading: Icon(LineAwesomeIcons.image),
//              title: Text(
//                "Choose from gallery",
//                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//              ),
//              onTap: () async {
//                Navigator.of(context).pop();
//                final bool storageStatus =
//                await PermissionsService().hasStoragePermission();
//                if (!storageStatus) {
//                  bool granted =
//                  await PermissionsService().requestStoragePermission(
//                    onPermissionDenied: () {
//                      print("Permission has been denied");
//                    },
//                  );
//                  if (granted) {
//                    _getImage(context, ImageSource.gallery);
//                  }
//                } else {
//                  _getImage(context, ImageSource.gallery);
//                }
//              },
//            ),
//            _uploadedImage != null
//                ? ListTile(
//              leading: Icon(LineAwesomeIcons.trash),
//              title: Text(
//                "Remove Image",
//                style: TextStyle(
//                    fontSize: 16.0, fontWeight: FontWeight.bold),
//              ),
//              onTap: () {
//                Navigator.of(context).pop();
//                setState(
//                      () {
//                    _uploadedImage = null;
//                  },
//                );
//              },
//            )
//                : Offstage(),
//            ListTile(
//              leading: Icon(LineAwesomeIcons.remove),
//              title: Text(
//                "Cancel",
//                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//              ),
//              onTap: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//
//    showDialog(
//      context: ctx,
//      barrierDismissible: false,
//      builder: (BuildContext context) => _imageOptionsDialog,
//    );
//  }
//
//  void _getImage(BuildContext context, ImageSource source) {
//    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
//      setState(() {
//        _uploadedImage = image;
//      });
//    });
//  }
//}





