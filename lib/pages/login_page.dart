import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/dashboard.dart';
import 'package:wetreats/enums/auth_mode.dart';
import 'package:wetreats/pages/singup_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/screens/main_screen.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

RegExp emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  caseSensitive: false,
  multiLine: false,
);

RegExp strongRegex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])");

class LoginPageState extends State<LoginPage> {
  bool _value1 = false;
  bool _isVisible = true;

  // login details
  String _email;
  String _password;

  void _onChanged1(bool value) => setState(() => _value1 = value);

  // Global keys
  GlobalKey<FormState> _loginFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _loginScaffoldState = GlobalKey();

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
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        key: _loginScaffoldState,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 56.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildPurpassImage(),
                  _buildPurpassText(),
                  _largeMargin,
                  _buildEmailTextFormField(),
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _buildPasswordTextFormField(),
//                  _buildKeepMeLoggedIn(),
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _mediumMargin,
                  _buildLoginButton(),
                  _mediumMargin,
//                  _buildForgottenPassword(),
//                  _mediumMargin,
                  _buildInfoRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurpassImage() {
    return Container(
      height: 90.0,
      width: 90.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        image: DecorationImage(
          image: AssetImage("assets/images/anonymous.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPurpassText() {
    return Text(
      "Sign In",
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  Widget _buildEmailTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Email",
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
        _email = email.trim();
      },
    );
  }

  Widget _buildPasswordTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Password",
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
        }
        return errorMessage;
      },
      onSaved: (String password) {
        _password = password.trim();
      },
    );
  }

  Widget _buildForgottenPassword() {
    return Container(
      width: double.infinity,
      child: Text(
        "Forgot Password?",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget _buildKeepMeLoggedIn() {
    return SwitchListTile(
      value: _value1,
      onChanged: _onChanged1,
      title: Text(
        'Keep me signed in',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Do you want a new account?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) => SignUpPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _onSubmit(model);
            if (model.isLoading) {
              showLoadingProgress(context, "Logging in...");
            }
          },
          child: Button(
            btnText: "SIGN IN",
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
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      final Map<String, dynamic> response =
          await model.authenticate(_email, _password, AuthMode.Login);

      if (!response['hasError']) {
        Navigator.of(context).pop();
        if (response['userType'] == "customer") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(
                  model: model,
                  ),
            ),
          );
        } else if (response['userType'] == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => Dashboard(
                model: model,
              ),
            ),
          );
        }
      } else if (response['hasError']) {
        Navigator.of(context).pop();
        _loginScaffoldState.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text(
            "${response['message']}",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ));
      }
    }
  }
}
