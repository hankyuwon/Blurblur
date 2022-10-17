import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:advance_image_picker/widgets/picker/image_picker.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

import 'dart:ui' as ui;

import 'extension/num_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

import 'model/float_text_model.dart';
import 'widget/drawing_board.dart';
import 'widget/editor_panel_controller.dart';
import 'widget/float_text_widget.dart';
import 'widget/image_editor_delegate.dart';
import 'widget/text_editor_page.dart';
import 'package:provider/provider.dart';
import 'package:untitled20/regex_model.dart';
import 'package:untitled20/main.dart' as hank;
import 'package:untitled20/ChipModel.dart';

List<ChipModel> chipList = hank.chipList;

int faceNumber=0;
int ocrNumber=0;
List<Face> recognisedface=[];
List<Face> bluredface=[];
List<TextBlock> blocks=[];
bool eraseAccept=false;
bool textScanning=false;
bool isWorking=false;
int autoMosc=0;
List<TextElement> bluredOCR=[];
double imageWidth =0;
double imageHeight =0;
double size_width =0;
double size_height =0;

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth=1
      ..color = Colors.greenAccent
      ..isAntiAlias=true;
    for (int i =0;i<recognisedface.length;i++) {
      canvas.drawRect(
          Rect.fromLTRB(
            recognisedface[i].boundingBox.left * size.width / imageWidth,
            recognisedface[i].boundingBox.top * size.height / imageHeight,
            recognisedface[i].boundingBox.right * size.width / imageWidth,
            recognisedface[i].boundingBox.bottom * size.height / imageHeight,
          )
          // recognisedface[i].boundingBox.topLeft * size.width / imageWidth & recognisedface[i]
          //     .boundingBox.size * size.width / imageWidth
          , background);


    }
    size_width = size.width;
    size_height = size.height;

    // print('size.width');
    // print(size.width);

    // print('imageWidth');
    // print(imageWidth);

    // print('size.height');
    // print(size.height);

    // print('imageheight');
    // print(imageHeight);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class BackgroundPainter2 extends CustomPainter {
  BackgroundPainter2(this.elements);

  final List<TextElement> elements;
  @override
  void paint(Canvas canvas, Size size) {
    var background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth=1
      ..color = Colors.greenAccent
      ..isAntiAlias=true;


    for(int i=0;i<elements.length;i++)
    {
      canvas.drawRect(
          Rect.fromLTRB(
            elements[i].boundingBox.left * size.width / imageWidth,
            elements[i].boundingBox.top * size.height / imageHeight,
            elements[i].boundingBox.right * size.width / imageWidth,
            elements[i].boundingBox.bottom * size.height / imageHeight,
          ),background);

      //elements[i].boundingBox.topLeft * size.width / imageWidth & elements[i].boundingBox.size * size.width / imageWidth ,background);
      //print(elements[i]);
    }


  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

///The editor's result.
class EditorImageResult {
  ///image width
  final int imgWidth;

  ///image height
  final int imgHeight;

  ///new file after edit
  final File newFile;

  EditorImageResult(this.imgWidth, this.imgHeight, this.newFile);
}


class ImageEditor extends StatefulWidget {

  const ImageEditor({Key? key, required this.originImage, this.savePath}) : super(key: key);
  ///origin image
  /// * input for edit
  final File originImage;

  ///edited-file's save path.
  /// * if null will save in temporary file.
  final Directory? savePath;

  ///[uiDelegate] is determine the editor's ui style.
  ///You can extends [ImageEditorDelegate] and custome it by youself.
  static ImageEditorDelegate uiDelegate = DefaultImageEditorDelegate();

  @override
  State<StatefulWidget> createState() {
    return ImageEditorState();
  }
}

class ImageEditorState extends State<ImageEditor>
    with SignatureBinding, ScreenShotBinding, TextCanvasBinding, RotateCanvasBinding, LittleWidgetBinding, WindowUiBinding {
  final EditorPanelController _panelController = EditorPanelController();

  double get headerHeight => windowStatusBarHeight;

  double get bottomBarHeight => 85 + windowBottomBarHeight;

  ///Edit area height.
  double get canvasHeight => screenHeight - bottomBarHeight - headerHeight;

  ///Operation panel button's horizontal space.
  Widget get controlBtnSpacing => 5.hGap;

  List<TextElement> _elements =[];


  // List<EntityType> filter=[EntityType.address,EntityType.email,EntityType.trackingNumber,EntityType.paymentCard,EntityType.phone,EntityType.unknown,EntityType.money,EntityType.dateTime];

  String scannedText="";

  bool done=false;
  dynamic getRecognisedFace2(File image,bool A,bool B,bool C,bool D,bool E,bool F,bool G,bool H) async {
    List<TextElement> _elements2 = [];
    _elements2.clear();
    int faceNumber2 = 0;
    int ocrNumber2 = 0;
    List<Face> recognisedface2 = [];
    List<Face> bluredface2 = [];
    int BackgroundrecogniseNumber = 2;

    final inputImage = InputImage.fromFilePath(image.path);
    // int faceNumber2=0;
    // int ocrNumber2=0;
    // List<Face> recognisedface2=[];
    // List<Face> bluredface2=[];

    print('이미지패스');
    print(image.path);
    print('이미지패스');

    if(A==true){
      print('여기서 멈추면 0');
      print('여기서 멈추면 0-1');
      final FaceDetector = GoogleMlKit.vision.faceDetector();
      print('여기서 멈추면 0-2');
      recognisedface2 = await FaceDetector.processImage(inputImage);
      print('여기서 멈추면 0-3');
      faceNumber2 = recognisedface2.length;
      print('여기서 멈추면 0-4');
      await FaceDetector.close();
    }


    print('여기서 멈추면 1');
    final textDetector=GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText2=await textDetector.processImage(inputImage);
    await textDetector.close();

    print('여기서 멈추면 2');

    String email_pattern =
        r"^(([\w!-_\.])*@([\w!-_\.])*\.[\w]{2,3})$";

    String phoneNumber_pattern =
        r"^(?:(010-\d{4})|(01[1|6|7|8|9]-\d{3,4}))-(\d{4})$";

    // String Name_pattern =
    //     r'^[가-힣]{2,4}$';

    String zoominbunho =
        r'^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$';

    String Zibunzooso = r'([가-힣]{1,}시)?(\s)?([가-힣]{1,}구)?(\s)?([가-힣]{1,}로)(\s)?([^가-힣]{1,})';
    String ZibunzoosoRegExp0 = r'[가-힣]{1,}시';
    String ZibunzoosoRegExp1 = r'[가-힣]{1,}구';
    String ZibunzoosoRegExp2 = r'[가-힣]{1,}로';
    String ZibunzoosoRegExp3 = r'[^가-힣]{1,}';

    String doromyoung = r'([가-힣]{1,}시)?(\s)?([가-힣]{1,}구)?(\s)?(([가-힣]{1,}동))?(\s)?(([가-힣]{1,}아파트)+)';
    String doromyoungRegExp0 = r'[가-힣]{1,}시';
    String doromyoungRegExp = r'[가-힣]{1,}동';
    String doromyoungRegExp2 = r'[가-힣]{1,}아파트';
    String doromyoungRegExp3 = r'[가-힣]{1,}구';
    String doromyoungRegExp4 = r'[\d]{1,}동';
    String doromyoungRegExp5 = r'[\d]{1,}호';


    String woonjunmyunhu = r'^(\d{2}-\d{2}-\d{6}-\d{2})$';

    String tongjang = r"^(\d{2,6}[ -]-?\d{2,6}[ -]-?\d{2,6}[ -]-?\d{2,6})$";

    String card = r'^(\\d{4})-?(\\d{4})-?(\\d{4})-?(\\d{3,4})$';

    RegExp regEx = RegExp(phoneNumber_pattern);
    RegExp regEx2 = RegExp(email_pattern);
    // RegExp regEx3 = RegExp(Name_pattern);
    RegExp regEx4 = RegExp(zoominbunho);
    RegExp regEx5 = RegExp(Zibunzooso);
    RegExp regEx6 = RegExp(doromyoung);
    RegExp regEx7 = RegExp(woonjunmyunhu);
    RegExp regEx8 = RegExp(tongjang);
    RegExp regEx9 = RegExp(card);


    RegExp regEx100 = RegExp(doromyoungRegExp);
    RegExp regEx101 = RegExp(doromyoungRegExp0);
    RegExp regEx102 = RegExp(doromyoungRegExp2);
    RegExp regEx103 = RegExp(doromyoungRegExp3);
    RegExp regEx104 = RegExp(doromyoungRegExp4);
    RegExp regEx105 = RegExp(doromyoungRegExp5);

    RegExp regEx200 = RegExp(ZibunzoosoRegExp0);
    RegExp regEx201 = RegExp(ZibunzoosoRegExp1);
    RegExp regEx202 = RegExp(ZibunzoosoRegExp2);
    RegExp regEx203 = RegExp(ZibunzoosoRegExp3);


    for (TextBlock block in recognisedText2.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          for (int i = 0; i < chipList.length; i++) {
            for (TextElement element in line.elements) {
              if (RegExp(chipList[i].name).hasMatch(element.text)) {
                _elements2.add(element);
              }
            }
          }
        }
      }
    }

    for(TextBlock block in recognisedText2.blocks){
      for(TextLine line in block.lines){
        if(regEx5.hasMatch(line.text) &&C==true)
        {
          for(TextElement element in line.elements)
          {
            if(regEx200.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx201.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx202.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx203.hasMatch(element.text)){
              _elements2.add(element);
            }
          }
        }
      }
    }

    for(TextBlock block in recognisedText2.blocks){
      for(TextLine line in block.lines){
        if(regEx6.hasMatch(line.text) &&C==true)
        {
          for(TextElement element in line.elements)
          {
            if(regEx100.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx101.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx102.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx103.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx104.hasMatch(element.text)){
              _elements2.add(element);
            }
            if(regEx105.hasMatch(element.text)){
              _elements2.add(element);
            }
          }
        }
      }
    }

    print('여기서 멈추면 3');
    for (TextBlock block in recognisedText2.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements)
        {
          if (regEx.hasMatch(element.text)&&B==true)
          {
            print('핸드폰번호');
            _elements2.add(element);
          }
          if (regEx2.hasMatch(element.text)&&G==true)
          {
            print('이메일');
            _elements2.add(element);
          }
          if (regEx4.hasMatch(element.text)&&H==true)
          {
            print('주민번호');
            _elements2.add(element);
          }
          // if (regEx5.hasMatch(element.text)&&C==true)
          // {
          //   print('지번주소');
          //   _elements2.add(element);
          // }
          // if (regEx6.hasMatch(element.text)&&C==true)
          // {
          //   print('도로명주소');
          //   _elements2.add(element);
          // }
          if (regEx7.hasMatch(element.text)&&D==true)
          {
            print('운전면허');
            _elements2.add(element);
          }
          if (regEx8.hasMatch(element.text)&&E==true)
          {
            print('통장');
            _elements2.add(element);
          }
          if (regEx9.hasMatch(element.text)&&F==true)
          {
            print('카드');
            _elements2.add(element);
          }
        }
      }
    }

    BackgroundrecogniseNumber = _elements2.length+faceNumber2;

    print('_elements2.length+faceNumber2 = ');
    print(_elements2.length+faceNumber2);


    print('BackgroundrecogniseNumber');
    print(BackgroundrecogniseNumber);

    return BackgroundrecogniseNumber;
  }

  void getRecognisedFace(File image) async{
    final inputImage=InputImage.fromFilePath(image.path);

    File test = new File(image.path);
    var decodedImage = await decodeImageFromList(test.readAsBytesSync());
    imageWidth = decodedImage.width.toDouble();
    imageHeight = decodedImage.height.toDouble();

    if(Provider.of<Regex_model>(context,listen: false).isSwitched1==true) {
      final FaceDetector = GoogleMlKit.vision.faceDetector();
      recognisedface = await FaceDetector.processImage(inputImage);
      faceNumber = recognisedface.length;
      await FaceDetector.close();
    }

    final textDetector=GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText=await textDetector.processImage(inputImage);

    scannedText="";

    // List<EntityAnnotation> informationresult = await EntityExtractor(language: EntityExtractorLanguage.korean,).annotateText(scannedText,entityTypesFilter:filter );
    await textDetector.close();


    String email_pattern =
        r"^(([\w!-_\.])*@([\w!-_\.])*\.[\w]{2,3})$";

    String phoneNumber_pattern =
        r"^(?:(010-\d{4})|(01[1|6|7|8|9]-\d{3,4}))-(\d{4})$";

    // String Name_pattern =
    //     r'^[가-힣]{2,4}$';

    String zoominbunho =
        r'^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$';

    String Zibunzooso = r'([가-힣]{1,}시)?(\s)?([가-힣]{1,}구)?(\s)?([가-힣]{1,}로)(\s)?([^가-힣]{1,})';
    String ZibunzoosoRegExp0 = r'[가-힣]{1,}시';
    String ZibunzoosoRegExp1 = r'[가-힣]{1,}구';
    String ZibunzoosoRegExp2 = r'[가-힣]{1,}로';
    String ZibunzoosoRegExp3 = r'[^가-힣]{1,}';
    // r'^(([가-힣A-Za-z·\d~\-\.]+(읍|동)\s)[\d-]+)|(([가-힣A-Za-z·\d~\-\.]+(읍|동)\s)[\d][^시]+)$';

    // String sigudong = r'^(|[가-힣A-Za-z·\d~\-\.]{2,}(시))(\s)[가-힣A-Za-z·\d~\-\.]{2,}(구)(\s)[가-힣A-Za-z·\d~\-\.]{2,}(동)(\s)[가-힣A-Za-z·\d~\-\.]{2,}(아파트)(\s)[0-9]{0,3}(동)(\s)[가-힣A-Za-z·\d~\-\.]{2,}(호)$';

    // String sigudongapartment = r'^([가-힣]+(시|도))?(\s)[가-힣]+(구)?(\s)[가-힣]+(동)(\s)[가-힣]+(아파트)(\s)([0-9](동))?[0-9]+(호)$';

    // String dongapartment = r'^[가-힣]+(구)(\s)[가-힣]+(동)(\s)[가-힣]+(아파트)(\s)[0-9]+(호)$';

    // String apartment = r'^(([가-힣]+(아파트))( |)[0-9]{0,5}+(동|아파트)';
    String doromyoung = r'([가-힣]{1,}시)?(\s)?([가-힣]{1,}구)?(\s)?(([가-힣]{1,}동))?(\s)?(([가-힣]{1,}아파트)+)';
    String doromyoungRegExp0 = r'[가-힣]{1,}시';
    String doromyoungRegExp = r'[가-힣]{1,}동';
    String doromyoungRegExp2 = r'[가-힣]{1,}아파트';
    String doromyoungRegExp3 = r'[가-힣]{1,}구';
    String doromyoungRegExp4 = r'[\d]{1,}동';
    String doromyoungRegExp5 = r'[\d]{1,}호';
    // r'^([가-힣]{2,}(구))(\s+)([가-힣]{2,}동)';
    // r'^([가-힣]{2,}구)(\s)([가-힣]{2,}동)(\s)(\d{2,}아파트)(\s)(\d{2,}호)';

    // r'^([가-힣]+(\d{1,5}|\d{1,5}(,|.)\d{1,5}|))+(구)([가-힣]+(\d{1,5}|\d{1,5}(,|.)\d{1,5}|))+(동)([가-힣]+(\d{1,5}|\d{1,5}(,|.)\d{1,5}|))+(아파트)$';

    // r'^((([가-힣]+(\d{1,5}|\d{1,5}(,|.)\d{1,5}|)+(읍|면|동|가|리))(^구|)((\d{1,5}(~|-)\d{1,5}|\d{1,5})(가|리|)|))([](산(\d{1,5}(~|-)\d{1,5}|\d{1,5}))|)|(([가-힣]|(\d{1,5}(~|-)\d{1,5})|\d{1,5})+(로|길)))$';

    // r'^.{0,}(시).{0,}(구).{0,}(동)$';
    // r'^((([가-힣]+(\d{1,5}|\d{1,5}(,|.)\d{1,5}|)+(읍|면|동|가|리))(^구|)((\d{1,5}(~|-)\d{1,5}|\d{1,5})(가|리|)|))([](산(\d{1,5}(~|-)\d{1,5}|\d{1,5}))|)|(([가-힣]|(\d{1,5}(~|-)\d{1,5})|\d{1,5})+(로|길)))$';

    // r'(([가-힣A-Za-z·\d~\-\.]{2,}(로|길).[\d]+)|([가-힣A-Za-z·\d~\-\.]+(읍|동)\s)[\d]+)$';
    // r'(([가-힣A-Za-z·\d~\-\.]{2,}(동)\s)([가-힣A-Za-z·\d~\-\.]+(아파트)\s))|(([가-힣A-Za-z·\d~\-\.]+(동)\s)([가-힣A-Za-z·\d~\-\.]+(호)))$';
    // r'^(([가-힣]+(시|도))( |)[가-힣]+(시|군|구))';
    // r'^(([가-힣]+(d|d(,|.)d|)+(읍|면|동|가|리))(^구|)((d(~|-)d|d)(가|리|)|))([ ](산(d(~|-)d|d))|)|(([가-힣]|(d(~|-)d)|d)+(로|길))';
    // r'^((([가-힣]+(\d{1,5}|\d{1,5}(,|.)\d{1,5}|)+(읍|면|동|가|리))(^구|)((\d{1,5}(~|-)\d{1,5}|\d{1,5})(가|리|)|))([](산(\d{1,5}(~|-)\d{1,5}|\d{1,5}))|)|(([가-힣]|(\d{1,5}(~|-)\d{1,5})|\d{1,5})+(로|길)))$';

    // String kyudoro = r'^(([가-힣]+(\d{1,5}|d{1,5}(,|.)\d{1,5}|)+(시)[가-힣]+(\d{1,5}|d{1,5}(,|.)\d{1,5}|)+(구)[가-힣]+(\d{1,5}|d{1,5}(,|.)\d{1,5}|)+(동)';
    String woonjunmyunhu = r'^(\d{2}-\d{2}-\d{6}-\d{2})$';

    String tongjang = r"^(\d{2,6}[ -]-?\d{2,6}[ -]-?\d{2,6}[ -]-?\d{2,6})$";

    String card = r'^(\\d{4})-?(\\d{4})-?(\\d{4})-?(\\d{3,4})$';

    RegExp regEx = RegExp(phoneNumber_pattern);
    RegExp regEx2 = RegExp(email_pattern);
    // RegExp regEx3 = RegExp(Name_pattern);
    RegExp regEx4 = RegExp(zoominbunho);
    RegExp regEx5 = RegExp(Zibunzooso);
    RegExp regEx6 = RegExp(doromyoung);
    RegExp regEx7 = RegExp(woonjunmyunhu);
    RegExp regEx8 = RegExp(tongjang);
    RegExp regEx9 = RegExp(card);
    // RegExp regEx10 = RegExp(sigudong);
    // RegExp regEx11 = RegExp(sigudongapartment);
    // RegExp regEx12= RegExp(dongapartment);
    // RegExp regEx13 = RegExp(doromyoung);
    RegExp regEx100 = RegExp(doromyoungRegExp);
    RegExp regEx101 = RegExp(doromyoungRegExp0);
    RegExp regEx102 = RegExp(doromyoungRegExp2);
    RegExp regEx103 = RegExp(doromyoungRegExp3);
    RegExp regEx104 = RegExp(doromyoungRegExp4);
    RegExp regEx105 = RegExp(doromyoungRegExp5);

    RegExp regEx200 = RegExp(ZibunzoosoRegExp0);
    RegExp regEx201 = RegExp(ZibunzoosoRegExp1);
    RegExp regEx202 = RegExp(ZibunzoosoRegExp2);
    RegExp regEx203 = RegExp(ZibunzoosoRegExp3);


    if(Provider.of<Regex_model>(context, listen: false).isPr == true) {
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            for (int i = 0; i < chipList.length; i++) {
              for (TextElement element in line.elements) {
                if (RegExp(chipList[i].name).hasMatch(element.text)) {
                  _elements.add(element);
                }
              }
            }
          }
        }
      }
    }

    for(TextBlock block in recognisedText.blocks){
      for(TextLine line in block.lines){
        if(regEx5.hasMatch(line.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
        {
          for(TextElement element in line.elements)
          {
            if(regEx200.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx201.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx202.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx203.hasMatch(element.text)){
              _elements.add(element);
            }
          }
        }
      }
    }

    for(TextBlock block in recognisedText.blocks){
      for(TextLine line in block.lines){
        if(regEx6.hasMatch(line.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
        {
          for(TextElement element in line.elements)
          {
            if(regEx100.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx101.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx102.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx103.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx104.hasMatch(element.text)){
              _elements.add(element);
            }
            if(regEx105.hasMatch(element.text)){
              _elements.add(element);
            }
          }
        }
      }
    }


    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements)
        {
          if (regEx.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched2 == true)
          {
            print('핸드폰번호');
            _elements.add(element);
          }
          if (regEx2.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched7 == true)
          {
            print('이메일');
            _elements.add(element);
          }
          if (regEx4.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched8 == true)
          {
            print('주민번호');
            _elements.add(element);
          }
          // if (regEx5.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
          // {
          //   print('지번주소');
          //   _elements.add(element);
          // }
          // if (regEx6.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
          // {
          //   print('도로명주소');
          //   _elements.add(element);
          // }
          // // if (regEx11.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
          // {
          //   print('도로명주소');
          //   _elements.add(element);
          // }
          // if (regEx12.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
          // {
          //   print('도로명주소');
          //   _elements.add(element);
          // }
          // if (regEx10.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched3 == true)
          //   {
          //     print('sigudong');
          //     _elements.add(element);
          //   }
          if (regEx7.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched4 == true)
          {
            print('운전면허');
            _elements.add(element);
          }
          if (regEx8.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched5 == true)
          {
            print('통장');
            _elements.add(element);
          }
          if (regEx9.hasMatch(element.text) && Provider.of<Regex_model>(context, listen: false).isSwitched6 == true)
          {
            print('카드');
            _elements.add(element);
          }
        }
      }
    }

    ocrNumber=_elements.length;
    // print(_elements);
    textScanning=false;
    setState(() {

    });
  }

  Widget blurFace(int i){
    return Positioned(
      top: (bluredface[i].boundingBox.topRight.dy * size_height / imageHeight) + headerHeight,
      left: bluredface[i].boundingBox.topLeft.dx * size_width / imageWidth,
      child: BlurryContainer(
        width: bluredface[i].boundingBox.width *size_width / imageWidth,
        height: bluredface[i].boundingBox.height * size_height / imageHeight,
        child: Container(),
        color: Colors.white.withOpacity(0.10),
        blur: 5,
      ),
    );
  }
  Widget blurOCR(int i){
    return Positioned(
      top: (bluredOCR[i].boundingBox.topRight.dy * size_height / imageHeight) + headerHeight,
      left: bluredOCR[i].boundingBox.topLeft.dx * size_width / imageWidth,
      child: BlurryContainer(
        width: bluredOCR[i].boundingBox.width * size_width / imageWidth,
        height: bluredOCR[i].boundingBox.height * size_height / imageHeight,
        child: Container(),
        color: Colors.white.withOpacity(0.10),
        blur: 5,
      ),
    );
  }

  ///Save the edited-image to [widget.savePath] or [getTemporaryDirectory()].
  void SaveImage() {
    _panelController.takeShot.value = true;
    screenshotController.capture(pixelRatio: 1).then((value) async {
      final paths = widget.savePath ?? await getTemporaryDirectory();
      print(paths);
      final file = await File('${paths.path}/' + DateTime.now().toString() + '.jpg').create();
      file.writeAsBytes(value ?? []);
      decodeImg().then((value) {
        if (value == null) {
          Navigator.pop(context);
        } else {
          GallerySaver.saveImage(file.path);
          Navigator.push(
              context,
              MaterialPageRoute(builder:(context)=>ImagePicker(mode:1,maxCount: 10000)));
        }
      }).catchError((e) {
        Navigator.pop(context);
      });
    });
  }

  Future<ui.Image?> decodeImg() async {
    return await decodeImageFromList(widget.originImage.readAsBytesSync());
  }

  static ImageEditorState? of(BuildContext context) {
    return context.findAncestorStateOfType<ImageEditorState>();
  }


  @override
  void initState() {
    super.initState();
    initPainter();
    _panelController.switchOperateType(OperateType.brush);
    getRecognisedFace(widget.originImage);
    bluredface=[];
    bluredOCR=[];
    autoMosc=0;
  }


  @override
  Widget build(BuildContext context) {
    print(recognisedface);
    _panelController.screenSize ??= windowSize;
    return Material(
      color: Colors.white,
      child: Listener(
        onPointerMove: (v) {
          _panelController.pointerMoving(v);
        },
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Positioned.fromRect(
                  rect: Rect.fromLTWH(0, headerHeight, screenWidth, canvasHeight),
                  child: RotatedBox(
                    quarterTurns: rotateValue,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildImage(),
                      ],
                    ),
                  )),
              for (int i =0;i<bluredface.length;i++) blurFace(i),
              for (int i =0;i<bluredOCR.length;i++) blurOCR(i),
              Positioned.fromRect(
                rect: Rect.fromLTWH(0, headerHeight, screenWidth, canvasHeight),
                child: Container(
                    width: screenWidth,
                    height: canvasHeight,
                    color: Colors.transparent,
                    child: Listener(
                      onPointerMove: (event2){
                        print("working");
                        Face? targetFace;
                        TextElement? targetOCR;
                        for (int i =0;i<faceNumber;i++) {
                          if(i<recognisedface.length)
                          {
                            if(event2.localPosition.dx>(recognisedface[i].boundingBox.topLeft.dx * size_width / imageWidth)&&event2.localPosition.dx<(recognisedface[i].boundingBox.bottomRight.dx * size_width / imageWidth))
                            {
                              if(event2.localPosition.dy<(recognisedface[i].boundingBox.bottomRight.dy * size_height / imageHeight)&&event2.localPosition.dy>(recognisedface[i].boundingBox.topLeft.dy * size_height / imageHeight))
                              {
                                targetFace=recognisedface[i];
                                break;
                              }
                            }
                          }
                          else{
                            if(event2.localPosition.dx>(bluredface[i-recognisedface.length].boundingBox.topLeft.dx * size_width / imageWidth)&&event2.localPosition.dx<(bluredface[i-recognisedface.length].boundingBox.bottomRight.dx * size_width / imageWidth))
                            {
                              if(event2.localPosition.dy<(bluredface[i-recognisedface.length].boundingBox.bottomRight.dy * size_height / imageHeight)&&event2.localPosition.dy>(bluredface[i-recognisedface.length].boundingBox.topLeft.dy * size_height / imageHeight))
                              {
                                targetFace=bluredface[i-recognisedface.length];
                                break;
                              }
                            }

                          }
                        }
                        for (int i =0;i<ocrNumber;i++) {
                          if(i<_elements.length)
                          {
                            if(event2.localPosition.dx>(_elements[i].boundingBox.topLeft.dx * size_width / imageWidth)&&event2.localPosition.dx<(_elements[i].boundingBox.bottomRight.dx * size_width / imageWidth))
                            {
                              if(event2.localPosition.dy<(_elements[i].boundingBox.bottomRight.dy * size_height / imageHeight)&&event2.localPosition.dy>(_elements[i].boundingBox.topLeft.dy * size_height / imageHeight))
                              {
                                targetOCR=_elements[i];
                                break;
                              }
                            }
                          }
                          else{
                            if(event2.localPosition.dx>(bluredOCR[i-_elements.length].boundingBox.topLeft.dx * size_width / imageWidth)&&event2.localPosition.dx<(bluredOCR[i-_elements.length].boundingBox.bottomRight.dx * size_width / imageWidth))
                            {
                              if(event2.localPosition.dy<(bluredOCR[i-_elements.length].boundingBox.bottomRight.dy * size_height / imageHeight)&&event2.localPosition.dy>(bluredOCR[i-_elements.length].boundingBox.topLeft.dy * size_height / imageHeight))
                              {
                                targetOCR=bluredOCR[i-_elements.length];
                                break;
                              }
                            }

                          }
                        }
                        if(targetFace!=null){
                          if(event2.localPosition.dx>(targetFace.boundingBox.topLeft.dx * size_width / imageWidth)&&event2.localPosition.dx<(targetFace.boundingBox.bottomRight.dx * size_width / imageWidth))
                            if(event2.localPosition.dy>(targetFace.boundingBox.bottomRight.dy * size_height / imageHeight)&&event2.localPosition.dy<(targetFace.boundingBox.topLeft.dy * size_height / imageHeight))
                            {
                              eraseAccept=false;
                            }
                            else{
                              eraseAccept=true;
                            }

                          if(eraseAccept)
                          {
                            eraseAccept=false;
                            faceNumber=faceNumber-1;
                            setState(() {
                              recognisedface.remove(targetFace);
                              bluredface.remove(targetFace);
                              print("remove");
                            });

                          }
                        }
                        if(targetOCR!=null){
                          if(event2.localPosition.dx>(targetOCR.boundingBox.topLeft.dx * size_width / imageWidth)&&event2.localPosition.dx<(targetOCR.boundingBox.bottomRight.dx * size_width / imageWidth))
                            if(event2.localPosition.dy>(targetOCR.boundingBox.bottomRight.dy * size_height / imageHeight)&&event2.localPosition.dy<(targetOCR.boundingBox.topLeft.dy * size_height / imageHeight))
                            {
                              eraseAccept=false;
                            }
                            else{
                              eraseAccept=true;
                            }

                          if(eraseAccept)
                          {
                            eraseAccept=false;
                            ocrNumber=ocrNumber-1;
                            setState(() {
                              _elements.remove(targetOCR);
                              bluredOCR.remove(targetOCR);
                              print("remove");
                            });

                          }
                        }
                      },
                      // onPointerDown: (event){
                      //   for (int i =0;i<faceNumber;i++) {
                      //     if(i<recognisedface.length)
                      //     {
                      //       if(event.localPosition.dx>(recognisedface[i].boundingBox.topLeft.dx * size_width / imageWidth)&&event.localPosition.dx<(recognisedface[i].boundingBox.bottomRight.dx * size_width / imageWidth))
                      //       {
                      //         if(event.localPosition.dy<(recognisedface[i].boundingBox.bottomRight.dy * size_height / imageHeight)&&event.localPosition.dy>(recognisedface[i].boundingBox.topLeft.dy * size_height / imageHeight))
                      //         {
                      //           setState(() {
                      //             bluredface.add(recognisedface[i]);
                      //             recognisedface.remove(recognisedface[i]);
                      //           });
                      //           break;
                      //         }
                      //       }
                      //     }
                      //     else{
                      //       if(event.localPosition.dx>(bluredface[i-recognisedface.length].boundingBox.topLeft.dx * size_width / imageWidth)&&event.localPosition.dx<(bluredface[i-recognisedface.length].boundingBox.bottomRight.dx * size_width / imageWidth))
                      //       {
                      //         if(event.localPosition.dy<(bluredface[i-recognisedface.length].boundingBox.bottomRight.dy * size_height / imageHeight)&&event.localPosition.dy>(bluredface[i-recognisedface.length].boundingBox.topLeft.dy * size_height / imageHeight))
                      //         {
                      //           setState(() {
                      //             recognisedface.add(bluredface[i-recognisedface.length]);
                      //             bluredface.remove(bluredface[i-recognisedface.length+1]);
                      //           });
                      //           break;
                      //         }
                      //       }

                      //     }
                      //   }
                      //   for (int i =0;i<ocrNumber;i++) {
                      //     if(i<_elements.length)
                      //     {
                      //       if(event.localPosition.dx>(_elements[i].boundingBox.topLeft.dx * size_width / imageWidth)&&event.localPosition.dx<(_elements[i].boundingBox.bottomRight.dx * size_width / imageWidth))
                      //       {
                      //         if(event.localPosition.dy<(_elements[i].boundingBox.bottomRight.dy * size_height / imageHeight)&&event.localPosition.dy>(_elements[i].boundingBox.topLeft.dy * size_height / imageHeight))
                      //         {
                      //           setState(() {
                      //             bluredOCR.add(_elements[i]);
                      //             _elements.remove(_elements[i]);
                      //           });
                      //           break;
                      //         }
                      //       }
                      //     }
                      //     else{
                      //       if(event.localPosition.dx>(bluredOCR[i-_elements.length].boundingBox.topLeft.dx * size_width / imageWidth)&&event.localPosition.dx<(bluredOCR[i-_elements.length].boundingBox.bottomRight.dx * size_width / imageWidth))
                      //       {
                      //         if(event.localPosition.dy<(bluredOCR[i-_elements.length].boundingBox.bottomRight.dy * size_height / imageHeight)&&event.localPosition.dy>(bluredOCR[i-_elements.length].boundingBox.topLeft.dy * size_height / imageHeight))
                      //         {
                      //           setState(() {
                      //             _elements.add(bluredOCR[i-_elements.length]);
                      //             bluredOCR.remove(bluredOCR[i-_elements.length+1]);
                      //           });
                      //           break;
                      //         }
                      //       }

                      //     }
                      //   }
                      // },
                      child: Stack(children:[
                        Container(
                          width: screenWidth,
                          height: canvasHeight,
                          child: CustomPaint(
                            painter:BackgroundPainter(),
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          height: canvasHeight,
                          child: CustomPaint(
                            painter:BackgroundPainter2(_elements),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            _buildBrushCanvas(),
                            //buildTextCanvas(),
                          ],
                        ),
                      ]),
                    )
                ),
              ),
              // Positioned.fromRect(
              //   rect: Rect.fromLTWH(0,headerHeight,screenWidth,canvasHeight),
              //   child: Stack(
              //     alignment: Alignment.center,
              //     children: [
              //       _buildBrushCanvas(),
              //     ],
              //   ),),

              ValueListenableBuilder<bool>(
                  valueListenable: _panelController.showAppBar,
                  builder: (ctx, value, child) {
                    return AnimatedPositioned(
                        top: value ? 0 : -headerHeight,
                        left: 0, right: 0,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _panelController.takeShot,
                            builder: (ctx, value, child) {
                              return Opacity(
                                opacity: value ? 0 : 1,
                                child: AppBar(
                                  elevation: 0,
                                  iconTheme: IconThemeData(color: Colors.white, size: 16),
                                  leading: backWidget(),
                                  backgroundColor: Colors.transparent,
                                  actions: [
                                    doneButtonWidget(onPressed: SaveImage),
                                  ],
                                ),
                              );
                            }),
                        duration: _panelController.panelDuration);
                  }),
              ValueListenableBuilder<bool>(
                  valueListenable: _panelController.showBottomBar,
                  builder: (ctx, value, child) {
                    return AnimatedPositioned(
                        bottom: value ? 0 : -bottomBarHeight,
                        child: SizedBox(
                          width: screenWidth,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: _panelController.takeShot,
                              builder: (ctx, value, child) {
                                return Opacity(
                                  opacity: value ? 0 : 1,
                                  child: _buildControlBar(),
                                );
                              }),
                        ),
                        duration: _panelController.panelDuration);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      color: Colors.transparent,
      width: screenWidth,
      height: bottomBarHeight,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: windowBottomBarHeight),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child : _buildButton(OperateType.mosaic, '수동 모자이크', onPressed: () {
                    if(painterController.drawStyle!=DrawStyle.mosaic)
                    {
                      setState(() {
                        switchPainterMode(DrawStyle.mosaic);
                      });
                    }
                    else{
                      setState(() {
                        switchPainterMode(DrawStyle.non);
                      });
                    }
                  }
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [ Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child : _buildButton(OperateType.autoMasaic, '자동 모자이크', onPressed: () {
                  autoMosc=autoMosc+1;
                  print(autoMosc);
                  if(autoMosc%2==1)
                  {
                    for(int i=0;i<faceNumber;i++) {
                      bluredface.add(recognisedface[0]);
                      recognisedface.remove(recognisedface[0]);
                    }
                    for(int i=0;i<ocrNumber;i++) {
                      bluredOCR.add(_elements[0]);
                      _elements.remove(_elements[0]);
                    }
                    setState(() {
                    });
                  }
                  else{
                    for(int i=0;i<faceNumber;i++) {
                      recognisedface.add(bluredface[0]);
                      bluredface.remove(bluredface[0]);
                    }
                    for(int i=0;i<ocrNumber;i++) {
                      _elements.add(bluredOCR[0]);
                      bluredOCR.remove(bluredOCR[0]);
                    }
                    setState(() {
                    });
                  }
                }
                ),
              ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<OperateType>(
              valueListenable: _panelController.operateType,
              builder: (ctx, value, child) {
                return Opacity(
                  opacity: _panelController.show2ndPanel() ? 1 : 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child:
                          IconButton(onPressed:undo,
                            icon: Icon(Icons.arrow_back_ios),color: Colors.greenAccent,))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(flipValue),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Image.file(widget.originImage,fit: BoxFit.fill,height: double.infinity,width: double.infinity),
      ),
    );
  }

  Widget _buildTrashCan() {
    return ValueListenableBuilder<Color>(
        valueListenable: _panelController.trashColor,
        builder: (ctx, value, child) {
          final bool isActive = value.value == EditorPanelController.defaultTrashColor.value;
          return Container(
            width: _panelController.tcSize.width,
            height: _panelController.tcSize.height,
            decoration: BoxDecoration(
                color: value,
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Column(
              children: [
                12.vGap,
                Icon(Icons.delete_outline, size: 32, color: Colors.white,),
                4.vGap,
                Text(isActive ? 'move here for delete' : 'release to delete',
                  style: TextStyle(color: Colors.white, fontSize: 12),)
              ],
            ),
          );
        });
  }

  Widget _buildButton(OperateType type, String txt, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: () {
        if(_panelController.isCurrentOperateType(type))
        {
          _panelController.switchOperateType(OperateType.brush);
        }
        else{
          _panelController.switchOperateType(type);
        }
        onPressed?.call();
      },
      child: ValueListenableBuilder(
        valueListenable: _panelController.operateType,
        builder: (ctx, value, child) {
          return SizedBox(
            width: 71,
            height: 41,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getOperateTypeRes(type, choosen: _panelController.isCurrentOperateType(type)),
                Text(
                  txt,
                  style: TextStyle(
                      color: _panelController.isCurrentOperateType(type)
                          ? Colors.greenAccent : Colors.grey, fontSize: 11),
                )
              ],
            ),
          );
        },
      ),
    );
  }


}

///Little widget binding is for unified manage the widgets that has common style.
/// * If you wanna custom this part, see [ImageEditorDelegate]
mixin LittleWidgetBinding<T extends StatefulWidget> on State<T> {

  ///go back widget
  Widget backWidget({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () {
        Navigator.pop(context);
      },
      child: ImageEditor.uiDelegate.buildBackWidget(),
    );
  }

  ///operation button in control bar
  Widget getOperateTypeRes(OperateType type, {required bool choosen}) {
    return ImageEditor.uiDelegate.buildOperateWidget(type, choosen: choosen);
  }

  ///action done widget
  Widget doneButtonWidget({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: ImageEditor.uiDelegate.buildDoneWidget(),
    );
  }

  ///undo action
  Widget unDoWidget({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: ImageEditor.uiDelegate.buildUndoWidget(),
    );
  }

  ///Ignore pointer evenet by [OperateType]
  Widget ignoreWidgetByType(OperateType type, Widget child) {
    return ValueListenableBuilder(
        valueListenable: realState?._panelController.operateType ?? ValueNotifier(OperateType.non),
        builder: (ctx, type, c) {
          return IgnorePointer(
            ignoring: type != OperateType.brush && type != OperateType.mosaic,
            child: child,
          );
        });
  }

  ///reset button
  Widget resetWidget({VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: 6 , right: 16),
      child: ValueListenableBuilder<OperateType>(
        valueListenable: realState?._panelController.operateType ?? ValueNotifier(OperateType.non),
        builder: (ctx, value, child) {
          return Offstage(
            offstage: value != OperateType.rotated,
            child: GestureDetector(
              onTap: onTap,
              child: ImageEditor.uiDelegate.resetWidget,
            ),);
        },
      ),
    );
  }

}

///This binding can make editor to roatate canvas
/// * for now, the paint-path,will change his relative position of canvas
/// * when canvas rotated. because the paint-path area it's full canvas and
/// * origin image is not maybe. if force to keep the relative path, will reduce
/// * the paint-path area.
mixin RotateCanvasBinding<T extends StatefulWidget> on State<T> {

  ///canvas rotate value
  /// * 90 angle each time.
  int rotateValue = 0;

  ///canvas flip value
  /// * 180 angle each time.
  double flipValue = 0;

  ///flip canvas
  void flipCanvas() {
    flipValue = flipValue == 0 ? math.pi : 0;
    setState(() {});
  }

  ///routate canvas
  /// * will effect image, text, drawing board
  void rotateCanvasPlate() {
    rotateValue++;
    setState(() {});
  }

  ///reset canvas
  void resetCanvasPlate() {
    rotateValue = 0;
    setState(() {

    });
  }

}

///text painting
mixin TextCanvasBinding<T extends StatefulWidget> on State<T> {
  late StateSetter textSetter;

  final List<FloatTextModel> textModels = [];

  void addText(FloatTextModel model) {
    textModels.add(model);
    refreshTextCanvas();
  }

  ///delete a text from canvas
  void deleteTextWidget(FloatTextModel target) {
    textModels.remove(target);
    refreshTextCanvas();
  }

  void toTextEditorPage() {
    realState?._panelController.hidePanel();
    Navigator.of(context)
        .push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return TextEditorPage();
        }))
        .then((value) {
      realState?._panelController.showPanel();
      if (value is FloatTextModel) {
        addText(value);
      }
    });
  }

  void refreshTextCanvas() {
    textSetter.call(() {});
  }

  Widget buildTextCanvas() {
    return StatefulBuilder(builder: (tCtx, setter) {
      textSetter = setter;
      return Stack(
        alignment: Alignment.center,
        children: textModels
            .map<Widget>((e) => Positioned(
          child: _wrapWithGesture(
              FloatTextWidget(
                textModel: e,
              ),
              e),
          left: e.left,
          top: e.top,
        ))
            .toList(),
      );
    });
  }

  Widget _wrapWithGesture(Widget child, FloatTextModel model) {
    void pointerDetach(DragEndDetails? details) {
      if (details != null) {
        //touch event up
        realState?._panelController.releaseText(details, model, () {
          deleteTextWidget(model);
        });
      } else {
        //touch event cancel
        realState?._panelController.doIdle();
      }
      model.isSelected = false;
      refreshTextCanvas();
      realState?._panelController.showPanel();
    }

    return GestureDetector(
      child: child,
      onPanStart: (_) {
        realState?._panelController.moveText(model);
      },
      onPanUpdate: (details) {
        model.isSelected = true;
        model.left += details.delta.dx;
        model.top += details.delta.dy;
        refreshTextCanvas();
        realState?._panelController.hidePanel();
      },
      onPanEnd: (d) {
        pointerDetach(d);
      },
      onPanCancel: () {
        pointerDetach(null);
      },
    );
  }
}

///drawing board
mixin SignatureBinding<T extends StatefulWidget> on State<T> {

  DrawStyle get lastDrawStyle => painterController.drawStyle;

  ///Canvas layer for each draw action action.
  /// * e.g. First draw some path with white color, than change the color and draw some path again.
  /// * After this [pathRecord] will save 2 layes in it.
  final List<Widget> pathRecord = [];

  late StateSetter canvasSetter;

  ///painter stroke width.
  double pStrockWidth = 5;

  ///painter color
  Color pColor = Colors.transparent;

  ///painter controller
  late SignatureController painterController;

  @override
  void initState() {
    super.initState();
    pColor = Color(realState?._panelController.colorSelected.value ?? Colors.yellow.value);
  }

  ///switch painter's style
  /// * e.g. color、mosaic
  void switchPainterMode(DrawStyle style) {
    if(lastDrawStyle == style) return;
    changePainterColor(pColor);
    painterController.drawStyle = style;
  }

  ///change painter's color
  void changePainterColor(Color color) async {
    pColor = color;
    realState?._panelController.selectColor(color);
    pathRecord.insert(
        0,
        RepaintBoundary(
          child: CustomPaint(
              painter: SignaturePainter(painterController),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, minHeight: double.infinity, maxWidth: double.infinity, maxHeight: double.infinity),
              )),
        ));
    //savePath();
    initPainter();
    _refreshBrushCanvas();
  }

  void _refreshBrushCanvas() {
    pathRecord.removeLast();
    //add new layer.
    pathRecord.add(Signature(
      controller: painterController,
      backgroundColor: Colors.transparent,
    ));
    _refreshCanvas();
  }

  ///undo last drawing.
  void undo() {
    painterController.undo();
  }

  ///refresh canvas.
  void _refreshCanvas() {
    canvasSetter(() {});
  }

  void initPainter() {
    painterController = SignatureController(penStrokeWidth: pStrockWidth, penColor: pColor);
  }

  Widget _buildBrushCanvas() {
    if (pathRecord.isEmpty) {
      pathRecord.add(Signature(
        controller: painterController,
        backgroundColor: Colors.transparent,
      ));
    }
    return StatefulBuilder(builder: (ctx, canvasSetter) {
      this.canvasSetter = canvasSetter;
      return realState?.ignoreWidgetByType(OperateType.brush, Stack(
        children: pathRecord,
      )) ?? SizedBox();
    });
  }

  @override
  void dispose() {
    pathRecord.clear();
    super.dispose();
  }
}

mixin ScreenShotBinding<T extends StatefulWidget> on State<T> {
  final ScreenshotController screenshotController = ScreenshotController();
}

///information about window
mixin WindowUiBinding<T extends StatefulWidget> on State<T> {

  Size get windowSize => MediaQuery.of(context).size;

  double get windowStatusBarHeight => ui.window.padding.top;

  double get windowBottomBarHeight => ui.window.padding.bottom;

  double get screenWidth => windowSize.width;

  double get screenHeight => windowSize.height;

}

extension _BaseImageEditorState on State {
  ImageEditorState? get realState {
    if (this is ImageEditorState) {
      return this as ImageEditorState;
    }
    return null;
  }
}

///the color selected.
typedef OnColorSelected = void Function(Color color);

class CircleColorWidget extends StatefulWidget {
  final Color color;

  final ValueNotifier<int> valueListenable;

  final OnColorSelected onColorSelected;

  const CircleColorWidget({Key? key, required this.color, required this.valueListenable, required this.onColorSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CircleColorWidgetState();
  }
}

class CircleColorWidgetState extends State<CircleColorWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onColorSelected(widget.color);
      },
      child: ValueListenableBuilder<int>(
        valueListenable: widget.valueListenable,
        builder: (ctx, value, child) {
          final double size = value == widget.color.value ? 25 : 21;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: value == widget.color.value ? 4 : 2),
              shape: BoxShape.circle,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }


}