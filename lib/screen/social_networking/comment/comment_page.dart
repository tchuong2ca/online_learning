import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_learning/common/functions.dart';
import 'package:online_learning/common/widgets.dart';
import 'package:online_learning/screen/social_networking/comment/presenter/comment_presenter.dart';
import 'package:online_learning/screen/social_networking/newsfeed/view_photo.dart';
import 'package:online_learning/screen/animation_page.dart';
import '../../../external/switch_page_animation/enum.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:online_learning/screen/social_networking/comment/model/comment_model.dart';
import '../../../common/colors.dart';
import '../../../common/keys.dart';
import '../../../common/themes.dart';
import '../../../languages/languages.dart';
import '../../../res/images.dart';
import '../newsfeed/news_detail.dart';
import 'dart:math' as math;
class CommentPage extends StatefulWidget {
  Map<String, dynamic>? _data;
  Map<String, dynamic>? _dataUser;
  CommentPage(this._data, this._dataUser);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  Stream<DocumentSnapshot>? _streamNew;
  Stream<QuerySnapshot>? _streamComment;
  String _message = '';
  TextEditingController _controllerMess = TextEditingController();
  File? _fileImage;
  String _feedbackName = '';
  bool _isFeedback = false;
  CommentPresenter? _presenter;
  String _level = '1';
  Comment? _comment;
  int _indexLevel = 0;
  String _linkImage = '';
  @override
  void initState() {
    _presenter = CommentPresenter();
    _streamNew = FirebaseFirestore.instance.collection('news').doc(widget._data!['id']).snapshots();
    _streamComment = FirebaseFirestore.instance.collection('comment').doc(widget._data!['id']).collection(widget._data!['id']).orderBy('timeStamp', descending: false).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: _streamNew,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50),);
                      }else if(snapshot.hasError){
                        return notfound(Languages.of(context).noData);
                      }else if(!snapshot.hasData){
                        return notfound(Languages.of(context).noData);
                      }else{
                        Map<String, dynamic> data = snapshot.data!.data() as  Map<String, dynamic>;
                        List<dynamic> listImage = data['mediaUrl'];
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 4,),
                                  ClipOval(
                                    child: loadPhoto.networkImage(data['userAvatar']!=null?data['userAvatar']:'', 50, 50),
                                  ),
                                  SizedBox(width: 4,),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        NeoText(data['fullname']!=null?data['fullname']:'', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.black)),
                                        NeoText(data['timestamp']!=null?postedTime(data['timestamp']):'', textStyle: TextStyle(fontSize: 12, color: AppColors.lightBlack)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: NeoText(data['description']!=null?data['description']:'', textStyle: TextStyle(color: AppColors.black, fontSize: 14,)),
                              ),
                              listImage.length==1
                                  ? InkWell(
                                  onTap: (){
                                     Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: MediaPageView(data['mediaUrl'], 0)));
                                  },
                                  child:
                                  listImage[0].toString().contains('mp4')?
                                  Image.asset(Images.horizontalplaybtn):
                                  loadPhoto.imageNetworkWrapContent(
                                      listImage[0] != null ? listImage[0] : ''))
                                  :listImage.length==2?InkWell(
                                onTap: (){
                                   Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: NewsDetailPage(data)));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listImage[0].toString().contains('mp4')?
                                    Image.asset(Images.horizontalplaybtn,  width: getWidthDevice(context)/2-16,height: getHeightDevice(context)/4,):loadPhoto.networkImage(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
                                    Spacer(),
                                    listImage[1].toString().contains('mp4')?
                                    Image.asset(Images.horizontalplaybtn, width: getWidthDevice(context)/2-16,height: getHeightDevice(context)/4,):loadPhoto.networkImage(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
                                  ],
                                ),
                              ): listImage.length==3?InkWell(
                                onTap: (){
                                   Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: NewsDetailPage(data)));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listImage[0].toString().contains('mp4')?
                                    Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/2.2,fit: BoxFit.fill,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/2, getWidthDevice(context)/2-16),
                                    Spacer(),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        listImage[1].toString().contains('mp4')?
                                        Image.asset(Images.horizontalplaybtn,fit: BoxFit.fill, height:  getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                                        SizedBox(height: 8,),
                                        listImage[2].toString().contains('mp4')?
                                        Image.asset(Images.horizontalplaybtn,fit: BoxFit.fill,height:  getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[2]!=null?listImage[2]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                                      ],
                                    ),
                                  ],
                                ),
                              ):InkWell(
                                onTap: (){
                                   Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: NewsDetailPage(data)));
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        listImage[0].toString().contains('mp4')?
                                        Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                                        Spacer(),
                                        listImage[1].toString().contains('mp4')?
                                        Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        listImage[2].toString().contains('mp4')?
                                        Image.asset(Images.horizontalplaybtn,height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[2]!=null?listImage[2]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                                        Spacer(),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            listImage[3].toString().contains('mp4')?
                                            Image.asset(Images.horizontalplaybtn, height: getHeightDevice(context)/5,width: getWidthDevice(context)/2-16,):loadPhoto.networkImage(listImage[3]!=null?listImage[3]:'', getHeightDevice(context)/5, getWidthDevice(context)/2-16),
                                            NeoText('${listImage.length>4?'+${listImage.length-4}':''}', textStyle: TextStyle(color: AppColors.cultured, fontSize: 25))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              Divider(thickness: 2),
                              SizedBox(height: 8,),
                              StreamBuilder<QuerySnapshot>(
                                stream: _streamComment,
                                builder: (context, snapshotsComment){
                                  if(snapshotsComment.connectionState==ConnectionState.waiting){
                                    return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.ultraRed, size: 50));
                                  }else if(snapshotsComment.hasError){
                                    return notfound(Languages.of(context).noData);
                                  }else if(!snapshotsComment.hasData){
                                    return notfound(Languages.of(context).noData);
                                  }else{
                                    return ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: snapshotsComment.data!.docs.map((e) {
                                        Map<String, dynamic> dataComment = e.data() as Map<String, dynamic>;
                                        Comment comment = Comment.fromJson(e.data());
                                        print('$dataComment, \n$comment');
                                        return _itemChat(comment);
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 100,)
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              margin: EdgeInsets.only(top: 8,),
              padding: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                  color: AppColors.brightGray
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _fileImage!=null?Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image(image: FileImage(_fileImage!), width: getWidthDevice(context)*0.3, height: getWidthDevice(context)*0.3,),
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.redAccent,
                        ),
                        onPressed: ()=>setState(()=>_fileImage=null),
                      )
                    ],
                  ):SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 4,),
                      IconButton(
                        onPressed: ()=>cropImage(context, (p0) => setState(()=> _fileImage=p0!), ''),
                        icon: Icon(
                          Icons.image,
                          color: AppColors.ultraRed,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: AppThemes.textFieldInputDecorationChat(),
                          onChanged: (value)=>setState(()=>_message=value),
                          controller: _controllerMess,
                        ),
                      ),
                      Transform.rotate(
                        angle: -35*math.pi /180,
                        child: IconButton(
                          onPressed: ()async{
                            if(_message.isNotEmpty||_fileImage!=null){

                              Comment? comment = await _level!='1'
                                  ?_comment
                                  :Comment(
                                  feedbackName: _feedbackName,
                                  name: widget._dataUser!['fullname'],
                                  content: _message,
                                  idUser: widget._dataUser!['phone'],
                                  avatar: widget._dataUser!['avatar'],
                                  timeStamp: getTimestamp(),
                                  level: _level,
                                  listComment: [
                                  ]
                              );
                              if(_level!='1'&&_fileImage!=null){
                                _linkImage = await _presenter!.getPhotoLink(idNews: widget._data!['id'], comment: comment!, imageFile: _fileImage!);
                              }
                              _level=='2'?_comment!.listComment!.add(
                                  Comment(
                                      id: getCurrentTime(),
                                      feedbackName: _feedbackName,
                                      name: widget._dataUser!['fullname'],
                                      content: replaceKey(_message, _feedbackName),
                                      idUser: widget._dataUser!['phone'],
                                      avatar: widget._dataUser!['avatar'],
                                      timeStamp: getTimestamp(),
                                      level: _level,
                                      imageLink: _linkImage,
                                      listComment: [
                                      ]
                                  )
                              ):_level=='3'?_comment!.listComment![_indexLevel].listComment!.add( Comment(
                                id: getCurrentTime(),
                                feedbackName: _feedbackName,
                                name: widget._dataUser!['fullname'],
                                content: replaceKey(_message, _feedbackName),
                                idUser: widget._dataUser!['phone'],
                                avatar: widget._dataUser!['avatar'],
                                timeStamp: getTimestamp(),
                                imageLink: _linkImage,
                                level: _level,
                              )):null;
                              _fileImage!=null
                                  ?_presenter!.sendMessage(idNews: widget._data!['id'], comment: comment!, type: _level!='1'?CommonKey.UPDATE_CHILD:CommonKey.ADD_NEW, imageFile: _fileImage!)
                                  :_presenter!.sendMessage(idNews: widget._data!['id'], comment: comment!, type: _level!='1'?CommonKey.UPDATE_CHILD:CommonKey.ADD_NEW);
                              _message = '';
                              _fileImage = null;
                              _controllerMess = TextEditingController(text: _message);
                              _isFeedback = false;
                              _feedbackName = '';
                              _comment=null;
                              hideKeyboard();
                              setState(()=>null);
                            }
                          },
                          icon: Icon(
                            Icons.send_rounded,
                            color: AppColors.ultraRed,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemChat(Comment comment){
    List<dynamic> image =[comment.imageLink];
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: loadPhoto.networkImage(comment.avatar, 40, 40),
            ),
            SizedBox(width: 8,),
            SizedBox(
              width: getWidthDevice(context)/1.5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeoText(comment.name!, textStyle: TextStyle(fontSize: 14, color: AppColors.pastelBlue,)),
                  (comment.feedbackName==null||comment.feedbackName!.isEmpty)?SizedBox():NeoText(comment.feedbackName!, textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black)),
                  NeoText(comment.content!, textStyle: TextStyle(fontSize: 14, color: AppColors.black,))
                ],
              ),
            ),
          ],
        ),
        comment.imageLink!=null&&comment.imageLink!.isNotEmpty
            ?Padding(
          padding: const EdgeInsets.only(left: 50, top: 8),
          child: InkWell(
              onTap: ()=>  Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: MediaPageView(image, 0))),
              child: loadPhoto.networkImage(comment.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
        )
            :SizedBox(),
        SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 48,),
            InkWell(
              onTap: (){
                setState((){
                  _isFeedback = true;
                  _feedbackName = '${comment.name}';
                  _controllerMess = TextEditingController(text: _feedbackName);
                  _level='2';
                  _comment = Comment(
                      feedbackName: comment.feedbackName,
                      name: comment.name,
                      content: comment.content,
                      idUser: comment.idUser,
                      avatar: comment.avatar,
                      timeStamp: comment.timeStamp,
                      level: comment.level,
                      imageLink: comment.imageLink,
                      listComment: comment.listComment,
                      id: comment.id
                  );
                });
              },
              child: NeoText(
                  Languages.of(context).feedback,
                  textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 10)
              ),
            ),
            SizedBox(width: 50,),
            widget._dataUser!['phone']==comment.idUser?InkWell(
              onTap: (){
                _presenter!.deleteComment(comment,widget._data!['id']);
              },
              child: NeoText(
                  Languages.of(context).delete,
                  textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 10)
              ),
            ):SizedBox(),
          ],
        ),
        comment.listComment!.length>0?Wrap(
          children: List.generate(comment.listComment!.length, (index) => _itemChatChild(comment.listComment![index], index, comment)).toList(),
        ):SizedBox()
      ],
    );
  }

  Widget _itemChatChild(Comment comment, int index, Comment commentParent){
    List<dynamic> image =[comment.imageLink];
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: loadPhoto.networkImage(comment.avatar, 35, 35),
              ),
              SizedBox(width: 8,),
              SizedBox(
                width: getWidthDevice(context)/1.5,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NeoText(comment.name!, textStyle: TextStyle(fontSize: 15, color: AppColors.black,fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxline: 1),
                        SizedBox(width: 4,),
                        Expanded(child:(comment.feedbackName==null||comment.feedbackName!.isEmpty)?SizedBox():NeoText('@${comment.feedbackName!}', textStyle: TextStyle(fontSize: 15,  color: AppColors.pastelBlue, overflow: TextOverflow.ellipsis), maxline: 1),
                        )
                      ],
                    ),
                    SizedBox(height: 4,),
                    NeoText(comment.content!, textStyle: TextStyle(fontSize: 15, color: AppColors.black,))
                  ],
                ),
              ),
            ],
          ),
          comment.imageLink!=null&&comment.imageLink!.isNotEmpty
              ?Padding(
            padding: const EdgeInsets.only(left: 50, top: 8),
            child: InkWell(
                onTap: ()=>  Navigator.push(context, AnimationPage().pageTransition(type: PageTransitionType.fade, widget: MediaPageView(image, 0))),
                child: loadPhoto.networkImage(comment.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
          )
              :SizedBox(),
          SizedBox(height: 12,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 48,),
              InkWell(
                onTap: (){
                  setState((){
                    _isFeedback = true;
                    _feedbackName = '${comment.name}';
                    if(comment.level=='2'){
                      _indexLevel = index;
                    }
                    _controllerMess = TextEditingController(text: _feedbackName);
                    _level='3';
                    _comment = commentParent;
                  });
                },
                child: NeoText(
                    Languages.of(context).feedback,
                    textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 10)
                ),
              ),
              SizedBox(width: 50,),
              widget._dataUser!['phone']==comment.idUser?InkWell(
                onTap: (){
                  if(comment.level=="2"){
                    commentParent.listComment!.remove(comment);
                  }else{
                    commentParent.listComment![index].listComment!.remove(comment);
                  }
                  _presenter!.updateCommentReply(commentParent, widget._data!['id']);
                },
                child: NeoText(
                    Languages.of(context).delete,
                    textStyle: TextStyle(color: AppColors.ultraRed, fontSize: 10)
                ),
              ):SizedBox(),
            ],
          ),
          (comment.listComment!=null)?Wrap(
            children: List.generate(comment.listComment!.length, (index3) => _itemChatChild(comment.listComment![index3], index, commentParent)).toList(),
          ):SizedBox()
        ],
      ),
    );
  }
}
