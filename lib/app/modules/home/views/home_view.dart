import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
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
                5.toString(),
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
