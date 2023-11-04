import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uId) async {
    UserModel? userModel;

    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();

    if(docSnapshot!=null){
      userModel = UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    }

    return userModel;
  }
}
