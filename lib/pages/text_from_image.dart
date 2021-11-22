// @dart=2.9
// import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:left_style/models/recognized_text.dart';
// import 'package:left_style/widgets/my_image_cropper.dart';
// import 'package:left_style/widgets/my_image_cropper_options.dart';

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
    super.initState();
    state = ImageState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text From Image"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: imageFile != null
          //       ? Image.file(
          //           imageFile,
          //           scale: 1.0,
          //           width: 50,
          //           height: 50,
          //           fit: BoxFit.fill,
          //         )
          //       : Container(),
          // ),
          Column(
            children: tlist.map((t) => Text(t.block)).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        // Colors.deepOrange,
        onPressed: () {
          if (state == ImageState.free)
            _pickImage(context, ImageSource.gallery);
          // else if (state == ImageState.picked)
          //   _cropImage();
          else if (state == ImageState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == ImageState.free)
      return Icon(Icons.add);
    else if (state == ImageState.picked)
      return Icon(Icons.crop);
    else if (state == ImageState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  _pickImage(BuildContext context, ImageSource source) async {
    ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: source);
    File imageFile = File(image.path);
    if (imageFile != null) {
      print(imageFile.path);

      await _cropImage(imageFile.path);
      setState(() {
        imagePath = imageFile.path;
        state = ImageState.picked;
      });
    }
  }

  Future<List<RecognizedText>> getText() async {
    final inputImage = InputImage.fromFile(imageFile);
    final textDetector = GoogleMlKit.vision.textDetector();
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

  List<RecognizedText> tlist = [];
  Future<Null> _cropImage(String path) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: CropAspectRatio(ratioX: 10, ratioY: 1),
        // maxHeight: 10,
        // maxWidth: 10,
        cropStyle: CropStyle.rectangle,
        // compressFormat: ImageCompressFormat.png,
        // compressQuality: 60,

        aspectRatioPresets: Platform.isAndroid
            ? [
                // CropAspectRatioPreset.values

                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio10x1,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
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
            toolbarColor: Theme.of(context).primaryColor,
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            // Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio:
                // CropAspectRatioPreset.ratio10x1,
                CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = ImageState.cropped;
      });
      tlist = await getText();
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
