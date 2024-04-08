import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gti_rides/screens/renter/home/search_result/car_selection_result/payment_summary/webview_payment/payment_webview_controller.dart';
import 'package:gti_rides/styles/asset_manager.dart';
import 'package:gti_rides/styles/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  // final String checkoutUrl;

  PaymentWebView({
    Key? key, 
  }) : super(key: key);
  final controller = Get.put(PaymentWebViewController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            
            title: Text("Checkout"),
            leading: Transform.scale(
          scale: 0.5,
          child: GestureDetector(
            onTap: () => controller.goBack1(),
            child: SvgPicture.asset(ImageAssets.arrowLeft, color: black))),
          ),
          body: WebViewWidget(
            controller: controller.webViewController,
          ),
        );
  }
}
