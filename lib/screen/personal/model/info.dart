class Info{
  String? fullname;
  String? phone;
  String? email;
  String? specialize;
  String? exp;
  String? avatar;
  String? intro;
  String? role;

  Info(
      {this.fullname,
        this.phone,
        this.email,
        this.specialize,
        this.exp,
        this.avatar,
        this.intro,
        this.role,});

  Info.fromJson(dynamic json) {
    phone = json['phone'];
    avatar = json['avatar'];
    fullname = json['fullname'];
    role = json['role'];
    email = json['email'];
    exp = json['exp'];
    specialize = json['specialize'];
    intro = json['intro'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = phone;
    map['avatar'] = avatar;
    map['fullname'] = fullname;
    map['role'] = role;
    map['email'] = email;
    map['exp'] = exp;
    map['specialize'] = specialize;
    map['intro'] = intro;
    return map;
  }
}