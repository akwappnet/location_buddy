import 'package:flutter/cupertino.dart';

class HomeViewModel with ChangeNotifier {
  var currentIndex = 0;
  get _currentIndex => currentIndex;
  void updateIndex(var value) {
    currentIndex = value;
    notifyListeners();
  }
}
