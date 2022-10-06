import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Regex_model with ChangeNotifier{
  bool isSwitched1;
  bool isSwitched2;
  bool isSwitched3;
  bool isSwitched4;
  bool isSwitched5;
  bool isSwitched6;
  bool isSwitched7;
  bool isSwitched8;
  bool isPr;
  bool firstapp = true;

  late SharedPreferences prefs;

  saveSwitch1(bool value) async{
    await prefs.setBool("isSwitched1",value);
    notifyListeners();
  }
  saveSwitch2(bool value) async{
    await prefs.setBool("isSwitched2",value);
    notifyListeners();
  }
  saveSwitch3(bool value) async{
    await prefs.setBool("isSwitched3",value);
    notifyListeners();
  }
  saveSwitch4(bool value) async{
    await prefs.setBool("isSwitched4",value);
    notifyListeners();
  }
  saveSwitch5(bool value) async{
    await prefs.setBool("isSwitched5",value);
    notifyListeners();
  }
  saveSwitch6(bool value) async{
    await prefs.setBool("isSwitched6",value);
    notifyListeners();
  }
  saveSwitch7(bool value) async{
    await prefs.setBool("isSwitched7",value);
    notifyListeners();
  }
  saveSwitch8(bool value) async{
    await prefs.setBool("isSwitched8",value);
    notifyListeners();
  }
  saveisPr() async{
    if(isPr == false)
      {
        await prefs.setBool("isPr",false);
      }
    else
      {
        await prefs.setBool("isPr",true);
      }
    notifyListeners();
  }
  savefirstapp(bool value) async{
    await prefs.setBool("firstapp",value);
    notifyListeners();
  }

  getfirstapp()async{
    prefs=await SharedPreferences.getInstance();
    firstapp = prefs.getBool("firstapp")!;
    notifyListeners();
  }

  getSwitch() async{
    prefs = await SharedPreferences.getInstance();
    isSwitched1 = prefs.getBool('isSwitched1')!;
    isSwitched2 = prefs.getBool('isSwitched2')!;
    isSwitched3 = prefs.getBool('isSwitched3')!;
    isSwitched4 = prefs.getBool('isSwitched4')!;
    isSwitched5 = prefs.getBool('isSwitched5')!;
    isSwitched6 = prefs.getBool('isSwitched6')!;
    isSwitched7 = prefs.getBool('isSwitched7')!;
    isSwitched8 = prefs.getBool('isSwitched8')!;
    isPr = prefs.getBool('isPr')!;
    notifyListeners();
  }

  Regex_model({required this.isSwitched1, required this.isSwitched2, required this.isSwitched3, required this.isSwitched4, required this.isSwitched5, required this.isSwitched6, required this.isSwitched7, required this.isSwitched8, required this.isPr, required this.firstapp});


  void changeccc() {
    if (isPr == false) {
      isPr = true;
    } else {
      isPr = false;
    }
    notifyListeners();
  }

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

  void changefirstapp()
  {
    firstapp = false;
    notifyListeners();
  }

}