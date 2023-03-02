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
      bottomSheet: Obx(() => Container(
            color: const Color.fromARGB(230, 14, 11, 11),
            height: controller.progress.value < 1.0 ? 62 : 58,
            child: Column(
              children: [

                Visibility(
                  visible: controller.progress.value < 1.0,
                    child: LinearProgressIndicator(
                  value: controller.progress.value,
                  color: const Color.fromARGB(255, 38, 67, 226),
                  backgroundColor: Colors.black,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Container(
                          // width: Get.width * 0.7,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: controller.searchController,
                            onTap: () {
                              controller.searchController.selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: controller
                                          .searchController.text.length);
                            },
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (value) {
                              var url = Uri.parse(value);
                              if (url.scheme.isEmpty) {
                                url = Uri.parse(
                                    ("https://google.com/search?q=") + value);
                              }
                              controller.webViewController
                                  ?.loadUrl(urlRequest: URLRequest(url: url));
                            },
                            decoration: InputDecoration(
                                prefixIcon: InkWell(
                                  onTap: () {

                                  },
                                  child: Icon(
                                    controller.isUrlsafe.value
                                        ? Icons.lock
                                        : Icons.lock_open,
                                    color: controller.isUrlsafe.value
                                        ? Colors.white
                                        : Colors.red,
                                  ),
                                ),
                                hintText: "Search or enter address",
                                hintStyle: const TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                                border: InputBorder.none),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
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
              ],
            ),
          )),
    );
  }
}
