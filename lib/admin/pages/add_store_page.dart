import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/store.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/services/permission_service.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class CreateStorePage extends StatefulWidget {
  final Store store;

  CreateStorePage({this.store});
  @override
  CreateStorePageState createState() => CreateStorePageState();
}

RegExp emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  caseSensitive: false,
  multiLine: false,
);

RegExp strongRegex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])");

RegExp nameRegExp =
    RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$");

RegExp phoneRegExp =
    RegExp(r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$");

class CreateStorePageState extends State<CreateStorePage> {
  final fontStyle = TextStyle(fontSize: 16.0);

  var errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
    borderSide: BorderSide(
      color: Colors.red,
      width: 1,
      style: BorderStyle.solid,
    ),
  );

  var textFormFieldOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
    borderSide: BorderSide(
      color: Color(0xFFD3D3D3),
      width: 1,
      style: BorderStyle.solid,
    ),
  );

  var _mediumMargin = SizedBox(height: 15.0);
  var _largeMargin = SizedBox(height: 50.0);

  File _uploadedImage;
  // String _selectStoreType = "Select store type";

  // Global keys
  GlobalKey<FormState> _createStoreFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _createStoreScaffoldKey = GlobalKey();

  // Details variables
  String _storeName;
  String _storeEmail;
  String _storeContact;
  String _storeType;
  String _address;
  String _description;
  bool _storeTypeSelected;

  @override
  void initState() {
    if (widget.store != null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(false);
            return Future.value(false);
          },
          child: Scaffold(
            key: _createStoreScaffoldKey,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                widget.store != null ? "Edit Seller Info" : "Add Store Info",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
            ),
            resizeToAvoidBottomPadding: true,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Form(
                key: _createStoreFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildImageContainer(),
                    _mediumMargin,
                    _buildStoreNameTextFormField(),
                    _mediumMargin,
                    _buildStoreEmailTextFormField(),
                    _mediumMargin,
                    _buildStorePhoneTextFormField(),
                    _mediumMargin,
                    _buildDescriptionTextFormField(),
                    _mediumMargin,
                    _buildSelectStoreType(context),
                    _mediumMargin,
                    _buildLocationTextFormField(),
                    _largeMargin,
                    _buildCreateStoreButton(),
                    _largeMargin
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreNameTextFormField() {
    String initialValue;
    if (widget.store != null) {
      initialValue = widget.store.name;
    }
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Name of store",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.delicious),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String name) {
        String errorMessage;
        if (name.isEmpty) {
          errorMessage = "Name field is required";
        } else if (!nameRegExp.hasMatch(name)) {
          errorMessage = "Name must not contain symbol or number";
        }
        return errorMessage;
      },
      onSaved: (String name) {
        _storeName = name.trim();
      },
    );
  }

  Widget _buildStoreEmailTextFormField() {
    String initialValue;
    if (widget.store != null) {
      initialValue = widget.store.email;
    }
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Store Email",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.envelope),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String email) {
        String errorMessage;
        if (email.isEmpty) {
          errorMessage = "Email field is required";
        }
//        else if (!emailRegExp.hasMatch(email)) {
//          errorMessage = "Email is invalid";
//        }
        return errorMessage;
      },
      onSaved: (String email) {
        _storeEmail = email.trim();
      },
    );
  }

  Widget _buildStorePhoneTextFormField() {
    String initialValue;
    if (widget.store != null) {
      initialValue = widget.store.phone;
    }

    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Store Contact",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.phone),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String mobileWallet) {
        String errorMessage;
        if (mobileWallet.isEmpty) {
          errorMessage = "Store contact field is required";
        } else if (!phoneRegExp.hasMatch(mobileWallet)) {
          errorMessage = "Invalid contact number";
        }
        return errorMessage;
      },
      onSaved: (String mobileWallet) {
        _storeContact = mobileWallet.trim();
      },
    );
  }

  Widget _buildSelectStoreType(BuildContext ctx) {
    if (widget.store != null) {
      _storeType = widget.store.storeType;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: _showSelectStoreTypeDailog,
          child: Container(
            width: MediaQuery.of(ctx).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: 50.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  LineAwesomeIcons.shopping_cart,
                  color: Colors.black54,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                ),
                Expanded(
                  child: Text(
                    _storeType != null ? _storeType : "Select store type",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Icon(
                  LineAwesomeIcons.caret_down,
                  color: Colors.black54,
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              border: Border.all(
                color: _storeTypeSelected != null && !_storeTypeSelected
                    ? Colors.red
                    : Color(0xFFD3D3D3),
              ),
            ),
          ),
        ),
        _storeTypeSelected != null && !_storeTypeSelected
            ? SizedBox(
                height: 8.0,
              )
            : Offstage(),
        _storeTypeSelected != null && !_storeTypeSelected
            ? Text(
                "Select the store type",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.red,
                ),
              )
            : Offstage(),
      ],
    );
  }

  Widget _buildLocationTextFormField() {
    String initialValue;
    if (widget.store != null) {
      initialValue = widget.store.address;
    }
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Store Address",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.map),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String value) {
        String errorMessage;
        if (value.isEmpty) {
          errorMessage = "Address field is required";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        _address = value.trim();
      },
    );
  }

  Widget _buildImageContainer() {
    return GestureDetector(
      onTap: () {
        _showImageOptionsDialog(context);
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 130.0,
            height: 130.0,
            decoration: BoxDecoration(
              image: _uploadedImage != null
                  ? DecorationImage(
                      image: FileImage(_uploadedImage),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: Color(0xFFEAECEE),
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: _uploadedImage != null
                ? null
                : Icon(
                    LineAwesomeIcons.image,
                    color: Colors.white,
                    size: 60.0,
                  ),
          ),
          SizedBox(height: 5.0),
          Text(
            "Store Image",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateStoreButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (_storeType == null) {
                _storeTypeSelected = false;
              } else if (_storeType != null) {
                _storeTypeSelected = true;
              }
            });
            _onSubmit(model);
            if (model.isStoreLoading) {
              showLoadingProgress(
                  context,
                  widget.store != null
                      ? "Updating store..."
                      : "Creating store...");
            }
          },
          child: Button(
            btnText: widget.store != null ? "UPDATE STORE" : "CREATE STORE",
            color: Theme.of(context).primaryColor,
            fill: true,
            bold: true,
            fontSize: 20.0,
            height: 50.0,
            letterSpacing: 1,
            width: MediaQuery.of(context).size.width,
          ),
        );
      },
    );
  }

  void _onSubmit(MainModel model) async {
    if (_createStoreFormKey.currentState.validate() && _storeTypeSelected) {
      _createStoreFormKey.currentState.save();

      if (widget.store == null) {
        Map<String, dynamic> storeData = {
          "name": _storeName,
          "email": _storeEmail,
          "phone": _storeContact,
          "storeType": _storeType,
          "address": _address,
          "description": _description,
        };
        final bool response =
            await model.addStoreWithUserId(storeData, _uploadedImage);
        if (response) {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
        } else if (!response) {
          Navigator.of(context).pop();
          _createStoreScaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("Failed to create store",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else if (widget.store != null) {
        
        Map<String, dynamic> storeData = {
          "name": _storeName,
          "email": _storeEmail,
          "phone": _storeContact,
          "imageUrl": widget.store.imageUrl,
          "imagePath": widget.store.imagePath,
          "storeType": _storeType,
          "address": _address,
          "description": _description,
        };

        final bool response =
            await model.updateStore(storeData, widget.store.id, _uploadedImage);
        if (response) {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
        } else if (!response) {
          Navigator.of(context).pop();
          _createStoreScaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("Failed to update store",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  Widget _buildDescriptionTextFormField() {
    String initialValue;
    if (widget.store != null) {
      initialValue = widget.store.description;
    }
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        hintText: "Store Description",
      ),
      keyboardType: TextInputType.text,
      maxLines: 5,
      validator: (String value) {
        String errorMessage;
        if (value.isEmpty) {
          errorMessage = "Store description is required";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  void _showImageOptionsDialog(BuildContext ctx) {
    Dialog _imageOptionsDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 170.0,
        // width: ,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(LineAwesomeIcons.camera),
              title: Text(
                "Take a photo",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final bool cameraStatus =
                    await PermissionsService().hasCameraPermission();
                if (!cameraStatus) {
                  bool granted =
                      await PermissionsService().requestCameraPermission(
                    onPermissionDenied: () {
                      print("Permission has been denied");
                    },
                  );
                  if (granted) {
                    _getImage(context, ImageSource.camera);
                  }
                } else {
                  _getImage(context, ImageSource.camera);
                }
              },
            ),
            ListTile(
              leading: Icon(LineAwesomeIcons.image),
              title: Text(
                "Choose from gallery",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final bool storageStatus =
                    await PermissionsService().hasStoragePermission();
                if (!storageStatus) {
                  bool granted =
                      await PermissionsService().requestStoragePermission(
                    onPermissionDenied: () {
                      print("Permission has been denied");
                    },
                  );
                  if (granted) {
                    _getImage(context, ImageSource.gallery);
                  }
                } else {
                  _getImage(context, ImageSource.gallery);
                }
              },
            ),
            _uploadedImage == null
                ? ListTile(
                    leading: Icon(LineAwesomeIcons.remove),
                    title: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                : ListTile(
                    leading: Icon(LineAwesomeIcons.trash),
                    title: Text(
                      "Remove Image",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _uploadedImage = null;
                      });
                    },
                  ),
          ],
        ),
      ),
    );

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) => _imageOptionsDialog,
    );
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _uploadedImage = image;
      });
    });
  }

  void _showSelectStoreTypeDailog() {
    Dialog _selectStoreTypeDialog = Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        height: 130.0,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _storeType = "Restaurant";
                });
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 20.0,
                child: Text(
                  "Restaurant",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _storeType = "Individual";
                });
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 20.0,
                child: Text(
                  "Individual",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _storeType = "Wholesale";
                });
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 20.0,
                child: Text(
                  "Wholesale",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        child: _selectStoreTypeDialog);
  }
}
