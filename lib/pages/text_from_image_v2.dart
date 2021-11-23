// @dart=2.9
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:left_style/models/recognized_text.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class TextFromImageV2 extends StatefulWidget {
  const TextFromImageV2({Key key}) : super(key: key);
  @override
  _TextFromImageV2State createState() => new _TextFromImageV2State();
}

class _TextFromImageV2State extends State<TextFromImageV2> {
  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped;
  ImageState state;
  String text;
  String langName = 'eng';

  @override
  void initState() {
    super.initState();
    state = ImageState.free;
    // getLangData();
  }

//   getLangData() async {
//     //---- dynamic add Tessdata (Android)---- ▼
// // https://github.com/tesseract-ocr/tessdata/raw/main/dan_frak.traineddata

  //   HttpClient httpClient = new HttpClient();

  //   HttpClientRequest request = await httpClient.getUrl(Uri.parse(
  //       'https://github.com/tesseract-ocr/tessdata/raw/main/${langName}.traineddata'));

  //   HttpClientResponse response = await request.close();
  //   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = await FlutterTesseractOcr.getTessdataPath();

  //   print('$dir/${langName}.traineddata');
  //   File file = new File('$dir/${langName}.traineddata');
  //   await file.writeAsBytes(bytes);
  // }

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  File tempFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text From Image"),
      ),
      body: state == ImageState.cropped
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                (cropFile != null) ? Image.file(cropFile) : Text("No"),
                SizedBox(
                  height: 20,
                ),
                (tempFile != null) ? Image.file(tempFile) : Text("No Temp"),
                _buildOpeningImage(),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children:
                      // [Text("text")],
                      tlist.map((t) => Text(t.block)).toList(),
                ),
              ],
            )
          : Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: !(state == ImageState.cropped) && _sample == null
                  ? _buildOpeningImage()
                  : _buildCroppingImage(),
            ),
    );
  }

  Widget _buildOpeningImage() {
    return Center(child: _buildOpenImage());
  }

  Widget _buildCroppingImage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Crop.file(
            _sample,
            key: cropKey,
            scale: 1.0,
            aspectRatio: 5,
            maximumScale: 2,
            alwaysShowGrid: true,
            // onImageError: (_, _) {},
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                  child: Text(
                    'Crop Image',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () async {
                    await _cropImage();
                  }),
              ElevatedButton(
                child: Text(
                  "OK",
                  // 'Crop Image',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
                onPressed: () async {
                  await _lastCropped?.delete();
                  //print(fs?.path);
                  // _lastCropped = cropFile;

                  print(cropFile != null);
                  if (cropFile != null) {
                    // img.Image image =
                    //     img.decodeImage(cropFile.readAsBytesSync());
                    // img.Image thumbnail =
                    //     img.copyResize(image, width: 120, height: 120);
                    // final directory = await getApplicationDocumentsDirectory();
                    // tempFile = File('${directory.path}/testImage.png')
                    // ..writeAsBytesSync(img.encodePng(thumbnail));

                    // await getText(tempFile);

                    final byteData = await cropFile.readAsBytes();

                    // final Uint8List pngBytes = byteData.buffer.asUint8List();
                    img.Image image =
                        img.decodeImage(cropFile.readAsBytesSync());
                    img.Image thumbnail =
                        img.copyResize(image, width: 480, height: 120);
                    final directory = await getApplicationDocumentsDirectory();
                    tempFile = File('${directory.path}/testImage.png')
                      ..writeAsBytesSync(img.encodePng(thumbnail));
                    await getText(tempFile);

                    // cropFile=cropFile.
                    // tlist = await getText(cropFile);
                    // tlist = await getText(sample);
                    // tlist = await getText(_file);

                    // await getText(sample);
                    // await getText(cropFile);

                    setState(() {
                      state = ImageState.cropped;
                    });
                  }
                },
              ),
              _buildOpenImage(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOpenImage() {
    return ElevatedButton(
      child: Text(
        'Open Image',
        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
      ),
      onPressed: () async {
        await _openImage(ImageSource.gallery);
      },
    );
  }

  Future<void> _openImage(ImageSource source) async {
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (file != null) {
        sample = await ImageCrop.sampleImage(
          file: file,
          preferredSize: context.size.longestSide.ceil(),
        );
        _sample?.delete();
        _file?.delete();

        setState(() {
          _sample = sample;
          _file = file;
        });

        // left=pickedFile.
        // if (_file != null) {
        //   Future.delayed(Duration(milliseconds: 1000), () async {
        //     await _cropImage();
        //   });
        //   // WidgetsBinding.instance.addPostFrameCallback((_) async {
        //   //   await _cropImage();
        //   // });
        // }
        // await _cropImage();
      }
    }
  }

  double left, top, right, bottom = 100;

  File cropFile;
  File sample;
  Future<void> _cropImage() async {
    // final scale = crop.scale;
    // final area = crop.area;
    if (cropKey.currentState != null) {
      final scale = cropKey.currentState.scale;
      final area1 = cropKey.currentState.area;
      final area = cropKey.currentState.area;
      print("Area");
      print(area1.left);
      print(area1.top);
      print(area1.right);
      print(area1.bottom);
      // print(scale);
      // print(area);

      // final scale = 1.0;
      // final area = Rect.fromLTRB(200, 200, 200, 200);

      if (area == null) {
        // cannot crop, widget is not setup
        return;
      }

      // scale up to use maximum possible number of pixels
      // this will sample image in higher resolution to make cropped image larger
      sample = await ImageCrop.sampleImage(
        file: _file,
        preferredSize: (2000 / scale).round(),
      );
      print("Sample");
      print(sample.path);

      cropFile = await ImageCrop.cropImage(
        file: sample,
        area: area,
        scale: scale,
      );

//  var modifiedImage = CodePainter(qrImage:copyFile ,margin: 16);
      print("Area After 1");
      print(area.left);
      print(area.top);
      print(area.right);
      print(area.bottom);
      sample.delete();
      print("Crop");
      print(cropFile.path);
      // print(cropFile.)

      // _lastCropped?.delete();
      // _lastCropped = cropFile;

      // if (_lastCropped != null) {
      //   getText(_lastCropped);
      //   // setState(() {
      //   //   state = ImageState.cropped;
      //   // });
      // }

      debugPrint('$cropFile');
    }
  }

  List<RecognizedText> tlist = [];
  Future<List<RecognizedText>> getText(File file) async {
    final byteData = await file.readAsBytes();
    final Uint8List bytes = byteData.buffer.asUint8List();
    final inputImage = InputImage.
        //fromBytes(bytes: bytes, inputImageData: InputImageData());
        fromFile(file);
    print(inputImage.bytes);

    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    print(recognisedText);
    List<RecognizedText> recognizedList = [];
    for (TextBlock block in recognisedText.blocks) {
      print(block.text);
      recognizedList.add(
          RecognizedText(lines: block.lines, block: block.text.toLowerCase()));
      print(recognizedList.length);
    }
    return recognizedList;
  }

  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    return image;
  }
}

enum ImageState {
  free,
  picked,
  cropped,
}
