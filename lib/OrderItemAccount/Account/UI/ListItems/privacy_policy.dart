import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  policyState createState() => policyState();
}

class policyState extends State<PrivacyPolicy> {
  late final flutterWebViewPlugin;
  late WebViewController _controller;
  Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white)),
        /*  actions: [
         
          IconButton(
              onPressed: () {
                // setState(() {
                //   _controller.loadUrl(
                //       context.read<Paymentprovider>().webviewurl.toString());
                // });
                // _controller.loadUrl(
                //     context.read<Paymentprovider>().webviewurl.toString());
                _controller.loadUrl('https://www.facebook.com/');
              },
              icon: Icon(Icons.access_alarm))
        ], */
        //centerTitle: true,
      ),
      body: WebView(
        initialUrl: 'https://www.kisanserv.com/PrivacyPolicynew.aspx',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webviewcontroller) {
          controller.complete(webviewcontroller);
          _controller = webviewcontroller;
        },
        onPageFinished: (finish) async {
          //reading response on finish
          await _controller.runJavascriptReturningResult(
              "document.documentElement.innerText");

          //don't forget to decode into json
        },
      ),
    );
  }
}
