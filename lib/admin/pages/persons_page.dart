import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetreats/admin/pages/add_item_page.dart';
import 'package:wetreats/admin/pages/add_person_page.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/person_card.dart';

class PersonsPage extends StatefulWidget {
  final bool isUser;

  PersonsPage({this.isUser});
  @override
  PersonsPageState createState() => PersonsPageState();
}

class PersonsPageState extends State<PersonsPage> {
  GlobalKey<ScaffoldState> _personPageScaffoldKey = GlobalKey();

  bool _togglePersonData = false;

  var textStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    if(widget.isUser != null){
      _togglePersonData = widget.isUser;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _personPageScaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            _togglePersonData ? "Admins" : "Customers",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  _togglePersonData ? LineAwesomeIcons.rotate_left :  LineAwesomeIcons.rotate_right),
                onPressed: () {
                  setState(() {
                    _togglePersonData = !_togglePersonData;
                  });
                }),
            IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {}),
          ],
        ),
        body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: model.usersInfo.length > 0
                  ? _buildListView(model)
                  : _buildIsEmptyWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(MainModel model) {
    return ListView.builder(
      itemCount: _togglePersonData ? model.getStaffUserInfo().length + 1 :  model.getCustomersUserInfo().length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildAddNewButton();
        }
        return PersonCard(
          isCustomer: !_togglePersonData,
          userInfo: _togglePersonData ? model.getStaffUserInfo()[index - 1] :  model.getCustomersUserInfo()[index - 1],
        );
      },
    );
  }

  Widget _buildIsEmptyWidget() {
    return ListView(
      children: <Widget>[
        _buildAddNewButton(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.5,
          child: Center(
            child: Text(
              "There are no customers, click on the button above to add new ${_togglePersonData ? "user": "customer"}",
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: () async {
        final bool response = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => AddPersonPage(
                  isCustomer: !_togglePersonData,
                )));
        if (response) {
          _personPageScaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
              content: Text(
               _togglePersonData ? "Admin added successfully" : "Customer added successfully",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          );
        }
      },
      child: Button(
        btnText: "ADD NEW ${_togglePersonData ? "ADMIN" : "CUSTOMER"}",
        height: 56.0,
        color: Theme.of(context).primaryColor,
        fontSize: 18,
        fill: true,
      ),
    );
  }
}
