//import 'package:flutter/material.dart';
//import 'package:square_in_app_payments/models.dart';
//import 'package:square_in_app_payments/in_app_payments.dart';
//
//class PaymentPage extends StatefulWidget {
//  PaymentPage({Key key}) : super(key: key);
//
//  @override
//  _PaymentPageState createState() => _PaymentPageState();
//}
//
//class _PaymentPageState extends State<PaymentPage> {
//
//  void _pay(){
//
//    InAppPayments.setSquareApplicationId('sq0idp-DpB7OIQHz1mxxvfRgB5KKw');
//    InAppPayments.startCardEntryFlow(
//      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
//      onCardEntryCancel: _cardEntryCancel,
//
//    );
//  }
//  void _cardEntryCancel(){
//
//  }
//  void _cardNonceRequestSuccess(CardDetails result){
//    print(result.nonce);
//
//    InAppPayments.completeCardEntry(
//      onCardEntryComplete: _cardEntryComplete,
//    );
//  }
//  void _cardEntryComplete(){
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    throw UnimplementedError();
//  }
//}
//
//
