import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/screen/course/class_list.dart';
import 'package:online_learning/screen/course/create_course_ui.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/presenter/course_list_presenter.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/widgets.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';

class CourseList extends StatefulWidget {
  String? _role;
  String? _keyFlow;
  String? _username;

  CourseList(this._role, this._keyFlow, this._username);

  @override
  State<CourseList> createState() => _CourseListState(this._role, this._keyFlow, this._username);
}

class _CourseListState extends State<CourseList> {
  String? _role;
  String? _keyFlow;
  String? _username;
  Stream<QuerySnapshot>? _stream;
  CourseListPresenter? _presenter;
  _CourseListState(this._role, this._keyFlow, this._username);
  @override
  void initState(){
    _presenter = CourseListPresenter();
    if(CommonKey.TEACHER==widget._role){
      _stream = FirebaseFirestore.instance.collection('course').where('idTeacher', isEqualTo: widget._username).snapshots();
    }else{
      _stream = FirebaseFirestore.instance.collection('course').snapshots();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: getWidthDevice(context),
            height: 52,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.tabBar),
                fit: BoxFit.fill,
              ),
            ),
            child:
            Stack(
              fit: StackFit.expand,
              children: [
                Center(child: NeoText(CommonKey.HOME_PAGE==widget._keyFlow?'Khóa học':'', textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Positioned(child:  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),left: 0,)
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: Text('Loading'),);
                      }else if(snapshot.hasError){
                        return Center(child: Text('No data'),);
                      }
                      return Wrap(
                        children: snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
                          return (CommonKey.ADMIN==_role||CommonKey.TEACHER==_role)?itemCourseAdmin(context, data['name'], data['teacherName'], data['imageLink'],
                                  (onClickEdit) => Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateCourseUI(CommonKey.EDIT, data))),
                                  (onClickDelete) => _presenter!.deleteCourse(data['idCourse']),
                                  (click) => Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassList(CourseModel(data['idCourse'], data['idTeacher'], data['teacherName'], data['name']), _role,''))))
                              :itemCourse(context, data['name'], data['teacherName'], data['imageLink'], (id) => Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassList(CourseModel(data['idCourse'], data['idTeacher'], data['teacherName'], data['name']), _role,''))));
                        }).toList(),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: (CommonKey.ADMIN==_role||CommonKey.TEACHER==_role),
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateCourseUI('',null))),
          child: Icon(Icons.add,),
        ),
      ),
    );
  }
}