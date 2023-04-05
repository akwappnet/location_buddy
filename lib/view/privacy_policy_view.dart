// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:location_buddy/utils/colors/colors.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: CustomColor.primaryColor,
          elevation: 0,
          centerTitle: true,
          title: const Text('Privacy Policy'),
        ),
        body: Stack(
          children: [
            InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      "https://docs.google.com/document/d/e/2PACX-1vRGxNESmzUMyXKQ8yAslDIR-qLbxNeLWvqyyWF89hZ7BM2Z0xim0tAJZiYCTlUwF9ryzTBuT-2QUQIv/pub"),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                }),
            _progress < 1
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.blue,
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }
}
