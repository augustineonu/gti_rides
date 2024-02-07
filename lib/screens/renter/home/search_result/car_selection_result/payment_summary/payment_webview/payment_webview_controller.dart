import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gti_rides/services/logger.dart';
import 'package:gti_rides/services/route_service.dart';
import 'package:gti_rides/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewController extends GetxController {
  Logger logger = Logger("Controller");

  PaymentWebViewController() {
    init();
  }

  void init() {
    logger.log("PaymentWebViewController Initialized");
  }

  @override
  void onInit() async {
    update();

    super.onInit();
    if (arguments != null) {
      checkoutUrl.value = arguments?["checkoutUrl"];
    }
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            pageProgress.value = progress;
          },
          onPageStarted: (String url) {
            pageTitle.value = 'loading...';
          },
          onPageFinished: (String url) {
            pageTitle.value = url;
            pageProgress.value = 0;
            logger.log("URL  >> 1:: ${url}");
          },
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (UrlChange url){
            logger.log("onChnaged URL:: ${url.url.toString()}");
            if(url.url!.toLowerCase().contains('completed'.toLowerCase())){
              routeService.goBack(result: true);
              // Navigator.pop(context)
              
            }
            // https://webhook.site/9d0b00ba-9a69-44fa-a43d-a82c33c36fdc?status=completed&tx_ref=OOXVipNTuVwvtcN&transaction_id=1247735467


          },
          onNavigationRequest: (NavigationRequest request) {
            logger.log("URL:: ${request.url}");
            if (request.url.startsWith('https://webhook.site/')) {
              // showErrorSnackbar(message: "message");
               if(request.url.toLowerCase().contains('completed'.toLowerCase())){
              routeService.goBack(result: true);
              // Navigator.pop(context)
              
            }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl.value));

    if (arguments != null) {
      logger.log("Received data:: $arguments");
      logger.log("Received data:: ${arguments?["tripsData"]}");
    }
  }

  Map<String, dynamic>? arguments = Get.arguments;
  final Rx<String> pageTitle = '-'.obs;
  final Rx<String> checkoutUrl = ''.obs;
  Rx<int> pageProgress = 0.obs;
  WebViewController webViewController = WebViewController();

    void goBack() => routeService.goBack();

}
