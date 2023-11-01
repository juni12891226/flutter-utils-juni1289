class PubUpdaterResultHelperModel {
  bool isCurrentPackageUpToDate;
  String latestVersionAvailable;
  bool packageUpdatedProcessUpdate;

  PubUpdaterResultHelperModel({this.packageUpdatedProcessUpdate = false, required this.isCurrentPackageUpToDate, required this.latestVersionAvailable});
}
