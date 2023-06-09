import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_learning/common/colors.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/course/model/course_model.dart';
import 'package:online_learning/screen/course/model/my_class_model.dart';
import 'package:online_learning/screen/schedule/presenter/schedule_presenter.dart';
import 'package:online_learning/screen/animation_page.dart';
import '../../../external/switch_page_animation/enum.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../common/functions.dart';
import '../../common/keys.dart';
import '../../common/state.dart';
import '../../languages/languages.dart';
import '../../res/images.dart';
import '../../storage/storage.dart';
import '../course/class_detail.dart';

class Schedule extends StatefulWidget {
  String? _role;

  Schedule(this._role);


  @override
  State<Schedule> createState() => _ScheduleState(_role);
}

class _ScheduleState extends State<Schedule> {
  String _dateNow='';
  String _dayName= '';
  List<MyClassModel> _myClass = [];
  String? _role;

  _ScheduleState(this._role);

  SchedulePresenter? _presenter;
  @override
  void initState() {
    _presenter = SchedulePresenter();
    _getData();
    _dateNow = getDateNow();
    _dayName = getNameDateNow();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8,),
                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: AppColors.ultraRed,)),
                SizedBox(width: 8,),
                Expanded(child: NeoText(_role=='MEMBER'?Languages.of(context).schedule:'Lịch dạy', textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                SizedBox(width: 52,)
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_){
                if(_presenter!.state==SingleState.LOADING){
                  return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),);
                }else if(_presenter!.state==SingleState.NO_DATA){
                  return Center(child: Text('No data...'),);
                }else{
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: getHeightDevice(context)/8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 2,),
                            _dayItems(CommonKey.Monday,getDateWeek(1)),
                            _dayItems(CommonKey.Tuesday,getDateWeek(2)),
                            _dayItems(CommonKey.Wednesday,getDateWeek(3)),
                            _dayItems(CommonKey.Thursday,getDateWeek(4)),
                            _dayItems(CommonKey.Friday,getDateWeek(5)),
                            _dayItems(CommonKey.Saturday,getDateWeek(6)),
                            _dayItems(CommonKey.Sunday,getDateWeek(7)),
                            SizedBox(width: 2,)
                          ],
                        ),
                      ),
                      Container(

                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: _timeItems(CommonKey.MON)),
                            Expanded(child: _timeItems(CommonKey.TUE)),
                            Expanded(child: _timeItems(CommonKey.WED)),
                            Expanded(child: _timeItems(CommonKey.THU)),
                            Expanded(child: _timeItems(CommonKey.FRI)),
                            Expanded(child: _timeItems(CommonKey.SAT)),
                            Expanded(child: _timeItems(CommonKey.SUN)),
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),
                      Expanded(
                        child: ListView.separated(
                          itemCount: CommonKey.Monday==_dayName
                              ?_presenter!.onStageScheduleMon.length
                              :CommonKey.Tuesday==_dayName
                              ?_presenter!.onStageScheduleTue.length
                              :CommonKey.Wednesday==_dayName
                              ?_presenter!.onStageScheduleWed.length
                              :CommonKey.Thursday==_dayName
                              ?_presenter!.onStageScheduleThu.length
                              :CommonKey.Friday==_dayName
                              ?_presenter!.onStageScheduleFri.length
                              :CommonKey.Saturday==_dayName
                              ?_presenter!.onStageScheduleSat.length
                              :_presenter!.onStageScheduleSun.length,
                          itemBuilder: (context, index)=>_itemSchedule(
                              CommonKey.Monday==_dayName
                                  ?_presenter!.onStageScheduleMon[index]
                                  :CommonKey.Tuesday==_dayName
                                  ?_presenter!.onStageScheduleTue[index]
                                  :CommonKey.Wednesday==_dayName
                                  ?_presenter!.onStageScheduleWed[index]
                                  :CommonKey.Thursday==_dayName
                                  ?_presenter!.onStageScheduleThu[index]
                                  :CommonKey.Friday==_dayName
                                  ?_presenter!.onStageScheduleFri[index]
                                  :CommonKey.Saturday==_dayName
                                  ?_presenter!.onStageScheduleSat[index]
                                  :_presenter!.onStageScheduleSun[index]
                          ),
                          separatorBuilder: (context, index)=>Divider(),
                          physics: AlwaysScrollableScrollPhysics(),
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          )

        ],
      ),
    );
  }
  Widget _dayItems(String day, String date){
    return InkWell(
      onTap: ()=>setState((){
        _dateNow = date;
        _dayName = day;
      }),
      splashColor: AppColors.transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve : Curves.easeIn,
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
        margin: EdgeInsets.only(left: 2, right: 2),
        width: getWidthDevice(context)/8,
        height: _dateNow==date?getWidthDevice(context)/4:getWidthDevice(context)/5.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(200)),
            color: _dateNow==date?AppColors.ultraRed:AppColors.brightGray,
            boxShadow: [
              BoxShadow(
                color: _dateNow==date?AppColors.white.withOpacity(0.5):AppColors.white.withOpacity(0),
                spreadRadius: _dateNow==date?1:0,
                offset: _dateNow==date?Offset(0.5, 0.5):Offset(0, 0),
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeoText('${CommonKey.Monday==day
                ?Languages.of(context).monday
                :CommonKey.Tuesday==day
                ?Languages.of(context).tuesday
                :CommonKey.Wednesday==day
                ?Languages.of(context).wednesday
                :CommonKey.Thursday==day
                ?Languages.of(context).thursday
                :CommonKey.Friday==day
                ?Languages.of(context).friday
                :CommonKey.Saturday==day
                ?Languages.of(context).saturday:
            CommonKey.Sunday==day
                ?Languages.of(context).sunday:''}', textStyle: TextStyle(fontSize: 14, color: _dateNow==date?AppColors.white:AppColors.lightBlack)),
            NeoText('$date', textStyle: TextStyle(fontSize: 12, color: _dateNow==date?AppColors.white:AppColors.lightBlack))
          ],
        ),
      ),
    );
  }

  Widget _itemSchedule(MyClassModel myClass){
    return InkWell(
      onTap: (){
        // if(CommonKey.MEMBER==_role){
        //   _presenter!.getCourse(_role!, myClass.teacherUsername!).then((value){
        //     CourseModel course = _presenter!.getCourseModel(myClass.courseId!);
        //      Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade,
        //          widget: ClassDetailPage(
        //         MyClassModel(idClass: myClass.idClass, teacherName: myClass.teacherName, className: myClass.className)
        //         , course, _role)));
        //   });
        // }else{
        //    Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade,
        //        widget: ClassDetailPage(MyClassModel(
        //            idClass: myClass.idClass,
        //            teacherName: myClass.teacherName,
        //            className: myClass.className),
        //        _presenter!.getCourseModel(myClass.courseId!), _role)));
        // }
        _presenter!.getCourse(_role!, myClass.teacherUsername!).then((value){
          CourseModel course = _presenter!.getCourseModel(myClass.courseId!);
          Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade,
              widget: ClassDetailPage(
                  MyClassModel(idClass: myClass.idClass, teacherName: myClass.teacherName, className: myClass.className)
                  , course, _role)));
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8,),
          Container(
              width: getWidthDevice(context)*0.2-8,
              child: NeoText('${myClass.startHours}', textStyle: TextStyle(color: AppColors.black, fontSize: 16), textAlign: TextAlign.center)),
          Container(
            width: getWidthDevice(context)*0.8-8,
            height: getHeightDevice(context)/6.5,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color:AppColors.cultured.withOpacity(0.2),
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                  )
                ]
            ),
            padding: EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeoText('${myClass.className}', textStyle: TextStyle(fontSize: 18, color: AppColors.black, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold), maxline: 2),
                SizedBox(height: 8,),
                RichText(
                  text: TextSpan(
                      text: '${Languages.of(context).teacher}: ',
                      style: TextStyle(fontSize: 16, color: AppColors.black),
                      children: [
                        WidgetSpan(
                            child: NeoText('${myClass.teacherName}', maxline: 1, textStyle: TextStyle(fontSize: 16, color: AppColors.black,overflow: TextOverflow.ellipsis))
                        )
                      ]
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeoText('${Languages.of(context).time}: ' ),
                    Column(
                      children: [
                        NeoText('${CommonKey.MON==myClass.onStageMon
                            ?Languages.of(context).monday
                            :CommonKey.TUE==myClass.onStageTue
                            ?Languages.of(context).tuesday
                            :CommonKey.WED==myClass.onStageWed
                            ?Languages.of(context).wednesday
                            :CommonKey.THU==myClass.onStageThu
                            ?Languages.of(context).thursday
                            :CommonKey.FRI==myClass.onStageFri
                            ?Languages.of(context).friday
                            :CommonKey.SAT==myClass.onStageSat
                            ?Languages.of(context).saturday:
                        CommonKey.SUN==myClass.onStageSun
                            ?Languages.of(context).sunday:''} - ${myClass.startHours}',
                            textStyle: TextStyle(fontSize: 14,
                                color: AppColors.black, overflow: TextOverflow.ellipsis), maxline: 2),
                        NeoText('${CommonKey.SUN==myClass.onStageSun
                            ?Languages.of(context).sunday
                            :CommonKey.SAT==myClass.onStageSat
                            ?Languages.of(context).saturday
                            :CommonKey.FRI==myClass.onStageFri
                            ?Languages.of(context).friday
                            :CommonKey.THU==myClass.onStageThu
                            ?Languages.of(context).thursday
                            :CommonKey.WED==myClass.onStageWed
                            ?Languages.of(context).wednesday
                            :CommonKey.TUE==myClass.onStageTue
                            ?Languages.of(context).tuesday:
                        CommonKey.MON==myClass.onStageMon
                            ?Languages.of(context).monday:''} - ${myClass.startHours}',
                            textStyle: TextStyle(fontSize: 14,
                                color: AppColors.black, overflow: TextOverflow.ellipsis), maxline: 2)
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8,)
        ],
      ),
    );
  }

  Widget _timeItems(String day){
    return  Container(
        padding: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
        height: getHeightDevice(context)/8,
        decoration: BoxDecoration(
            color: AppColors.cultured,
            border: Border(
                right: BorderSide(
                    width: 1,
                    color: AppColors.pastelBlue
                )
            )
        ),
        child: ListView.separated(
          itemBuilder: (context, index)=>_itemDateDetail(
              CommonKey.MON==day?_presenter!.onStageScheduleMon[index]
                  :CommonKey.TUE==day?_presenter!.onStageScheduleTue[index]
                  :CommonKey.WED==day?_presenter!.onStageScheduleWed[index]
                  :CommonKey.THU==day?_presenter!.onStageScheduleThu[index]
                  :CommonKey.FRI==day?_presenter!.onStageScheduleFri[index]
                  :CommonKey.SAT==day?_presenter!.onStageScheduleSat[index]
                  :_presenter!.onStageScheduleSun[index]
          ), itemCount: CommonKey.MON==day?_presenter!.onStageScheduleMon.length
            :CommonKey.TUE==day?_presenter!.onStageScheduleTue.length
            :CommonKey.WED==day?_presenter!.onStageScheduleWed.length
            :CommonKey.THU==day?_presenter!.onStageScheduleThu.length
            :CommonKey.FRI==day?_presenter!.onStageScheduleFri.length
            :CommonKey.SAT==day?_presenter!.onStageScheduleSat.length
            :_presenter!.onStageScheduleSun.length,  separatorBuilder: (context, index)=>SizedBox(height: 4,),
        ));
  }

  Widget _itemDateDetail(MyClassModel myClass){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color:AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0,right: 2,top: 4,bottom: 4),
        child: NeoText('${myClass.startHours}',
          textStyle: TextStyle(fontSize: 12, color: AppColors.black),
        ),
      ),
    );
  }
  Future<void> _getData() async{
    dynamic data =await SharedPreferencesData.getData(CommonKey.USER);
    if(data!=null){
      Map<String, dynamic>json = jsonDecode(data.toString());
      String phone = json['phone']!=null?json['phone']:'';
      _myClass = await _presenter!.getSchedule(phone, _role!);
      // if(CommonKey.TEACHER==_role){
      //   _presenter!.getCourse(_role!, phone);
      // }

    }

  }
}
