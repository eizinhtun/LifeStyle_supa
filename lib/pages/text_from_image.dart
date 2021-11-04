// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/recognized_text.dart';

class TextFromImage extends StatefulWidget {
  const TextFromImage({Key key}) : super(key: key);

  @override
  _TextFromImageState createState() => _TextFromImageState();
}

class _TextFromImageState extends State<TextFromImage> {
  String imagePath = "";
  ImageState state;
  File imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    state = ImageState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image recongnition'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25.0,
          ),
          imagePath != null && imagePath != ""
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Image.file(
                          File(imagePath),
                          width: 350,
                          height: 400,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                        child: Text("Get another image"),
                        onPressed: () async {
                          if (state == ImageState.free)
                            await _pickImage(context);
                          // else if (state == ImageState.picked)
                          // jake
                          else if (state == ImageState.cropped) _clearImage();
                        },
                      ),
                    ],
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    child: Text("Upload image"),
                    onPressed: () async {
                      if (state == ImageState.free)
                        await _pickImage(context);
                      else if (state == ImageState.picked)
                        _cropImage();
                      else if (state == ImageState.cropped) _clearImage();
                    },
                  ),
                ),
          const SizedBox(
            height: 15.0,
          ),
          imagePath != null && imagePath != ""
              ? Center(
                  child: ElevatedButton(
                    onPressed: (imagePath == null)
                        ? null
                        : () {
                            getText(imagePath);
                          },
                    child: const Text('Get text'),
                  ),
                )
              : Text(""),
        ],
      ),
    );
  }

  _pickImage(BuildContext context) async {
    ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: ImageSource.gallery)) as File;
    if (imageFile != null) {
      _cropImage();
      setState(() {
        imagePath = imageFile.path;
        state = ImageState.picked;
      });
    }
  }

  Future<List<RecognizedText>> getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    // final RecognisedText recognisedText =
    //     await textDetector.processImage(inputImage);
    // List<RecognizedText> recognizedList = [];
    // for (TextBlock block in recognisedText.blocks) {
    //   recognizedList.add(
    //       RecognizedText(lines: block.lines, block: block.text.toLowerCase()));
    // }

    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    List<RecognizedText> recognizedList = [];
    for (TextBlock block in recognisedText.blocks) {
      print(block.text);

      recognizedList.add(
          RecognizedText(lines: block.lines, block: block.text.toLowerCase()));

      print(recognizedList.length);
    }

    return recognizedList;
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = ImageState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = ImageState.free;
    });
  }
}

enum ImageState {
  free,
  picked,
  cropped,
}
