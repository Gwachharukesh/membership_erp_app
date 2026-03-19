class ApiResponseModel {

  ApiResponseModel({this.isSuccess, this.responseMsg});

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      isSuccess: json['IsSuccess'] as bool?,
      responseMsg: json['ResponseMSG'] as String?,
    );
  }
  bool? isSuccess;
  String? responseMsg;

  Map<String, dynamic> toJson() => {
        'IsSuccess': isSuccess,
        'ResponseMSG': responseMsg,
      };

  static ApiResponseModel failed =
      ApiResponseModel(isSuccess: false, responseMsg: 'Failed');
}
