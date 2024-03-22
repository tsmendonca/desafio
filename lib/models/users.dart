class User {
  int pat;
  String nickname;
  
  User({required this.pat, required this.nickname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pat: json['pat'],
      nickname: json['nickname'],      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pat': pat,
      'nickname': nickname,      
    };
  }
}
