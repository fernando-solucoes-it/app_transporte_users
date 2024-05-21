import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  Future<void> checkConnectivity(BuildContext context) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (!connectivityResult
              .toString()
              .contains(ConnectivityResult.mobile.name) &&
          !connectivityResult
              .toString()
              .contains(ConnectivityResult.wifi.name)) {
        if (!context.mounted) return;

        displaySnackBar(
            "Your internet is not working. Check your connection and try again",
            context);
      }
    } catch (e) {
      if (!context.mounted) return;
      displaySnackBar(
          "Failed to check internet connection. Please try again later.",
          context);
    }
  }

  void displaySnackBar(String messageText, BuildContext context) {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
