class TokenModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  String? userName;
  String? userId;
  String? customerCode;
  String? userType;
  String? dbName;
  String? curDateTime;
  String? issued;
  String? expires;

  TokenModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
    this.userName,
    this.userId,
    this.customerCode,
    this.userType,
    this.dbName,
    this.curDateTime,
    this.issued,
    this.expires,
  });

  TokenModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    userName = json['userName'];
    userId = json['userId'];
    customerCode = json['customerCode'];
    userType = json['userType'];
    dbName = json['dbName'];
    curDateTime = json['curDateTime'];
    issued = json['.issued'];
    expires = json['.expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['refresh_token'] = refreshToken;
    data['userName'] = userName;
    data['userId'] = userId;
    data['customerCode'] = customerCode;
    data['userType'] = userType;
    data['dbName'] = dbName;
    data['curDateTime'] = curDateTime;
    data['.issued'] = issued;
    data['.expires'] = expires;
    return data;
  }
}
