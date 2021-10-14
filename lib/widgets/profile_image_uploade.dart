import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import 'CommonExampleRouteWrapper.dart';

class UploadProfileImage extends StatefulWidget {
  const UploadProfileImage({Key? key}) : super(key: key);

  @override
  _UploadProfileImageState createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    PickedFile? pickedImage;
    try {
      pickedImage = await picker.getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'A bad guy',
              'description': 'Some description...'
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () => _upload('camera'),
                    icon: Icon(Icons.camera),
                    label: Text('camera')),
                ElevatedButton.icon(
                    onPressed: () => _upload('gallery'),
                    icon: Icon(Icons.library_add),
                    label: Text('Gallery')),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            dense: false,
                            leading: Image.network(image['url']),
                            title: Text(image['uploaded_by']),
                            subtitle: Text(image['description']),
                            trailing: IconButton(
                              onPressed: () => _delete(image['path']),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  //@override
  // Widget build(BuildContext context) {
  //   return Container();
  // }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage(
      {Key? key,
      required this.imageurl,
      this.onChanged,
      this.width = 100,
      this.height = 100,
      this.borderColor = Colors.white})
      : super(key: key);
  final String imageurl;
  final ValueChanged<String>? onChanged;
  final double width, height;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (imageurl != null && imageurl.length > 0) {
          var newImageUrl = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommonExampleRouteWrapper(
                imageProvider: NetworkImage(
                  imageurl,
                ),
              ),
            ),
          );

          if (newImageUrl == null) {
            onChanged!(
                "https://image.freepik.com/free-vector/honey-comb-cartoon-vector-icon-illustration-food-nature-icon-concept-isolated-premium-vector-flat-cartoon-style_138676-3660.jpg");
          }
        }
      },
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageurl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.0),
            borderRadius: new BorderRadius.all(const Radius.circular(80.0)),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ), /* Container(
          height: height,
          width: width,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: CachedNetworkImageProvider(imageurl),
              fit: BoxFit.cover,
            ),
            border:
            Border.all(color: borderColor, width: 1.0),
            borderRadius:
            new BorderRadius.all(const Radius.circular(80.0)),
          ),
      )*/
    );
  }
}
