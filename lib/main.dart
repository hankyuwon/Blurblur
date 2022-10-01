import 'dart:io';
import 'package:flutter/material.dart';
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

List<ChipModel> chipList = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorWidget(details.exception);
  };
  runApp(ChangeNotifierProvider(
    create: (context) => Regex_model(isSwitched1: false, isSwitched2: false, isSwitched3: false, isSwitched4: false, isSwitched5: false, isSwitched6: false, isSwitched7: false, isSwitched8: false),
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
      debugShowCheckedModeBanner: false,
      title: 'Generated App',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new MyHomePage(isSelected: [false]),
    );
  }
}


class ChipExample extends StatefulWidget {
  const ChipExample({Key? key}) : super(key: key);
  @override
  State<ChipExample> createState() => _ChipExampleState();
}
class _ChipExampleState extends State<ChipExample> {
  // To Store added chips.
  final TextEditingController _chipTextController = TextEditingController();
  // _ChipExampleState({Key? key, required this.chipList});
  //A Function to delete a Chip when user click on deleteIcon on Chip
  void _deleteChip(String id) {
    setState(() {
      chipList.removeWhere((element) => element.id == id);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("Blind 목록",style: TextStyle(fontSize: 25,),),
            Padding(
              padding: EdgeInsets.all(10),
              child: Wrap(
                spacing: 10,
                children: chipList.map((chip) => Chip(
                  label: Text(chip.name),
                  backgroundColor: Colors.tealAccent,
                  onDeleted: ()=> _deleteChip(chip.id), // call delete function by passing click chip id
                ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chipTextController,
                            decoration:
                            InputDecoration(border: OutlineInputBorder()),
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
                            },
                            child: Text("확인"))
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key ?key, required this.isSelected}) : super(key: key);
  List<bool> isSelected = [false];
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageObject> _imgObjs = [];
  File? _image;

  late String inputTitle;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var isSwitched=false;
  // var isSwitched1=false;
  // var isSwitched2=false;
  // var isSwitched3=false;
  // var isSwitched4=false;
  // var isSwitched5=false;
  // var isSwitched6=false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: widget.isSelected[0]?Colors.greenAccent.shade200:Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding:EdgeInsets.fromLTRB(0, 29, 0, 0),
              child: Container(
                child: ListTile(
                  leading: Icon(
                    Icons.menu,
                    color: widget.isSelected[0]? Colors.white: Colors.black,
                  ),
                  title:Text('설 정',style: TextStyle(fontSize: 20),),
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0,3)
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
              ),
            ),
            ListTile(
              title:Text('자동실행',style: TextStyle(fontSize: 20.0),),
            ),
            ListTile(
              title:Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('부팅 시 자동실행')),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value){
                  setState(() {
                    isSwitched=value;
                  });
                },
              ),
            ),
            ListTile(
              title:Text('블러 처리 목록',style: TextStyle(fontSize: 20.0),),
              trailing:
              FittedBox(
                fit:BoxFit.fill,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ChipExample()));
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){
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
                value: Provider.of<Regex_model>(context).isSwitched1,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex1();
                  });
                },
              ),
            ),ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('이메일 주소')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched7,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex7();
                  });
                },
              ),
            ),ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('주민등록번호')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched8,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex8();
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('핸드폰 번호')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched2,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex2();
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('주소')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched3,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex3();
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('운전면허 번호')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched4,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex4();
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('계좌번호')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched5,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex5();
                  });
                },
              ),
            ),
            ListTile(
              title:Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text('카드 번호')),
              trailing: Switch(
                value: Provider.of<Regex_model>(context).isSwitched6,
                onChanged: (value){
                  setState(() {
                    Provider.of<Regex_model>(context,listen: false).changeRegex6();
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
      body:
      SingleChildScrollView(
        child: Stack(
          children: [
            AnimatedContainer(
              width: widget.isSelected[0]? 1000: 1000,
              height: widget.isSelected[0]? 1000: 1000,
              color: widget.isSelected[0]? Colors.greenAccent: Colors.white,
              duration: Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn,
            ),
            AnimatedContainer(
              width: widget.isSelected[0]? 300: 300,
              height: widget.isSelected[0]? 130: 130,
              color: widget.isSelected[0]? Colors.greenAccent: Colors.white,
              duration: Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: IconButton(
                      icon: Icon(Icons.menu),
                      color: widget.isSelected[0]?Colors.white:Colors.black,
                      onPressed: (){
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                  Text("  B l u r   B l u r",style: TextStyle(fontStyle: FontStyle.normal,fontSize: 25,color:widget.isSelected[0]?Colors.white:Colors.black),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 100, 0, 0),
              child: AnimatedContainer(
                width: widget.isSelected[0]? 390: 0,
                height: widget.isSelected[0]? 2: 2,
                color: widget.isSelected[0]? Colors.white: Colors.white,
                duration: Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.fromLTRB(0, 230, 0, 0)),
                ToggleButtons(constraints:BoxConstraints(minWidth: 230.0, minHeight: 230.0),
                    borderRadius: BorderRadius.circular(180),
                    borderWidth: 5,
                    disabledColor: Colors.grey,
                    splashColor: Colors.green,
                    highlightColor: Colors.green,
                    focusColor: Colors.green,
                    color: Colors.green,
                    selectedColor: Colors.green,
                    selectedBorderColor: Colors.white,
                    hoverColor: Colors.green,
                    children:[
                  Icon(widget.isSelected[0]?Icons.shield:Icons.heart_broken,size: 130,
                  color: widget.isSelected[0]?Colors.white:Colors.black12)],
                    onPressed:(int index){setState(() {
                      widget.isSelected[index] = !widget.isSelected[index];
                });},
                    isSelected: widget.isSelected),
                Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                Switch(
                  value: widget.isSelected[0],
                  onChanged: (value){
                    setState(() {
                      widget.isSelected[0]=value;
                    });
                  },
                  activeColor: Colors.green,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
                widget.isSelected[0]?AnimatedOpacity(
                  child: new Text(
                    "감지가 활성 상태입니다.",
                    style: new TextStyle(fontSize:25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"),
                  ),
                  opacity: 1,
                  duration: Duration(seconds:1),
                ):AnimatedOpacity(
                  child: Text(
                    "감지가 비활성 상태입니다.",
                    style: new TextStyle(fontSize:25.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"),
                  ),
                  opacity: 0.3,
                  duration: Duration(seconds: 1),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
                widget.isSelected[0]?AnimatedOpacity(
                  child: new Text(
                    "n 개의 사진에 개인정보가 감지되었습니다.",
                    style: new TextStyle(fontSize:20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),
                  opacity: 1,
                  duration: Duration(seconds: 1),
                ):AnimatedOpacity(
                  child: Text(
                    "활성화하여 개인정보를 보호하세요.",
                    style: new TextStyle(fontSize:20.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),
                  opacity: 0.3,
                  duration: Duration(seconds: 1),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.isSelected[0]?AnimatedOpacity(
                          child: IconButton(
                                  onPressed: ()async{
                                    // Get max 5 images
                                    final List<ImageObject>? objects = await Navigator.of(context)
                                        .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                                      return const ImagePicker(mode:0,maxCount:10000);
                                    }));
                                    if ((objects?.length ?? 0) > 0) {
                                      setState(() {
                                        _imgObjs = objects!;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                      Icons.enhance_photo_translate_outlined,
                                      color: Colors.white,
                                      size: 48.0),
                                ),
                          opacity: 1,
                          duration: Duration(seconds: 1),
                        ):AnimatedOpacity(
                                child: IconButton(
                          onPressed: (){},
                          icon: Icon(
                                Icons.enhance_photo_translate_outlined,
                                color: Colors.white,
                                size: 48.0),
                        ),
                          opacity: 0.1,
                          duration: Duration(seconds:1),
                              ),
                        widget.isSelected[0]?AnimatedOpacity(
                          child: IconButton(
                            onPressed: ()async{
                              final List<ImageObject>? objects = await Navigator.of(context)
                                  .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                                return const ImagePicker(mode:1,maxCount: 10000);
                              }));
                              if ((objects?.length ?? 0) > 0) {
                                setState(() {
                                  _imgObjs = objects!;
                                });
                              }
                            },
                            icon: Icon(
                                Icons.photo_outlined,
                                color: Colors.white,
                                size: 48.0),
                          ),
                          duration: Duration(seconds: 1),
                          opacity: 1,
                        ):AnimatedOpacity(
                          child: IconButton(
                            onPressed: (){},
                            icon: Icon(
                                Icons.photo_outlined,
                                color: Colors.white,
                                size: 48.0),
                          ),
                          opacity: 0.1,
                          duration: Duration(seconds: 1),
                        ),
                            ]
                        ),
                )
              ]
          )
          ],
        ),
      ),
    );
  }
}