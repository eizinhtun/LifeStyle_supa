// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_crop/image_crop.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Image recongnition'),
  //       centerTitle: true,
  //     ),
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         const SizedBox(
  //           height: 25.0,
  //         ),
  //         // _buildCroppingImage(),
  //         // _sample == null ? _buildOpeningImage() : _buildCroppingImage(),
  //         // const SizedBox(
  //         //   height: 25.0,
  //         // ),
  //         imagePath != null && imagePath != ""
  //             ? Center(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     // Crop(
  //                     //   key: cropKey,
  //                     //   image: Image.file(imageFile),
  //                     //   aspectRatio: 4.0 / 3.0,
  //                     // ),
  //                     _sample == null
  //                         ? _buildOpeningImage()
  //                         : _buildCroppingImage(),
  //                     // Padding(
  //                     //     padding: const EdgeInsets.symmetric(
  //                     //         horizontal: 8.0, vertical: 4.0),
  //                     //     child: Crop.file(
  //                     //       imageFile,
  //                     //       key: cropKey,
  //                     //     )),
  //                     const SizedBox(
  //                       height: 15.0,
  //                     ),
  //                     ElevatedButton(
  //                       child: Text("Get another image"),
  //                       onPressed: () async {
  //                         if (state == ImageState.free)
  //                           await _pickImage(context);
  //                         // else if (state == ImageState.picked)
  //                         //   _cropImage(imagePath);
  //                         else if (state == ImageState.cropped) _clearImage();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             : Center(
  //                 child: ElevatedButton(
  //                   child: Text("Upload image"),
  //                   onPressed: () async {
  //                     if (state == ImageState.free)
  //                       await _pickImage(context);
  //                     // else if (state == ImageState.picked)
  //                     //   _cropImage(imagePath);
  //                     else if (state == ImageState.cropped) _clearImage();
  //                   },
  //                 ),
  //               ),
  //         const SizedBox(
  //           height: 15.0,
  //         ),
  //         imagePath != null && imagePath != ""
  //             ? Center(
  //                 child: ElevatedButton(
  //                   onPressed: (imagePath == null)
  //                       ? null
  //                       : () {
  //                           getText();
  //                         },
  //                   child: const Text('Get text'),
  //                 ),
  //               )
  //             : Text(""),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: SafeArea(
  //       child: Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Image recongnition'),
  //           centerTitle: true,
  //         ),
  //         body: Column(
  //           children: [
  //             Container(
  //               color: Colors.black,
  //               padding: const EdgeInsets.symmetric(
  //                   vertical: 40.0, horizontal: 20.0),
  //               child: _sample == null
  //                   ? _buildOpeningImage
  //                   : _buildCroppingImage(),
  //             ),
  //             const SizedBox(
  //               height: 15.0,
  //             ),
  //             ElevatedButton(
  //               child: Text("Get another image"),
  //               onPressed: () async {
  //                 if (state == ImageState.free) await _pickImage(context);
  //                 // else if (state == ImageState.picked)
  //                 //   _cropImage(imagePath);
  //                 //  else if (state == ImageState.cropped) _clearImage();
  //               },
  //             ),
  //             const SizedBox(
  //               height: 15.0,
  //             ),
  //             imagePath != null && imagePath != ""
  //                 ? Center(
  //                     child: ElevatedButton(
  //                       onPressed: (imagePath == null)
  //                           ? null
  //                           : () {
  //                               getText();
  //                             },
  //                       child: const Text('Get text'),
  //                     ),
  //                   )
  //                 : Text(""),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: SafeArea(
  //       child: Container(
  //         color: Colors.black,
  //         padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
  //         child: _sample == null ? _buildOpeningImage() : _buildCroppingImage(),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text From Image"),
      ),
      body: Center(
        child: imageFile != null ? Image.file(imageFile) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == ImageState.free) _pickImage(context);
          // else if (state == ImageState.picked)
          //   _cropImage();
          // else if (state == ImageState.cropped) _clearImage();
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

  Widget _buildOpeningImage() {
    return Center(child: _buildOpeningImage());
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(_sample, key: cropKey),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  'Crop Image',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white),
                ),
                onPressed: () => _cropImage2(),
              ),
              _buildOpenImage(),
            ],
          ),
        )
      ],
    );
  }

  _pickImage(BuildContext context) async {
    ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    File imageFile = File(image.path);
    if (imageFile != null) {
      print(imageFile.path);
      await _cropImage(imageFile.path);
      // await _cropImage2();
      setState(() {
        imagePath = imageFile.path;
        state = ImageState.picked;
      });
      // await _cropImage(imageFile.path);
    }
  }

  Future<List<RecognizedText>> getText() async {
    // final inputImage = InputImage.fromFilePath(path);
    final inputImage = InputImage.fromFile(imageFile);
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

  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped;

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  Widget _buildOpenImage() {
    return TextButton(
      child: Text(
        'Open Image',
        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
      ),
      onPressed: () => _openImage(),
    );
  }

  Future<void> _openImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final file = File(pickedFile.path);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size.longestSide.ceil(),
    );

    _sample?.delete();
    _file?.delete();

    setState(() {
      _sample = sample;
      _file = file;
    });
  }

  Future<void> _cropImage2() async {
    // final scale = cropKey.currentState.scale;
    // final area = cropKey.currentState.area;

    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _file,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    imageFile = file;
    setState(() {
      state = ImageState.cropped;
    });
    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint('$file');
  }

  Future<Null> _cropImage(String path) async {
    print(path);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: CropAspectRatio(ratioX: 0.5, ratioY: 0.5),
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
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
