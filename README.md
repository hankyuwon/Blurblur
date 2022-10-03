# K해커톤 코스믹팀 Blur Blur 프로젝트

하루하루 인터넷과의 연결이 가속화되는 현재...  
우리의 개인정보는 우리도 모르는 사이에 노출되고 있습니다.  
그래서 우리 코스믹팀은 개인정보가 노출된 사진을 찍거나 SNS에 업로드하기 전,  
**사용자에게 개인정보를 감지하여 통보**해주는 <blur blur> 앱을 만들었습니다.  
<br/><br/>

## blur blur 앱의 기능
### 1. 사진속 개인정보 탐지
사용자의 갤러리 내 **사진 속에 개인정보를 탐지**하는 기능입니다.  
<br/>
![KakaoTalk_20220822_190209010](https://user-images.githubusercontent.com/55169382/185896658-da327307-a0d2-438f-ace3-9dbbd4f72199.gif)
<br/><br/><br/><br/>


### 2. 개인정보 자동블러 처리
탐지된 개인정보에 대해 **일괄적으로 블러처리**를 할 수 있습니다.  
<br/>
![KakaoTalk_20220822_185621560](https://user-images.githubusercontent.com/55169382/185896211-54b4a501-0eef-44e9-914a-144c595da0bf.gif)
<br/><br/><br/><br/>

### 3. 개인정보 수동블러 처리
탐지되지 않은 개인정보(False Negative)나 개인정보가 아니더라도 숨기고 싶은 이미지의 경우, **사용자가 직접 블러처리**를 할 수 있습니다.  
<br/>
![KakaoTalk_20220822_185624023](https://user-images.githubusercontent.com/55169382/185896436-5e7b3064-b7bf-4965-a47d-f58231a75a4d.gif)
<br/><br/><br/><br/>

### 4. 선택적 블러 처리
개인정보가 아닌데 개인정보로 탐지한 경우(False Positive), 사용자가 화면을 드래그하여 **개인정보 탐지 박스를 지울 수 있습니다.**  
<br/>
![KakaoTalk_20220822_185624365](https://user-images.githubusercontent.com/55169382/185898003-5dd9aa06-e04e-45ab-94b7-1058e437d174.gif)
<br/><br/><br/><br/>


### 5. <추가예정> 실시간 카메라 개인정보 탐지 기능
카메라를 사용할 시, **개인정보가 감지가 되는지 바로바로 확인**할 수 있습니다.  
<br/>
![KakaoTalk_20220822_185627651](https://user-images.githubusercontent.com/55169382/185896542-24b68d50-11d0-4932-adc5-167edfffe0e7.gif)
<br/><br/><br/><br/>

### 6. <추가예정> 동영상 개인정보 감지 및 블러 처리 기능
사진 뿐만 아니라, 동영상에서도 개인정보 감지 및 블러 처리를 할 수 있습니다.
<br/><br/><br/><br/>

### 7. <추가예정> 음성 내 개인정보 감지 기능
사진과 동영상 뿐만 아니라, 음성에서도 개인정보 감지 및 블러 처리를 할 수 있습니다.
<br/><br/><br/><br/>


# K해커톤 Blur Blur <demo>


### 의존성 명시
**pubspec.yaml** 에
```
  gallery_saver: ^2.3.2
  cupertino_icons: ^1.0.2
  intl: ^0.17.0
  advance_image_picker: ^0.1.7+1
  image_editor_dove: ^0.0.2
  blurrycontainer: ^1.0.2
  google_ml_kit: ^0.12.0
  image_picker: ^0.8.5+3
  camera: ^0.9.7+1
  provider: ^6.0.3
  flutter_chip_tags: ^2.0.2
  flutter_chips_input: ^2.0.0
  shared_preferences: ^2.0.15
  flutter_inset_box_shadow: ^1.0.8
  
```
를 추가하세요

### 권한 설정
**android\app\src\main\AndroidManifest.xml** 에
```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="xxxxxxxx">
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <application
```
를 추가하세요.

### 수정 버전 패키지 적용방법
패키지를 저희 앱에 맞게 수정하여 사용하였으므로 **오리지널 패키지를 적용할 경우 작동하지 않을 수 있습니다.**  
따라서 수정된 패키지의 적용이 필요합니다.  
각각의 수정할 다트파일의 위치를 알려드리겠습니다.  
```
image_picker : 각자의 flutter 주소\.pub-cache\hosted\pub.dartlang.org\advance_image_picker-0.1.7+1\lib\widgets\picker
media_album : 각자의 flutter 주소\.pub-cache\hosted\pub.dartlang.org\advance_image_picker-0.1.7+1\lib\widgets\picker
image_picker_configs : 각자의 flutter 주소\.pub-cache\hosted\pub.dartlang.org\advance_image_picker-0.1.7+1\lib\configs
camera_controller : 각자의 flutter 주소\.pub-cache\hosted\pub.dartlang.org\camera-0.9.8+1\lib\src
scroll_controller : 각자의 flutter 주소\packages\flutter\lib\src\widgets
sliding_segmented_control : 각자의 flutter 주소\packages\flutter\lib\src\cupertino
image_editor : 각자의 flutter 주소\.pub-cache\hosted\pub.dartlang.org\image_editor_dove-0.0.2\lib
```


## 텍스트 감지 코드 실행법

### 파이어베이스 연동
코드를 실행하기 위해서 **파이어베이스 연동**이 필요합니다.  
https://www.youtube.com/watch?v=EXp0gq9kGxI  
다음 동영상을 참고(8:50 까지)하여 연동시켜주세요.  

### app 수준 build.gradle 수정
android>app>src>build.gradle에 들어가서 minSdkVersion을 21로 수정해주세요.  
```
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "xxxxxxxxxxxxx"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration.
        minSdkVersion 21
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
```

### 한국어 감지 설정
기본 감지설정이 영어로 되어있으므로 한국어로 수정해야 합니다.  
각자의 플러터주소\.pub-cache\hosted\pub.dartlang.org\google_ml_kit-0.12.0\lib\src  
안에있는 vision.dart의 47번째 줄
```
  TextRecognizer textRecognizer({script = TextRecognitionScript.latin}) {
    return TextRecognizer(script: script);
  }
```
에서 latin을 korean으로 수정시켜주세요.
