import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialStatus() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(dynamic result) {
    late List<ConnectivityResult> results;
    if (result is List) {
      results = result.cast<ConnectivityResult>();
    } else if (result is ConnectivityResult) {
      results = [result];
    } else {
      results = [];
    }

    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      isOnline.value = false;
      return;
    }

    // If any of the results indicate a connection, we are online
    final hasConnection = results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );

    isOnline.value = hasConnection;
  }
}
