import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled20/regex_model.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:untitled20/ChipModel.dart';
import 'dart:math';
import 'ChipModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/material.dart' hide BoxDecoration,BoxShadow;
import 'package:untitled20/image_data.dart';

List<ChipModel> chipList = [];
bool flag = true;
List<ImageObject> _imgObjs = [];
File? _image;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorWidget(details.exception);
  };
  runApp(ChangeNotifierProvider(
      create: (context) => Regex_model(isSwitched1: false, isSwitched2: false, isSwitched3: false, isSwitched4: false, isSwitched5: false, isSwitched6: false, isSwitched7: false, isSwitched8: false, isPr: false),
      child: new MyApp())
  );
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final configs = ImagePickerConfigs();
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.black;
    configs.backgroundColor==Colors.transparent;
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 4032,
              int maxHeight = 3024,
              int compressQuality = 100,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 4032,
              int maxHeight = 3024,
              int compressQuality = 100,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75),
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png',
    ];
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color.fromARGB(131, 52, 215, 229),
      ),
      darkTheme: ThemeData(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
      ),
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(isSelected: [false]),
    );
  }
}


class ChipExample extends StatefulWidget {
  const ChipExample({Key? key}) : super(key: key);
  @override
  State<ChipExample> createState() => _ChipExampleState();
}
class _ChipExampleState extends State<ChipExample>{
  late SharedPreferences pref;
  List<String> chipIdList = [];
  List<String> chipNameList = [];

  @override
  _loadPref() async {
    pref = await SharedPreferences.getInstance();
    chipIdList = await (pref.getStringList('ChipID') ?? []);
    chipNameList = await (pref.getStringList('ChipName') ?? []);
    int len = chipIdList.length;
    for (int i = 0; i < len; i++){
      chipList.add(ChipModel(
          id: chipIdList[i],
          name: chipNameList[i]));
    }
  }

  @override
  _loadChips() {
    chipIdList = [];
    chipNameList = [];
    int len = chipList.length;
    for (int i = 0; i < len; i++){
      chipIdList.add(chipList[i].id);
      chipNameList.add(chipList[i].name);
    }
  }

  @override
  _savePref() async {
    await _loadChips();
    pref.setStringList('ChipID', chipIdList);
    pref.setStringList('ChipName', chipNameList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(()async{
      if (flag){
        _loadPref();
        flag = false;
      }
      setState((){});
    });

  }
  // To Store added chips.
  final TextEditingController _chipTextController = TextEditingController();
  // _ChipExampleState({Key? key, required this.chipList});
  //A Function to delete a Chip when user click on deleteIcon on Chip
  void _deleteChip(String id) {
    setState(() {
      chipList.removeWhere((element) => element.id == id);
    });
    _savePref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(
            "사용자 추가 설정",
            style: TextStyle(
              fontWeight:FontWeight.bold,
              fontSize: 23,
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 11),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    spacing: 10,
                    children: chipList
                        .map((chip) => Chip(
                      label: Text(chip.name),
                      backgroundColor: HexColor("E6FFFF"),
                      onDeleted: () => _deleteChip(chip
                          .id), // call delete function by passing click chip id
                    ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.black12,
                            controller: _chipTextController,
                            decoration: InputDecoration(
                              labelText: '추가할 블러처리 텍스트를 입력하세요',
                              labelStyle: TextStyle(
                                color: HexColor("BFBFBF"),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5, color: HexColor("BFBFBF")),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 1.5, color: Colors.black),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // add data text enter in textField into ChipModel
                              setState(() {
                                chipList.add(ChipModel(
                                    id: DateTime.now().toString(),
                                    name: _chipTextController.text));
                                _chipTextController.text = '';
                              });
                              _savePref();
                              print(chipList);
                            },
                          style:ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              HexColor("d3d3d3"),
                            ),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 15)),
                          ),
                          child: Text(
                            "입력",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),)
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key ?key, required this.isSelected}) : super(key: key);
  List<bool> isSelected = [false];


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum AvatarType { TYPE1, TYPE2, TYPE3, TYPE4 }

class AvatarWidget extends StatelessWidget {
  AvatarType type;

  AvatarWidget({
    Key? key,
    required this.type,
  }) : super(key: key);

  Widget type1Widget() {
    return neuorphismButton1();
  }

  Widget type2Widget() {
    return neuorphismButton2();
  }

  Widget type3Widget() {
    return neuorphismButton3();
  }

/*
  Widget type4Widget() {
    return neuorphismButton4()
  }
*/
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AvatarType.TYPE1:
        return type1Widget();
      case AvatarType.TYPE2:
        return type2Widget();
      case AvatarType.TYPE3:
        return type3Widget();
      case AvatarType.TYPE4:
        return type3Widget();
    }
    return Container();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _button1() {
    return Stack(
      children: [AvatarWidget(type: AvatarType.TYPE1)],
    );
  }

  Widget _button2() {
    return Stack(
      children: [
        AvatarWidget(
          type: AvatarType.TYPE2,
        ),
      ],
    );
  }

  Widget _button3() {
    return Stack(
      children: [
        AvatarWidget(
          type: AvatarType.TYPE3,
        ),
      ],
    );
  }

  late String inputTitle;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(() async {
      Provider.of<Regex_model>(context,listen: false).getSwitch();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding:EdgeInsets.fromLTRB(0, 29, 0, 0),
              child: Container(
                child: ListTile(
                  leading: Icon(
                    Icons.menu,
                  ),
                  title:Text('설 정',style: TextStyle(fontSize: 20),),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50))
                ),
              ),
            ),
            ListTile(
                title:Text('블러 목록',style: TextStyle(fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),),
                trailing:
                FittedBox(
                    fit:BoxFit.fill,
                    child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => ChipExample()));
                            },
                          )
                        ]
                    )
                )
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('얼굴')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched1,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex1();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch1(value);
                  });
                },
              ),
            ),ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('이메일 주소')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched7,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex7();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch7(value);
                  });
                },
              ),
            ),ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('주민등록번호')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched8,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex8();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch8(value);
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('핸드폰 번호')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched2,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex2();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch2(value);
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('주소')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched3,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex3();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch3(value);
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('운전면허 번호')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched4,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex4();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch4(value);
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('계좌번호')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched5,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex5();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch5(value);
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('카드 번호')),
              trailing: Switch(
                activeTrackColor: Colors.blueGrey,
                activeColor: Colors.grey,
                value: Provider.of<Regex_model>(context).isSwitched6,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex6();
                    Provider.of<Regex_model>(context,listen: false).saveSwitch6(value);
                  });
                },
              ),
            ),
            ListTile(
              title:Text('버전명시',style: TextStyle(fontSize: 20.0),),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: ListTile(
                title:Text('버전 : v0.0.1'),
              ),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('B l u r B l u r',style: TextStyle(color: Colors.black)),
          backgroundColor: Provider.of<Regex_model>(context).isPr
              ? Color(0xffAEE6CB)
              : Colors.white,
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                child: _button1()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Container(
                    //color: isPressed ? Colors.white : Colors.green,
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: _button2(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.15,
                  color: Provider.of<Regex_model>(context).isPr
                      ? Color(0xffAEE6CB)
                      : Colors.white,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Container(
                    //color: isPressed ? Colors.white : Colors.green,
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: _button3(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class neuorphismButton1 extends StatefulWidget {

  @override
  State<neuorphismButton1> createState() => _neuorphismButton1State();
}

class _neuorphismButton1State extends State<neuorphismButton1> {
  @override
  Widget build(BuildContext context) {
    Offset distance =
    Provider.of<Regex_model>(context).isPr ? Offset(5, 5) : Offset(15, 15);
    double blur = Provider.of<Regex_model>(context).isPr ? 5 : 20;
    final backgroundColor =
    Provider.of<Regex_model>(context).isPr ? Color(0xffAEE6CB) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Provider.of<Regex_model>(context, listen: false).changeccc();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  //borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: -distance,
                      blurRadius: blur,
                      spreadRadius: 0.2,
                      inset: Provider.of<Regex_model>(context).isPr,
                    ),
                    BoxShadow(
                      color: Color(0xFFA7A9AF),
                      offset: distance,
                      blurRadius: blur,
                      spreadRadius: 0.2,
                      inset: Provider.of<Regex_model>(context).isPr,
                    ),
                  ],
                ),
                child: SizedBox(
                  child: Align(
                    child: ImageData(
                      IconsPath.shield,
                      color: Provider.of<Regex_model>(context).isPr
                          ? Colors.white
                          : Colors.black,
                      width: 0.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class neuorphismButton2 extends StatefulWidget {

  @override
  State<neuorphismButton2> createState() => _neuorphismButton2State();
}

class _neuorphismButton2State extends State<neuorphismButton2> {
  @override
  Widget build(BuildContext context) {
    Offset distance =
    Provider.of<Regex_model>(context).isPr ? Offset(3, 3) : Offset(9, 9);
    double blur = Provider.of<Regex_model>(context).isPr ? 5 : 20;
    final backgroundColor =
    Provider.of<Regex_model>(context).isPr ? Color(0xffAEE6CB) : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            child: GestureDetector(
              /*onTap: () {
                setState(() {
                  isPressed = !isPressed;
                });
              }*/
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: -distance,
                      blurRadius: blur,
                      //spreadRadius: 0.1,
                      //inset: isPressed,
                    ),
                    BoxShadow(
                      color: Color(0xFFA7A9AF),
                      offset: distance,
                      blurRadius: blur,
                      //spreadRadius: 0.1,
                      //inset: isPressed,
                    ),
                  ],
                ),
                child: SizedBox(
                  child: Align(
                    child: IconButton(
                      onPressed: ()async{
                        final List<ImageObject>? objects = await Navigator.of(context)
                            .push(PageRouteBuilder(pageBuilder: (context, animation, __){
                              return const ImagePicker(mode: 0,maxCount: 0);
                        }));
                        if((objects?.length ?? 0) > 0){
                          setState((){
                            _imgObjs = objects!;
                          });
                        }
                      },
                      icon: Icon(
                          Icons.camera_enhance,
                          color: Provider.of<Regex_model>(context).isPr
                              ? Colors.white
                              : Colors.black,
                          size: MediaQuery.of(context).size.width * 0.075
                      )
                    )
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class neuorphismButton3 extends StatefulWidget {

  @override
  State<neuorphismButton3> createState() => _neuorphismButton3State();
}

class _neuorphismButton3State extends State<neuorphismButton3> {
  @override
  Widget build(BuildContext context) {
    Offset distance =
    Provider.of<Regex_model>(context).isPr ? Offset(3, 3) : Offset(9, 9);
    double blur = Provider.of<Regex_model>(context).isPr ? 5 : 20;
    final backgroundColor =
    Provider.of<Regex_model>(context).isPr ? Color(0xffAEE6CB) : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            child: GestureDetector(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: -distance,
                      blurRadius: blur,
                      //spreadRadius: 0.1,
                      //inset: isPressed,
                    ),
                    BoxShadow(
                      color: Color(0xFFA7A9AF),
                      offset: distance,
                      blurRadius: blur,
                      //spreadRadius: 0.1,
                      //inset: isPressed,
                    ),
                  ],
                ),
                child: SizedBox(
                  child: Align(
                    child: IconButton(
                      onPressed: ()async{
                        final List<ImageObject>? objects = await Navigator.of(context)
                            .push(PageRouteBuilder(pageBuilder: (context, animation, __){
                              return const ImagePicker(mode:1,maxCount: 10000,);
                        }));
                        if((objects?.length ?? 0) > 0){
                          setState((){
                            _imgObjs = objects!;
                          });
                        }
                      },
                      icon: Icon(
                      Icons.image,
                      color: Provider.of<Regex_model>(context).isPr
                          ? Colors.white
                          : Colors.black,
                      size: MediaQuery.of(context).size.width * 0.075,
                    ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}