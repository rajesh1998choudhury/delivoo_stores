// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, deprecated_member_use, unrelated_type_equality_checks, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;

class Invoice extends StatefulWidget {
  final String? orderId;
  const Invoice({Key? key, this.orderId}) : super(key: key);

  @override
  InvoiceState createState() => InvoiceState();
}

class InvoiceState extends State<Invoice> {
  late final flutterWebViewPlugin;
  late WebViewController _controller;
  Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      Appconstants.BaseUrl + "${orderInvoice}" + "${widget.orderId}",
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Invoice',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        body: WebView(
          debuggingEnabled: true,
          initialUrl:
              Appconstants.BaseUrl + "${orderInvoice}" + "${widget.orderId}",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webviewcontroller) {
            controller.complete(webviewcontroller);
            _controller = webviewcontroller;
          },
        ),
      ),
    );
  }
}
