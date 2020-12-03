import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkspace/data/Model/error_dialog.dart';

void defaultDialog({
  @required AppDialog dialog,
  @required BuildContext context,
  bool firstButtonDefault = true,
}) {
  var dialogActions = new List<Widget>();

  dialogActions.add(CupertinoDialogAction(
    isDefaultAction: firstButtonDefault,
    child: Text(dialog.firstButtonText),
    onPressed: dialog.firstButtonOnPressed == null
        ? () {
            Navigator.of(context).pop();
          }
        : dialog.firstButtonOnPressed,
  ));

  if (dialog.secondButtonText != null) {
    dialogActions.add(CupertinoDialogAction(
      isDefaultAction: !firstButtonDefault,
      child: Text(dialog.secondButtonText),
      onPressed: dialog.secondButtonOnPressed,
    ));
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // var brightness = MediaQuery.of(context).platformBrightness;
      return CupertinoAlertDialog(
        title: Text(
          dialog.title,
          style: TextStyle(
            fontSize: 20,
            // color: brightness == Brightness.light ? Colors.black : Colors.white,
            // color: Colors.black,
            letterSpacing: 1,
          ),
        ),
        content: Padding(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: Text(dialog.message),
        ),
        actions: dialogActions,
      );
    },
  );
}
