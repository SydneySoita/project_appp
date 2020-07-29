import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/shipping_address.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';

class AddShippingAddressPage extends StatefulWidget {
  final ShippingAddress shippingAddress;

  AddShippingAddressPage({this.shippingAddress});

  @override
  _AddShippingAddressPageState createState() => _AddShippingAddressPageState();
}

var dateFormat = DateFormat('y-MM-dd');
var timeFormat = DateFormat.Hm();

RegExp phoneRegExp =
    RegExp(r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$");

List<String> _regions = [
 'Mombasa',
  'Kwale',
  'Isiolo',
  'Nakuru',
  'Kisumu',
  'Nairobi'


];

class _AddShippingAddressPageState extends State<AddShippingAddressPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _firstName;
  String _lastName;
  String _address;
  String _additionalInfo;
  String _region;
  String _city;
  String _phoneNumber;
  String _additionalPhone;
  bool _setAsDefualtShippingAddress;

  String _selectedRegion;
  String _selectedCity;

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
    // TODO: implement initState
    if (widget.shippingAddress != null) {
      _selectedRegion = widget.shippingAddress.region;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(false);
        return Future.value(false);
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.grey.shade100,
                resizeToAvoidBottomPadding: true,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text(
                    widget.shippingAddress != null
                        ? "Edit Address Info"
                        : "Add New Address",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(LineAwesomeIcons.close),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  iconTheme: IconThemeData(color: Colors.black),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        _buildFirstNameTextFormField(),
                        SizedBox(height: 15.0),
                        _buildLastNameTextFormField(),
                        SizedBox(height: 15.0),
                        _buildAddressTextFormField(),
                        SizedBox(height: 15.0),
                        _buildAdditionalInfoTextFormField(),
                        SizedBox(height: 15.0),
                        _buildRegionDropDown(),
                        SizedBox(height: 15.0),
                        _buildPhoneNumberTextFormField(),
                        SizedBox(height: 15.0),
                        _buildAdditionalPhoneNumberTextFormField(),
                        SizedBox(height: 50.0),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameTextFormField() {
    String firstName;
    if (widget.shippingAddress != null) {
      firstName = widget.shippingAddress.firstName;
    }
    return TextFormField(
      initialValue: firstName != null ? firstName : null,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "First name",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        String errorMessage;
        if (value.isEmpty) {
          errorMessage = "First name is required";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        _firstName = value.trim();
      },
    );
  }

  Widget _buildRegionDropDown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: Center(
        child: DropdownButton(
          hint: new Text('Select Region'),
          items: _regions.map((String region) {
            return DropdownMenuItem<String>(
              child: Text(Functions.capitalizeString(region)),
              value: Functions.capitalizeString(region),
            );
          }).toList(),
          value: _selectedRegion,
          onChanged: (String value) {
            setState(() {
              _selectedRegion = value;
            });
          },
          isExpanded: true,
          underline: Offstage(),
        ),
      ),
    );
  }

  Widget _buildLastNameTextFormField() {
    String lastName;
    if (widget.shippingAddress != null) {
      lastName = widget.shippingAddress.lastName;
    }
    return TextFormField(
      initialValue: lastName != null ? lastName : null,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "Last name",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        String errorMessage;
        if (value.isEmpty) {
          errorMessage = "Last name is required";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        _lastName = value.trim();
      },
    );
  }

  Widget _buildAddressTextFormField() {
    String address;
    if (widget.shippingAddress != null) {
      address = widget.shippingAddress.address;
    }
    return TextFormField(
      initialValue: address != null ? address : null,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "Address",
      ),
      keyboardType: TextInputType.text,
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

  Widget _buildAdditionalInfoTextFormField() {
    String additionalInfo;
    if (widget.shippingAddress != null) {
      additionalInfo = widget.shippingAddress.additionalInfo;
    }
    return TextFormField(
      initialValue: additionalInfo != null ? additionalInfo : null,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "Additional Info",
      ),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _additionalInfo = value.trim();
      },
    );
  }

  Widget _buildPhoneNumberTextFormField() {
    String phoneNumber;
    if (widget.shippingAddress != null) {
      phoneNumber = widget.shippingAddress.phoneNumber;
    }
    return TextFormField(
      initialValue: phoneNumber != null ? phoneNumber : null,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "Mobile phone number",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        String errorMessage;
        if (value.isEmpty) {
          errorMessage = "Mobile phone number is required";
        }
        if (!phoneRegExp.hasMatch(value)) {
          errorMessage = "Enter valid phone number";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        _phoneNumber = value.trim();
      },
    );
  }

  Widget _buildAdditionalPhoneNumberTextFormField() {
    String additionalPhoneNumber;
    if (widget.shippingAddress != null) {
      additionalPhoneNumber = widget.shippingAddress.additionalPhoneNumber;
    }
    return TextFormField(
      initialValue:
          additionalPhoneNumber != null ? additionalPhoneNumber : null,
      decoration: InputDecoration(
        enabledBorder: textFormFieldOutlineBorder,
        focusedBorder: textFormFieldOutlineBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        hintText: "Additional Mobile phone number",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        String errorMessage;
        if (!phoneRegExp.hasMatch(value) & value.isNotEmpty) {
          errorMessage = "Enter valid phone number";
        }
        return errorMessage;
      },
      onSaved: (String value) {
        _additionalPhone = value.trim();
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant(
      builder: (BuildContext sctx, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _onSubmit(model);
            if (model.isShippingAddressLoading) {
              showLoadingProgress(
                context,
                widget.shippingAddress != null
                    ? "Updating address..."
                    : "Adding address...",
              );
            }
          },
          child: Button(
            btnText: widget.shippingAddress != null
                ? "UPDATE ADDRESS"
                : "ADD ADDRESS",
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            fill: true,
            bold: true,
            letterSpacing: 1,
          ),
        );
      },
    );
  }

  void _onSubmit(MainModel model) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Map<String, dynamic> _shippingAddressData = {
        "firstName": _firstName,
        "lastName": _lastName,
        "address": _address,
        "additionalInfo": _additionalInfo,
        "region": _selectedRegion,
        "city": _city,
        "phoneNumber": _phoneNumber,
        "additionalPhoneNumber": _additionalPhone,
      };

      if (widget.shippingAddress == null) {
        final bool response =
            await model.addShippingAddressWithUserId(_shippingAddressData);

        if (response) {
          Navigator.of(context).pop();
          _formKey.currentState.reset();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
              content: Text(
                "Shipping address added successfully.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      } else if (widget.shippingAddress != null) {
        print("Shipping address id: ${widget.shippingAddress.id}");
        final bool response = await model.updateShippingAddress(
          _shippingAddressData,
          widget.shippingAddress.id,
        );

        if (response) {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
              content: Text(
                "Shipping address updated successfully.",
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
}
