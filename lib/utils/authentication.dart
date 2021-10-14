import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:left_style/pages/user_info_screen.dart';
import 'package:left_style/widgets/user-info_screen_photo.dart';

class Authentication {


  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

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

      final GoogleSignInAccount? googleSignInAccount =
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

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<User?> signInWithFacebook(
      {required BuildContext context}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
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

  static Future<String?> updatePhoto() async{
   String? url="";
    var user = FirebaseAuth.instance.currentUser;
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource. gallery);
       var link= FirebaseStorage.instance.ref("profile/"+user!.uid).putFile(File(pickedFile!.path))
            .then((TaskSnapshot taskSnapshot) {
          if (taskSnapshot.state == TaskState.success) {
           taskSnapshot.ref.getDownloadURL().then(
                    (imageURL) {
                      // print(imageURL.toString());
                      user.updatePhotoURL(imageURL.toString());
                   url=imageURL.toString();
                   return url;

                });
          }
          // else if (taskSnapshot.state == TaskState.running) {
          //  print("Running");
          // }
          // else if (taskSnapshot.state == TaskState.error) {
          //   print("Error");
          // }

        });


        // var ref = FirebaseStorage.instance.ref("profile/"+user.uid);
        // String? url=await ref.getDownloadURL();




  }

  static Future<String> uploadphotofile() async {
    var user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource. gallery);
    final ref = FirebaseStorage.instance
        .ref('profile')
        .child(user!.uid);

    final uploadTask = ref.putFile(File(pickedFile!.path));
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    if(downloadUrl != null){
      user.updatePhotoURL(downloadUrl);
      return downloadUrl;
    }else{
      return '';
    }


  }
  static Future<String> uploadphotofilecamera() async {
    var user = FirebaseAuth.instance.currentUser;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource. camera);
    final ref = FirebaseStorage.instance
        .ref('profile')
        .child(user!.uid);

    final uploadTask = ref.putFile(File(pickedFile!.path));
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    if(downloadUrl != null){
      user.updatePhotoURL(downloadUrl);
      return downloadUrl;
    }else{
      return '';
    }


  }

}
