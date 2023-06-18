
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../common/keys.dart';

class CreateCoursePresenter{
  Future<bool> createCourse(File fileImage, String idCourse, String nameCourse, String nameTeacher, String idTeacher) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("${CommonKey.COURSE}/$idCourse/$nameCourse/image.jpg")
        .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async{
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
          String url = await getLinkAvatar(idCourse, nameCourse);
          FirebaseFirestore.instance
              .collection('course')
              .doc(idCourse)
              .set({
            "idCourse": idCourse,
            'name': nameCourse,
            'idTeacher': idTeacher,
            'teacherName': nameTeacher,
            'imageLink': url
          }).then((value) => true);
          break;
      }
    });
    return true;
  }

  Future<bool> updateCourse({File? fileImage, String? courseId, String? courseName, String? teacherName, String? teacherId, String? imageLink}) async{
    if(fileImage!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();
// Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef
          .child("${CommonKey.COURSE}/$courseId/$courseName/image.jpg")
          .putFile(fileImage, metadata);
// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async{
        switch (taskSnapshot.state){
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
            String url = await getLinkAvatar(courseId!, courseName!);
            update(courseId, courseName, teacherName, teacherId, url);
            break;
        }
      });
    }else{
      update(courseId, courseName, teacherName, teacherId, imageLink!);
    }
    return true;
  }

  void update(String? idCourse, String? nameCourse, String? nameTeacher, String? idTeacher, String linkImage){
    FirebaseFirestore.instance
        .collection('course')
        .doc(idCourse)
        .update({
      'name': nameCourse,
      'idTeacher': idTeacher,
      'teacherName': nameTeacher,
      'imageLink': linkImage
    });
  }

  Future<String> getLinkAvatar(String idCourse, String nameCourse) async{
    final ref = FirebaseStorage.instance.ref().child("${CommonKey.COURSE}/$idCourse/$nameCourse/image.jpg");
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }
}