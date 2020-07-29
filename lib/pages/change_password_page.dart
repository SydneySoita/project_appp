import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

RegExp strongRegex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])");

class ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isOldVisible = true;
  bool _isVisible = true;

  String _confirmPassword;
  String _newPassword;

  // Global keys
  GlobalKey<FormState> _changePasswordFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _changePasswordScaffoldKey = GlobalKey();

  var errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      bottomRight: Radius.circular(20.0),
    ),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _changePasswordScaffoldKey,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            "Change Password",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              LineAwesomeIcons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 56.0),
            child: Form(
              key: _changePasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildNewPasswordTextFormField(),
                  _mediumMargin,
                  _buildConfirmPasswordTextFormField(),
                  SizedBox(
                    height: 100,
                  ),
                  _buildChangePasswordButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewPasswordTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "New Password",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.lock),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isOldVisible = !_isOldVisible;
            });
          },
          child: Icon(_isOldVisible
              ? LineAwesomeIcons.eye_slash
              : LineAwesomeIcons.eye),
        ),
        contentPadding: EdgeInsets.all(0.0),
      ),
      obscureText: _isOldVisible,
      validator: (String password) {
        String errorMessage;
        if (password.isEmpty) {
          errorMessage = "Password field is required";
        } else if (!strongRegex.hasMatch(password)) {
          errorMessage =
              "Password must contain lowercase, uppercase, and a number";
        } else if (password.length < 8) {
          errorMessage = "Password should be more than 8 characters";
        }
        return errorMessage;
      },
      onSaved: (String password) {
        _newPassword = password.trim();
      },
    );
  }

  Widget _buildConfirmPasswordTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Confirm Password",
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(LineAwesomeIcons.lock),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: Icon(
              _isVisible ? LineAwesomeIcons.eye_slash : LineAwesomeIcons.eye),
        ),
        contentPadding: EdgeInsets.all(0.0),
      ),
      obscureText: _isVisible,
      validator: (String password) {
        String errorMessage;
        if (password.isEmpty) {
          errorMessage = "Password field is required";
        } else if (!strongRegex.hasMatch(password)) {
          errorMessage =
              "Password must contain lowercase, uppercase, and a number";
        } else if (password.length < 8) {
          errorMessage = "Passowrd should be more than 8 characters";
        } else if (_newPassword != password) {
          errorMessage = "Passwords do not match";
        }
        return errorMessage;
      },
      onSaved: (String password) {
        _confirmPassword = password.trim();
      },
    );
  }

  Widget _buildChangePasswordButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _onSubmit(model.changePassword);
            if (model.isLoading) {
              showLoadingProgress(context, "Updating password...");
            }
          },
          child: Button(
            btnText: "CHANGE PASSWORD",
            color: Theme.of(context).primaryColor,
            fill: true,
            fontSize: 20.0,
            height: 50.0,
            letterSpacing: 1,
            width: MediaQuery.of(context).size.width,
          ),
        );
      },
    );
  }

  void _onSubmit(Function changePassword) async {
    if (_changePasswordFormKey.currentState.validate()) {
      _changePasswordFormKey.currentState.save();

      if (_newPassword == _confirmPassword) {
        final bool response = await changePassword(_newPassword);
        if (response) {
          Navigator.of(context).pop();
          _changePasswordScaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
              content: Text("Password has been changed successfully"),
            ),
          );
        } else {
          Navigator.of(context).pop();
          _changePasswordScaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 2),
              content: Text("Failed to change password"),
            ),
          );
        }
      }
    }
  }
}
