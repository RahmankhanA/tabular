import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tabular/app/modules/home/controllers/home_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Browser extends StatefulWidget {
  const Browser({super.key});

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions settings = InAppWebViewGroupOptions(
      crossPlatform:
          InAppWebViewOptions(mediaPlaybackRequiresUserGesture: true));

  PullToRefreshController? pullToRefreshController;
  HomeController homeController = Get.find<HomeController>();
  late ContextMenu contextMenu;


  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(
                    await homeController.webViewController?.getSelectedText());
                await homeController.webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await homeController.webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          log("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.androidId;
          log(
              "onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        });

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            options: PullToRefreshOptions(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                homeController.webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                homeController.webViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await homeController.webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest:
                  URLRequest(url: Uri.parse('https://google.com/')),
              // initialUrlRequest:
              // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
              // initialFile: "assets/index.html",
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: settings,
              // contextMenu: contextMenu,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) async {
                homeController.webViewController = controller;
                print(await controller.getUrl());
              },
              onLoadStart: (controller, url) async {
                // setState(() async{
                  homeController.url.value = url.toString();
                  homeController.isUrlsafe.value =await homeController.webViewController!.isSecureContext();
                  

                  homeController.searchController.text = homeController.url.value;

                // });
              },
              androidOnPermissionRequest: (controller, request, data) async {
                return PermissionRequestResponse(
                    resources: data,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    // Launch the App
                    await launchUrl(
                      uri,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();
                // setState(() {
                  homeController.url.value = url.toString();
                  homeController.searchController.text = homeController.url.value;
                // });

              },
              onLoadError: (controller, request, count, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                // setState(() {
                  homeController.progress.value = progress / 100;
                  homeController.searchController.text = homeController. url.value;
                // });
              },
              onUpdateVisitedHistory: (controller, url, isReload) {
                // setState(() {
                  homeController.url.value = url.toString();
                  homeController.searchController.text = homeController.url.value;
                // });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),

          ],
        ),
      ),
    ])));
  }
}
