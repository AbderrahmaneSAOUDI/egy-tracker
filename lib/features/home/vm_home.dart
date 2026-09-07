import 'package:flutter/foundation.dart';

/// ViewModel managing tab navigation state in the Home scaffold.
class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 1;
  int _slideDirection = 1;

  static const List<String> titles = [
    'Home',
    'My Tracker',
    'Settings',
  ];

  int get selectedIndex => _selectedIndex;
  int get slideDirection => _slideDirection;
  String get currentTitle => titles[_selectedIndex];

  void selectTab(int index) {
    if (_selectedIndex == index) return;
    _slideDirection = index > _selectedIndex ? 1 : -1;
    _selectedIndex = index;
    notifyListeners();
  }
}
