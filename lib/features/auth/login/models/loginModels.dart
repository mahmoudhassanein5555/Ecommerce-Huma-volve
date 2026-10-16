class loginModels {
  String? accessToken;
  String? refreshToken;

  loginModels({this.accessToken, this.refreshToken});

  loginModels.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['access_token'] = this.accessToken;
//    data['refresh_token'] = this.refreshToken;
//    return data;
//  }
}
