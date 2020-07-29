import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/enums/auth_mode.dart';
import 'package:wetreats/pages/login_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class SignUpPage extends StatefulWidget {
  SignUpPageState createState() => SignUpPageState();
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

class SignUpPageState extends State<SignUpPage> {
  bool _value1 = false;
  bool _isVisible = true;

  // Form details
  String _email;
  String _firstName;
  String _lastName;
  String _mobileNumber;
  String _password;

  // Global keys
  GlobalKey<FormState> _signupFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _signUpScaffoldKey = GlobalKey();

  var errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0)
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
  var _largeMargin = SizedBox(height: 40.0);

  // methods
  void _onChanged1(bool value) => setState(() => _value1 = value);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _signUpScaffoldKey,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 56.0),
            child: Form(
              key: _signupFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildPurpassImage(),
                  _buildPurpassText(),
                  _largeMargin,
                  _buildFirstNameTextFormField(),
                  _mediumMargin,
                  _buildLastNameTextFormField(),
                  _mediumMargin,
                  _buildEmailTextFormField(),
                  _mediumMargin,
                  _buildMobileNumberTextFormField(),
                  _mediumMargin,
                  _buildPasswordTextFormField(),
                  _buildUserAgreementSwitchTile(),
                  _mediumMargin,
                  _buildSignUpButton(),
                  _mediumMargin,
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
      "Sign Up",
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildFirstNameTextFormField() {
    return TextFormField(
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

    Widget _buildLastNameTextFormField() {
    return TextFormField(
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


  Widget _buildEmailTextFormField() {
    return TextFormField(
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

  Widget _buildMobileNumberTextFormField() {
    return TextFormField(
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
          errorMessage = "Password should be more than 8 characters";
        }
        return errorMessage;
      },
      onSaved: (String password) {
        _password = password.trim();
      },
    );
  }

  Widget _buildUserAgreementSwitchTile() {
    return SwitchListTile(
      contentPadding: EdgeInsets.all(0.0),
      value: _value1,
      onChanged: _onChanged1,
      title: Text(
        'User Agreement and Privacy Policy',
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
          "Already have an account?",
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ));
          },
          child: Text(
            "Sign In",
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

  Widget _buildSignUpButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _onSubmit(model.authenticate);
            if (model.isLoading) {
              showLoadingProgress(context, "Signing up...");
            }
          },
          child: Button(
            btnText: "SIGN UP",
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

  void _onSubmit(Function authenticate) async {
    if (_signupFormKey.currentState.validate()) {
      if (!_value1) {
        _signUpScaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text("Accept user agreement and privacy policy"),
        ));
      } else {
        _signupFormKey.currentState.save();

        Map<String, dynamic> userInfo = {
          "mobileNumber": _mobileNumber,
          "firstName": _firstName,
          "lastName": _lastName,
          "email": _email,
          'userType': 'customer',
        };

        final Map<String, dynamic> response =
            await authenticate(_email, _password, AuthMode.SignUp, userInfo);
        if (!response['hasError']) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed("/mainscreen");
        } else if (response['hasError']) {
          Navigator.of(context).pop();
          _signUpScaffoldKey.currentState.showSnackBar(
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
        // print("The response from signup: $response");
      }
    }
  }
}
