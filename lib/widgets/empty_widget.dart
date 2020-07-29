import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final IconData iconData;
  final String message;
  final Color color;

  EmptyWidget({this.iconData, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return   Container(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: color != null ? color :  Colors.black12,
            size: 100.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "$message",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}