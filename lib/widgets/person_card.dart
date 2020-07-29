import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:wetreats/admin/pages/add_person_page.dart';
import 'package:wetreats/functions/functions.dart';
import 'package:wetreats/models/user_info.dart';

class PersonCard extends StatelessWidget {
  
  final bool isCustomer;
  final UserInfo userInfo;

  PersonCard({this.userInfo, this.isCustomer});

  final _mediumSpace = SizedBox(
    width: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    final String fullname = userInfo.firstName + " " +  userInfo.lastName;
    return Container(
      height: 146.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 5.0,
          color: Colors.black38,
          offset: Offset(0, 3.0),
        ),
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 2.0,
                      offset: Offset(0, 3.0),
                    )
                  ],
                  image: DecorationImage(
                    // image: person.personImage != null
                    //     ?
                    // NetworkImage(
                    //     person.personImage,
                    //   )
                    // :
                    image: AssetImage("assets/images/lunch.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // CustomVerticalDivider(
              //   height: 80.0,
              // ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Functions.titleCase(fullname),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // userInfo.isEmpty
                    //     ? Offstage()
                    //     :
                    Text(
                      userInfo.email,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      userInfo.mobileNumber,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  Functions.capitalizeString(
                    userInfo.userType
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              
              GestureDetector(
                child: Icon(
                  LineAwesomeIcons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddPersonPage(
                        isCustomer: isCustomer,
                        userInfo: userInfo,
                      ),
                    )
                  );
                },
              ),
              _mediumSpace,
              GestureDetector(
                child: Icon(
                  LineAwesomeIcons.eye,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {},
              ),
              _mediumSpace,
              GestureDetector(
                child: Icon(
                  LineAwesomeIcons.trash,
                  color: Colors.red,
                ),
                onTap: () {},
              )
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildIconButtons() {
  //   return GestureDetector(
  //     child: Icon(
  //       LineAwesomeIcons.trash,
  //       color: Colors.red,
  //     ),
  //     onTap: () {},
  //   );
  // }
}
