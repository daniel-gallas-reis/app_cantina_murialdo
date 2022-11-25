import 'package:flutter/cupertino.dart';

class PageManager {

  final PageController _pageController;
  PageManager(this._pageController);

  int page = 0;

  void setPage(int value){
    if(value == page) return;
    page = value;
    //if(_pageController.hasClients){
      _pageController.jumpToPage(value);
    //}
  }

}