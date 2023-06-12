import 'package:flutter/material.dart';

abstract class Languages{
  static Languages of(BuildContext context){
    return Localizations.of(context, Languages);
  }
  String get appName;
  String get login;
  String get email;
  String get password;
  String get emailError;
  String get passError;
  String get emailEmpty;
  String get forgotPass;
  String get doLogin;
  String get signUp;
  String get donAccount;
  String get fullName;
  String get phone;
  String get close;
  String get nameEmpty;
  String get phoneEmpty;
  String get phoneError;
  String get passNotEqual;
  String get weakPass;
  String get alert;
  String get existEmail;
  String get wrongEmail;
  String get wrongPass;
  String get newClass;
  String get seeMore;
  String get comment;
  String get registerAdvise;
  String get enterContent;
  String get submitInfo;
  String get qa;
  String get whatsinyourmind;
  String get accountInfo;
  String get noData;
  String get hello;
  String get address;
  String get birthday;
  String get office;
  String get describeInfo;
  String get save;
  String get createCourse;
  String get createNew;
  String get idCourse;
  String get courseName;
  String get idTeacher;
  String get teacherName;
  String get addNewTeacher;
  String get addFailure;
  String get onSuccess;
  String get choseTeacher;
  String get choseId;
  String get idCourseEmpty;
  String get nameCourseEmpty;
  String get imageNull;
  String get myClass;
  String get classAdd;
  String get idClass;
  String get nameClass;
  String get describeClass;
  String get ready;
  String get pending;
  String get idClassEmpty;
  String get subjectEmpty;
  String get detailClass;
  String get editQuiz;
  String get editQuestion;
  String get addQuestion;
  String get createClassContent;
  String get idClassDetail;
  String get lessonName;
  String get idLesson;
  String get delete;
  String get nameClassEmpty;
  String get idLessonEmpty;
  String get nameLessonEmpty;
  String get info;
  String get lessonList;
  String get content;
  String get exercise;
  String get answer;
  String get discuss;
  String get linkExercise;
  String get question;
  String get askAQuestion;
  String get classroom;
  String get course;
  String get requireLogin;
  String get hourEmpty;
  String get startHours;
  String get time;
  String get monday;
  String get tuesday;
  String get wednesday;
  String get thursday;
  String get friday;
  String get saturday;
  String get sunday;
  String get schedule;
  String get teacher;
  String get registrationRequired;
  String get accessDenied;
  String get post;
  String get createPost;
  String get uQuestion;
  String get edit;
  String get choseImage;
  String get emptyContent;
  String get onFailure;
  String get submit;
  String get reply;
  String get result;
  String get resultCategory;
  String get feedback;
  String get document;
  String get createDoc;
  String get inputContent;
  String get member;
  String get fileEmpty;
  String get teacherInfo;
  String get specialize;
  String get level;
  String get confirm;
  String get nameRequired;
  String get photoRequired;
}