import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:left_style/constants.dart';

class Services {

  FirebaseAuth _auth = FirebaseAuth.instance;

  // Create Anonymous User

  Future<String> signInAnon() async {
    try {
      //firebaseAdmin.auth().createCustomToken(uid)
      var token="cqXmm_7Bnuw:APA91bEIePWdcpnQ1bnfLbXpDs6E_HW20V2qcAENBO2Z3FRQ8crfChBu6hjilM0zpHBgZIuaAMghK-qC2QbKjAA7SHq9RLeNBvJy3CJsH6M_pXB2OJQ9GDrJP1MHRAnr-ryB4OEDwytZ";//Firebase..createCustomToken("09789193592");//_auth.createCustomToken("09789193592");
      final result = await _auth.signInWithCustomToken(token);

      return result.user!.uid;
    } catch (e) {
      print(e);
    }
    return "";
  }

}
