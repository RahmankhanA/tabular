import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tabular/app/modules/home/views/browser.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            if (controller.webViewController != null) {
              if (await controller.webViewController!.canGoBack()) {
                controller.webViewController!.goBack();
                return false;
              }
            }
            return true;
          },
          child: const Browser()),
      bottomSheet: Container(
        color: const Color.fromARGB(230, 14, 11, 11),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                width: Get.width * 0.7,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: controller.searchController,
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (value) {
                    var url = Uri.parse(value);
                    if (url.scheme.isEmpty) {
                      url = Uri.parse(("https://duckduckgo.com/?q=") + value);
                    }
                    controller.webViewController
                        ?.loadUrl(urlRequest: URLRequest(url: url));
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                      ),
                      hintText: "Search or enter address",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                      border: InputBorder.none),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.white),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0)),
              constraints: const BoxConstraints(minWidth: 25.0),
              child: Center(
                  child: Text(
                1.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              )),
            ),
            const Icon(
              Icons.more_vert,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
