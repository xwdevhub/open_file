class OpenResult {
  ResultType type;
  String message;

  OpenResult({this.type = ResultType.done, this.message = "done"});

  OpenResult.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        type = _convertJson(json['type']);

  static ResultType _convertJson(int? jsonType) {
    switch (jsonType) {
      case -1:
        return ResultType.noAppToOpen;
      case -2:
        return ResultType.fileNotFound;
      case -3:
        return ResultType.permissionDenied;
      case -4:
        return ResultType.error;
    }
    return ResultType.done;
  }
}

class SupportAppInfo {
  String packageName;
  String activityName;
  String label;
  String iconBase64;

  SupportAppInfo(
      {this.packageName = "",
      this.activityName = "",
      this.label = "",
      this.iconBase64 = ""});

  SupportAppInfo.fromJson(Map<String, dynamic> json)
      : packageName = json['package_name'],
        activityName = json['activity_name'],
        label = json['label'],
        iconBase64 = json['icon'];
}

enum ResultType {
  done,
  fileNotFound,
  noAppToOpen,
  permissionDenied,
  error,
}
