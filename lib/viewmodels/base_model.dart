import 'package:flutter/widgets.dart';
import 'package:parkspace/data/Model/error_dialog.dart';
import 'package:parkspace/enums/error_types.dart';
import 'package:parkspace/enums/viewstate.dart';

class BaseModel extends ChangeNotifier {
  bool _processing = false;
  bool get isProcessing => _processing;

  AppDialog _error;
  AppDialog get error => _error;

  set errorDialog(AppDialog errorDialog) => _error = errorDialog;

  void setError(String errorMsg, ErrorTypes type) {
    _error = new AppDialog(message: errorMsg);
  }

  void setProcessing(bool val) {
    _processing = val;
    notifyListeners();
  }

  BaseModel() {}

  void setState(ViewState viewState) {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
