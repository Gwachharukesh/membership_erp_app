class ApiResponseData {
  ApiResponseData({
    this.responseMSG,
    this.isSuccess,
    this.rId,
    this.isNetworkError,
    this.isduplicate,
    this.userData,
  });

  String? responseMSG;
  bool? isSuccess;
  int? rId;
  bool? isNetworkError;
  bool? isduplicate;
  dynamic userData;
}
