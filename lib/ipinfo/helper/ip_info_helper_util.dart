import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter_utils_juni1289/ipinfo/model/device_ip_info_helper_model.dart';
import 'package:flutter_utils_juni1289/network/connectionmanager/network_connection_manager_helper_util.dart';

class IPInfoHelperUtil {
  /// private constructor
  IPInfoHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = IPInfoHelperUtil._();

  ///get the device IP info
  ///[onIPFetchedCallback] is required, to fetch the DeviceIPInfoHelperModel in the callback
  ///[ipInfoTimeOutInSeconds] is optional, to set the timeout, default is 18 seconds
  Future<void> getDeviceIPInfo({required Function(DeviceIPInfoHelperModel deviceIPInfoHelperModel) onIPFetchedCallback, int ipInfoTimeOutInSeconds = 18}) async {
    NetworkConnectionManagerHelperUtil.instance.isNetworkAvailable().then((bool isNetworkAvailable) {
      if (isNetworkAvailable) {
        Ipify.ipv4()
            .then((String deviceIP) {
              onIPFetchedCallback(DeviceIPInfoHelperModel(deviceIP: deviceIP));
            })
            .onError((error, stackTrace) {
              onIPFetchedCallback(DeviceIPInfoHelperModel(errorReason: "Code: 8711:::$stackTrace"));
            })
            .timeout(Duration(seconds: ipInfoTimeOutInSeconds))
            .then((_) {
              onIPFetchedCallback(DeviceIPInfoHelperModel(errorReason: "Request timeout!"));
            })
            .onError((error, stackTrace) {
              onIPFetchedCallback(DeviceIPInfoHelperModel(errorReason: "Code: 8712:::$stackTrace"));
            });
      } else {
        onIPFetchedCallback(DeviceIPInfoHelperModel(errorReason: "Network unreachable!"));
      }
    });
  }
}
