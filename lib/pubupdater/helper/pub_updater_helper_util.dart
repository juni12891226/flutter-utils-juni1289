import 'dart:io';

import 'package:flutter_utils_juni1289/pubupdater/model/pub_updater_helper_model.dart';
import 'package:pub_updater/pub_updater.dart';

class PubUpdaterHelperUtil {
  /// private constructor
  PubUpdaterHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = PubUpdaterHelperUtil._();

  ///In order to check that any package is updated or not
  ///If not you can update the package on the go
  ///Else get the latest version available
  ///[pubPackageName] is the name of the package you want to check
  ///[pubPackageCurrentVersion] is your current package version that you are using
  ///[haveToUpdateToLatest] default is false, if have to update the outdated package on the go!
  ///bingo!
  Future<PubUpdaterResultHelperModel> isPubPackageUpdated({required String pubPackageName, required String pubPackageCurrentVersion, bool? haveToUpdateToLatest}) async {
    final pubUpdater = PubUpdater();

    // Check whether or not version 0.1.0 is the latest version of my_package
    final isUpToDate = await pubUpdater.isUpToDate(
      packageName: pubPackageName,
      currentVersion: pubPackageCurrentVersion,
    );

    int processResultCode = -9;

    // Trigger an upgrade to the latest version if my_package is not up to date
    if (!isUpToDate && (haveToUpdateToLatest ?? false)) {
      ProcessResult processResult = await pubUpdater.update(packageName: pubPackageName);
      processResultCode = processResult.exitCode;
    }

    // You can also query the latest version available for a specific package.
    final latestVersion = await pubUpdater.getLatestVersion(pubPackageName);

    return PubUpdaterResultHelperModel(
        packageUpdatedProcessUpdate: (processResultCode == 0 ? true : false), latestVersionAvailable: latestVersion, isCurrentPackageUpToDate: isUpToDate);
  }
}
