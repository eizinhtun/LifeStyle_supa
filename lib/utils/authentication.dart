// @dart=2.9
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';


class Authentication {
  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;



    return firebaseApp;
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<User> signInWithFacebook({BuildContext context}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final OAuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken.token);
          final userCredential =
              await _auth.signInWithCredential(facebookCredential);
          user = userCredential.user;
          return user;
        //User(status: Status.Success);
        // case LoginStatus.cancelled:
        //   return Resource(status: Status.Cancelled);
        // case LoginStatus.failed:
        //   return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
  static Future<String> uploadphotofile(imageFile) async {
    var user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance.ref('profile').child(user.uid);
    final uploadTask = ref.putFile(File(imageFile.path));
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    if (downloadUrl != null) {
      user.updatePhotoURL(downloadUrl);
      return downloadUrl;
    } else {
      return '';
    }
  }
  static Future<String> uploadphotofilegallery() async {
    var user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final ref = FirebaseStorage.instance.ref('profile').child(user.uid);
    final uploadTask = ref.putFile(File(pickedFile.path));
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    if (downloadUrl != null) {
      user.updatePhotoURL(downloadUrl);
      return downloadUrl;
    } else {

      return '';
    }
  }

  static Future<String> uploadphotofilecamera() async {
    var user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final ref = FirebaseStorage.instance.ref('profile').child(user.uid);

    final uploadTask = ref.putFile(File(pickedFile.path));
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    if (downloadUrl != null) {
      user.updatePhotoURL(downloadUrl);
      return downloadUrl;
    } else {
      return '';
    }
  }

}
