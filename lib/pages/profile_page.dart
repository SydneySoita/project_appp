import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/models/user.dart';
import 'package:wetreats/models/user_info.dart';
import 'package:wetreats/pages/address_page.dart';
import 'package:wetreats/pages/change_password_page.dart';
import 'package:wetreats/pages/personal_details_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/services/permission_service.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _uploadedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          final User user = model.user;
          final UserInfo userInfo = model.getUserDetails(user.id);

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildImageContainer(model, userInfo),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "${userInfo.lastName} ${userInfo.firstName}",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          LineAwesomeIcons.envelope,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "${userInfo.email}",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              "1",
//                              style: TextStyle(
//                                color: Theme.of(context).accentColor,
//                                fontSize: 20.0,
//                              ),
//                            ),
//                            Text("Items Bought",
//                                style: TextStyle(
//                                  color: Theme.of(context).primaryColor,
//                                  fontSize: 16.0,
//                                )),
//                          ],
//                        ),
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              "${model.userFavoriteItems.length}",
//                              style: TextStyle(
//                                color: Theme.of(context).accentColor,
//                                fontSize: 20.0,
//                              ),
//                            ),
//                            Text("Favorite Items",
//                                style: TextStyle(
//                                  color: Theme.of(context).primaryColor,
//                                  fontSize: 16.0,
//                                )),
//                          ],
//                        ),
//                      ],
//                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PersonalDetailsPage(),
                          ),
                        );
                      },
                      child: _buildRowItems(
                          icon: Icons.details, text: "Personal Details"),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => AddressesPage(),
                          ),
                        );
                      },
                      child: _buildRowItems(
                        icon: LineAwesomeIcons.truck, text: "Delivery Addresses"),
                    ),
                    Divider(),
                    // _buildRowItems(
                    //     icon: LineAwesomeIcons.cc_visa, text: "Payment"),
//                    // Divider(),
//                    _buildRowItems(
//                        icon: LineAwesomeIcons.history, text: "History"),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChangePasswordPage(),
                          ),
                        );
                      },
                      child: _buildRowItems(
                          icon: LineAwesomeIcons.history,
                          text: "Change Password"),
                    ),
                    Divider(),
                    SizedBox(
                      height: 60.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/login_page');
                        model.logout();
                      },
                      child: _buildRowItems(
                          icon: LineAwesomeIcons.sign_out, text: "Logout"),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageContainer(MainModel model, UserInfo userInfo) {
    return GestureDetector(
      onTap: () {
        _showImageOptionsDialog(context, model);
      },
      child: Container(
        height: 130.0,
        width: 130.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              offset: Offset(0, 3.0),
              color: Colors.black12,
            ),
          ],
          borderRadius: BorderRadius.circular(75.0),
          image: DecorationImage(
            image: _uploadedImage != null ? FileImage(_uploadedImage) : userInfo.imageUrl != null ?  NetworkImage(
              userInfo.imageUrl,
            ) : AssetImage("assets/images/profileImagePlaceholder.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildRowItems({IconData icon, String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  void _showImageOptionsDialog(BuildContext ctx, MainModel model) {
    Dialog _imageOptionsDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _uploadedImage != null ? 225.0 : 180.0,
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
                print("Printing from take photo");
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
                    _getImage(model, ImageSource.camera);
                  }
                } else {
                  _getImage(model, ImageSource.camera);
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
                    _getImage(model, ImageSource.gallery);
                  }
                } else {
                  _getImage(model, ImageSource.gallery);
                }
              },
            ),
            _uploadedImage != null
                ? ListTile(
                    leading: Icon(LineAwesomeIcons.trash),
                    title: Text(
                      "Remove Image",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(
                        () {
                          _uploadedImage = null;
                        },
                      );
                    },
                  )
                : Offstage(),
            ListTile(
              leading: Icon(LineAwesomeIcons.remove),
              title: Text(
                "Cancel",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
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

  void _getImage(MainModel model, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _uploadedImage = image;
      });
      model.uploadProfileImage(image);
    });
  }
}
