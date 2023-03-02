import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
 TextEditingController searchController=TextEditingController();
  InAppWebViewController? webViewController;
RxBool isUrlsafe=true.obs;
RxString url = "".obs;
  RxDouble progress = 0.0.obs;

}
