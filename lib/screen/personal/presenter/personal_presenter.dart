import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../common/functions.dart';
import '../../../common/keys.dart';
import '../../../storage/storage.dart';

class ProfilePresenter{
  Map<String, dynamic>? user;
  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.getData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }
  bool updateProfile(String keyUser , String fullname, String address, String dob, String intro, String exp, String specialize){
    FirebaseFirestore.instance
        .collection('users')
        .doc(keyUser)
        .update({
      'fullname': fullname,
      'address': address,
      'dob': dob,
      'intro': intro,
      'exp':exp,
      'specialize':specialize
    }).onError((error, stackTrace) => false);
    return true;
  }

  Future<bool> updateAvatar(File fileImage, String keyUser, String folder) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("$keyUser/$folder/$keyUser.jpg")
        .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads

          break;
        case TaskState.success:
        // Handle successful uploads on complete

          break;
      }
    });


    final ref = FirebaseStorage.instance.ref().child("$keyUser/$folder/$keyUser.jpg");
    String url = (await ref.getDownloadURL()).toString();
    FirebaseFirestore.instance.collection('users').doc(keyUser)
        .update({
      'avatar': url
    });
    return true;
  }
}