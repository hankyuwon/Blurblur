import 'package:flutter/material.dart';

class CustomText{

}

class Regex_model with ChangeNotifier{
  bool isSwitched1;
  bool isSwitched2;
  bool isSwitched3;
  bool isSwitched4;
  bool isSwitched5;
  bool isSwitched6;
  bool isSwitched7;
  bool isSwitched8;

  Regex_model({required this.isSwitched1, required this.isSwitched2, required this.isSwitched3, required this.isSwitched4, required this.isSwitched5, required this.isSwitched6, required this.isSwitched7, required this.isSwitched8});

  void changeRegex1(){

    if(isSwitched1 == false)
      isSwitched1 = true;
    else
      isSwitched1 = false;

    print(isSwitched1);
    notifyListeners();
  }
  void changeRegex2(){

    if(isSwitched2 == false)
      isSwitched2 = true;
    else
      isSwitched2 = false;

    notifyListeners();
  }
  void changeRegex3(){

    if(isSwitched3 == false)
      isSwitched3 = true;
    else
      isSwitched3 = false;

    notifyListeners();
  }
  void changeRegex4(){

    if(isSwitched4 == false)
      isSwitched4 = true;
    else
      isSwitched4 = false;

    notifyListeners();
  }
  void changeRegex5(){

    if(isSwitched5 == false)
      isSwitched5 = true;
    else
      isSwitched5 = false;

    notifyListeners();
  }
  void changeRegex6(){

    if(isSwitched6 == false)
      isSwitched6 = true;
    else
      isSwitched6 = false;

    notifyListeners();
  }
  void changeRegex7(){

    if(isSwitched7 == false)
      isSwitched7 = true;
    else
      isSwitched7 = false;

    notifyListeners();
  }
  void changeRegex8(){

    if(isSwitched8 == false)
      isSwitched8 = true;
    else
      isSwitched8 = false;

    notifyListeners();
  }
}