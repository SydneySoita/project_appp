import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  final String text;

  LinkButton({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
