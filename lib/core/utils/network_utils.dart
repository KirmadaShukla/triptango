import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  /// Checks if the device is connected to the internet (WiFi or mobile data).
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print('Connectivity result: $connectivityResult');
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
} 