import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/enums/auth_mode.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/user_info.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class AddPersonPage extends StatefulWidget {
  final UserInfo userInfo;
  final bool isCustomer;

  AddPersonPage({this.userInfo, this.isCustomer});

  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  String firstName;
  String lastName;
  String email;
  String mobileNumber;
  String address;
  String password;
  String type;
  File _uploadedImage;
  List<String> _personType = ["Admin", "Customer"];
  String _selectedPersonType;

  GlobalKey<FormState> _personFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  bool _obscureText = true;

  var _smallSpacing = SizedBox(height: 10.0);

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

  @override
  void initState() {
    if (widget.userInfo != null && !widget.userInfo.userType.isEmpty) {
      _selectedPersonType =
          Functions.capitalizeString(widget.userInfo.userType);
    }
    if (widget.isCustomer != null) {
      if (widget.isCustomer) {
        _selectedPersonType = "Customer";
      } else {
        _selectedPersonType = "Admin";
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget previewImage = Image(
      image: AssetImage("assets/images/lunch.jpeg"),
      fit: BoxFit.cover,
    );

    if (_uploadedImage != null) {
      previewImage = Image.file(_uploadedImage, fit: BoxFit.cover);
    } else if (widget.userInfo != null) {
      previewImage = Image.network(
          "https://cdn4.vectorstock.com/i/1000x1000/21/98/male-profile-picture-vector-1862198.jpg",
          fit: BoxFit.cover);
    }

    String appMsg = "Add Admin";
    String editMsg = "Edit Admin";

    if (widget.isCustomer) {
      appMsg = "Add Customer";
    }

    if (widget.userInfo != null && widget.isCustomer) {
      editMsg = "Edit Customer";
    }
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(false);
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldState,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text(
              widget.userInfo != null ? editMsg : appMsg,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 130.0,
                  width: 130.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: previewImage,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _personFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      widget.userInfo != null
                          ? DropdownButton(
                              hint: new Text('Select Person Type'),
                              items: _personType.map(
                                (String person) {
                                  return DropdownMenuItem<String>(
                                    child: Text(person),
                                    value: person,
                                  );
                                },
                              ).toList(),
                              value: _selectedPersonType,
                              onChanged: (String value) {
                                setState(() {
                                  _selectedPersonType = value;
                                });
                              },
                              isExpanded: true,
                            )
                          : Offstage(),
                      _selectedPersonType == null && widget.userInfo != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Select person type",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.red),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            )
                          : Offstage(),
                      _smallSpacing,
                      _buildTextFormField("First Name"),
                      _smallSpacing,
                      _buildTextFormField("Last Name"),
                      _smallSpacing,
                      _buildTextFormField("Email"),
                      _smallSpacing,
                      _buildTextFormField("Mobile Number"),
                      _smallSpacing,
                      _buildTextFormField("Address"),
                      _smallSpacing,
                      _buildTextFormField("Password"),
                      SizedBox(height: 50.0),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          String btnMsg = "Add Admin";
                          String btnEditMsg = "Update Admin";
                          String txtMessage = "Adding new admin...";
                          String txtEditMessage = "Updating admin...";

                          if (widget.isCustomer) {
                            btnMsg = "Add Customer";
                            txtMessage = "Adding new customer...";
                          }

                          if (widget.userInfo != null && widget.isCustomer) {
                            btnEditMsg = "Update Customer";
                            txtEditMessage = "Updating customer...";
                          }
                          return GestureDetector(
                            onTap: () {
                              if(_personFormKey.currentState.validate()){
                                showLoadingProgress(context, widget.userInfo != null ? txtEditMessage : txtMessage);
                              }
                              
                              _onSubmit(model.authenticate);
                            },
                            child: Button(
                              btnText:
                                  widget.userInfo != null ? btnEditMsg : btnMsg,
                              fill: true,
                              color: Theme.of(context).primaryColor,
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _onSubmitForm(Function addPerson, Function updatePerson) async {
  //   if (_personFormKey.currentState.validate() && _selectedPersonType != null) {
  //     _personFormKey.currentState.save();
  //     String personId = widget.userInfo != null ? widget.userInfo.id : "";
  //     UserInfo userInfo = UserInfo(
  //       id: personId,
  //       firstName: this.firstName,
  //       lastName: this.lastName,
  //       email: this.email,
  //       address: this.address,
  //       userType: _selectedPersonType.toLowerCase(),
  //       mobileNumber: this.mobileNumber,
  //     );
  //     if (widget.userInfo == null) {
  //       // _showLoadingProgress("Adding ${_selectedPersonType.toLowerCase()}...");
  //       var value = await addPerson(userInfo, _uploadedImage);

  //       if (value) {
  //         Navigator.of(context).pop();
  //         Navigator.of(context).pop(userInfo);
  //       } else {
  //         Navigator.of(context).pop();
  //         final snackBar = SnackBar(
  //           duration: Duration(seconds: 3),
  //           content: Text("Failed! Check internet connection."),
  //         );
  //         // Scaffold.of(context).showSnackBar(snackBar);
  //         _scaffoldState.currentState.showSnackBar(snackBar);
  //       }
  //     } else if (widget.userInfo != null) {
  //       // _showLoadingProgress(
  //       // "Updating ${_selectedPersonType.toLowerCase()}...");
  //       var value = await updatePerson(userInfo, _uploadedImage);
  //       if (value) {
  //         Navigator.of(context).pop();
  //         Navigator.of(context).pop(userInfo);
  //       } else {
  //         Navigator.of(context).pop();
  //         final snackBar = SnackBar(
  //           duration: Duration(seconds: 3),
  //           content: Text("Failed! Check internet connection."),
  //         );
  //         // Scaffold.of(context).showSnackBar(snackBar);
  //         _scaffoldState.currentState.showSnackBar(snackBar);
  //       }
  //     }
  //   }
  // }

  void _onSubmit(Function authenticate) async {
    if (_personFormKey.currentState.validate()) {
      _personFormKey.currentState.save();

      Map<String, dynamic> userInfo = {
        "mobileNumber": mobileNumber,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        'userType': _selectedPersonType.toLowerCase(),
        'address': address,
      };

      final Map<String, dynamic> response =
          await authenticate(email, password, AuthMode.SignUp, userInfo);
      if (!response['hasError']) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      } else if (response['hasError']) {
        Navigator.of(context).pop();
        _scaffoldState.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(
              "${response['message']}",
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

  Widget _buildTextFormField(String hint, {int row = 1}) {
    var initialValue;
    if (widget.userInfo != null) {
      if (hint == "First Name") {
        initialValue = Functions.titleCase(widget.userInfo.firstName);
      } else if (hint == "Last Name") {
        initialValue = Functions.titleCase(widget.userInfo.lastName);
      } else if (hint == "Email") {
        initialValue = widget.userInfo.email;
      } else if (hint == "Mobile Number") {
        initialValue = widget.userInfo.mobileNumber;
      } else if (hint == "Address") {
        initialValue = Functions.titleCase("some address");
      } else {
        initialValue = "";
      }
    }
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        suffixIcon: hint == "Password"
            ? IconButton(
                icon: Icon(_obscureText
                    ? LineAwesomeIcons.eye_slash
                    : LineAwesomeIcons.eye),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      maxLines: row,
      obscureText: hint == "Password" ? _obscureText : false,
      keyboardType: hint == "Mobile Number"
          ? TextInputType.phone
          : hint == "Email Address"
              ? TextInputType.emailAddress
              : TextInputType.text,
      validator: (String value) {
        if (hint == "Name" && value.isEmpty) {
          return "Person's name is required";
        }
        if (hint == "First Name" && value.isEmpty) {
          return "First name field is required";
        }
        if (hint == "Last Name" && value.isEmpty) {
          return "Last name field is required";
        }
        if (hint == "Email" && value.isEmpty) {
          return "Email field is required";
        }
        if (hint == "Email" &&
            !value.isEmpty &&
            !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Invalid email address";
        }
        if (hint == "Mobile Number" && value.isEmpty) {
          return "Person's mobile number is required";
        }
        if(hint == "Address" && value.isEmpty){
          return "Address field is required";
        }
        if (hint == "Password" && value.isEmpty) {
          return "Password field is required";
        }
        return null;
      },
      onSaved: (String value) {
        if (hint == "First Name") {
          firstName = value.trim().toLowerCase();
        }
        if (hint == "Email") {
          email = value.trim().toLowerCase();
        }
        if (hint == "Last Name") {
          lastName = value.trim().toLowerCase();
        }
        if (hint == "Address") {
          address = value.trim().toLowerCase();
        }
        if (hint == "Mobile Number") {
          mobileNumber = value.trim();
        }
        if(hint == "Password"){
          password = value.trim();
        }
      },
    );
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _uploadedImage = image;
      });
    });
  }
}
