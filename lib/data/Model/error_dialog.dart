import 'package:flutter/cupertino.dart';
import 'package:parkspace/resources/config/error_messages.dart';

class AppDialog {
  String title;
  String message;
  String firstButtonText = "Cancel";
  Function firstButtonOnPressed;
  String secondButtonText;
  Function secondButtonOnPressed;

  AppDialog({
    this.title = ErrorMessages.DEFAULT_ERROR_TITLE,
    @required this.message,
    this.firstButtonText,
    this.firstButtonOnPressed,
    this.secondButtonText,
    this.secondButtonOnPressed,
  });

}
