import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:wetreats/scoped-model/main_scoped_model.dart';
import 'package:wetreats/widgets/button.dart';
import 'package:wetreats/widgets/loading_progress_dialog.dart';


class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  void _pay(){

    InAppPayments.setSquareApplicationId('sq0idp-DpB7OIQHz1mxxvfRgB5KKw');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel,

    );
  }
  void _cardEntryCancel(){

  }
  void _cardNonceRequestSuccess(CardDetails result){
    print(result.nonce);

    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }
  void _cardEntryComplete(){

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant(
        builder: (BuildContext sctx, Widget child, MainModel model) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Text("Make Payment", style: TextStyle(color: Colors.black, fontSize: 16.0),),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(LineAwesomeIcons.remove, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Ksh${model.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    "Select payment method and proceed to pay for your order",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 5),
                  GestureDetector(
                    onTap: (){

                      showLoadingProgress(context, "Processing payment...");
                      _pay();
                      model.addOrderToDatabase().then((bool response){
                        Navigator.of(context).pop();
                        model.resetValues();
                      });
                    },
                    child: Button(
                      btnText: "MAKE PAYMENT",
                      width: 230.0,
                      height: 50.0,
                      color: Theme.of(context).primaryColor,
                      bold: true,
                      fill: true,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
