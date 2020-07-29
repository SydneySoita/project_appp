  import 'package:flutter/material.dart';

  Future<void> showLoadingProgress(BuildContext context, loadingText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 15.0,
              ),
              Text("$loadingText"),
            ],
          ),
        );
      },
    );
  }