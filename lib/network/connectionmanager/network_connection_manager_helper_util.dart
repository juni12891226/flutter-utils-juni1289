import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnectionManagerHelperUtil {
  /// private constructor
  NetworkConnectionManagerHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = NetworkConnectionManagerHelperUtil._();

  ///To check if the network connection is available
  Future<bool> isNetworkAvailable() async {
    bool isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (isNetworkAvailable) {
      return true;
    } else {
      return false;
    }
  }
}
