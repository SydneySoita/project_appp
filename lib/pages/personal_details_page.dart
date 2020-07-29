import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/user.dart';
import 'package:wetreats/models/user_info.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class PersonalDetailsPage extends StatefulWidget {
  PersonalDetailsPageState createState() => PersonalDetailsPageState();
}

RegExp emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  caseSensitive: false,
  multiLine: false,
);

RegExp nameRegExp =
    RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$");

RegExp phoneRegExp =
    RegExp(r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$");

class PersonalDetailsPageState extends State<PersonalDetailsPage> {
  // Form details
  String _email;
  String _firstName;
  String _lastName;
  String _mobileNumber;

  // Global keys
  GlobalKey<FormState> _personalDetailsFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _personalDetailsScaffoldKey = GlobalKey();

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
  var _largeMargin = SizedBox(height: 40.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          final User user = model.user;
          final UserInfo userInfo = model.getUserDetails(user.id);

          return Scaffold(
            key: _personalDetailsScaffoldKey,
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text(
                "Personal Details",
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
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 56.0),
                child: Form(
                  key: _personalDetailsFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Update your pesonal details",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      _largeMargin,
                      _buildFirstNameTextFormField(userInfo.firstName),
                      _mediumMargin,
                      _buildLastNameTextFormField(userInfo.lastName),
                      _mediumMargin,
                      _buildEmailTextFormField(userInfo.email),
                      _mediumMargin,
                      _buildMobileNumberTextFormField(userInfo.mobileNumber),
                      SizedBox(
                        height: 80.0,
                      ),
                      _buildUpdateProfile(userInfo.id),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFirstNameTextFormField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "First name",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.male),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String name) {
        String errorMessage;
        if (name.isEmpty) {
          errorMessage = "First name field is required";
        } else if (!nameRegExp.hasMatch(name)) {
          errorMessage = "Name must not contain symbol or number";
        }
        return errorMessage;
      },
      onSaved: (String name) {
        _firstName = name.trim();
      },
    );
  }

  Widget _buildLastNameTextFormField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Last name",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.male),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String name) {
        String errorMessage;
        if (name.isEmpty) {
          errorMessage = "Last name field is required";
        } else if (!nameRegExp.hasMatch(name)) {
          errorMessage = "Name must not contain symbol or number";
        }
        return errorMessage;
      },
      onSaved: (String name) {
        _lastName = name.trim();
      },
    );
  }

  Widget _buildEmailTextFormField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Email",
        enabledBorder: textFormFieldOutlineBorder,
        focusedErrorBorder: errorBorder,
        errorBorder: errorBorder,
        focusedBorder: textFormFieldOutlineBorder,
        prefixIcon: Icon(LineAwesomeIcons.envelope),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String email) {
        String errorMessage;
        if (email.isEmpty) {
          errorMessage = "Email field is required";
        } else if (!emailRegExp.hasMatch(email)) {
          errorMessage = "Email is invalid";
        }
        return errorMessage;
      },
      onSaved: (String email) {
        _email = email.trim();
      },
    );
  }

  Widget _buildMobileNumberTextFormField(String initialValue) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: "Mobile Number",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.phone),
        contentPadding: EdgeInsets.all(0.0),
      ),
      validator: (String mobileNumber) {
        String errorMessage;
        if (mobileNumber.isEmpty) {
          errorMessage = "Mobile number field is required";
        } else if (!phoneRegExp.hasMatch(mobileNumber)) {
          errorMessage = "Invalid mobile number";
        }
        return errorMessage;
      },
      onSaved: (String mobileNumber) {
        _mobileNumber = mobileNumber.trim();
      },
    );
  }

  Widget _buildUpdateProfile(String id) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _onSubmit(model.updatePersonalDetails, id);
            if (model.isLoading) {
              showLoadingProgress(context, "Updating details...");
            }
          },
          child: Button(
            btnText: "UPDATE DETAILS",
            color: Theme.of(context).primaryColor,
            fill: true,
            bold: false,
            fontSize: 20.0,
            height: 50.0,
            letterSpacing: 1,
            width: MediaQuery.of(context).size.width,
          ),
        );
      },
    );
  }

  void _onSubmit(Function updatePersonalDetails, String id) async {
    if (_personalDetailsFormKey.currentState.validate()) {
      _personalDetailsFormKey.currentState.save();

      Map<String, dynamic> personalData = {
        "mobileNumber": _mobileNumber,
        "firstName": _firstName,
        "lastName": _lastName,
        "email": _email,
      };

      final bool response = await updatePersonalDetails(personalData, id);
      if (response) {
        Navigator.of(context).pop();
        // Navigator.of(context).pushReplacementNamed("/mainscreen");
        _personalDetailsScaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(
              "Details updated successfully",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else if (!response) {
        Navigator.of(context).pop();
        _personalDetailsScaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            content: Text(
              "Failed to update details",
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
}
