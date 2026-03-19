class ApiResponseData {
  ApiResponseData({
    this.responseMSG,
    this.isSuccess,
    this.rId,
    this.isNetworkError,
    this.isduplicate,
  });

  String? responseMSG;
  bool? isSuccess;
  int? rId;
  bool? isNetworkError;
  bool? isduplicate;
}
