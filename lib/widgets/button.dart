import 'package:flutter/material.dart';
import 'package:wetreats/functions/functions.dart';

class Button extends StatelessWidget {
  final String btnText;
  final Color color;
  final double width;
  final double height;
  final double fontSize;
  final double letterSpacing;
  final bool bold;
  final bool fill;

  Button({
    this.btnText,
    this.color,
    this.width,
    this.height,
    this.fontSize,
    this.letterSpacing,
    this.bold,
    this.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height != null ? height : 25.0,
      width: width != null ? width : 60.0,
      decoration: BoxDecoration(
        color: fill != null && fill ? color: Colors.white,
        border: Border.all(
          color: color != null ? color : Colors.blue,
          width: 2,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0)
        ),
      ),
      child: Center(
        child: Text(
          Functions.upperCase(btnText),
          style: TextStyle(
            letterSpacing: letterSpacing,
            color: fill != null && fill ? Colors.white: color != null ? color: Colors.blue,
            fontSize: fontSize != null ? fontSize : 16.0,
            fontWeight: bold != null && bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
