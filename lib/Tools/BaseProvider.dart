import 'dart:async';

import 'package:backgrounds/Tools/StateEnums.dart';
import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier {
  PrState _state = PrState.Idle;
  String _err = "";

  PrState get state => _state;
  String get err => _err;

  void setState(value) {
    _state = value;

    notifyListeners();
  }

  Timer timer;
  void setError(value) {
    _err = value.toString();
    setState(PrState.Idle);
    _setErrorClearince();
  }

  _setErrorClearince() {
    if (_err.isEmpty) {
      timer?.cancel();
      return;
    }
    timer = Timer(Duration(seconds: 10), () {
      setError('');
    });
  }

  void setErrorStr(String value) {
    _err = value;
    setState(PrState.Idle);
    _setErrorClearince();
  }
}
