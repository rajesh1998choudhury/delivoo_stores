// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:delivoo_stores/StoreOrdering/Pages/paymentselection.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/src/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../Utils/CommonWidget.dart';
// import '../StoreOrderingProvider/store_paymentProvider.dart';

// class Webview extends StatefulWidget {
//   // String? POid;

//   // bool isPO;
//   // Webview(this.POid, this.isPO);
//   @override
//   webviewState createState() => webviewState();
// }

// class webviewState extends State<Webview> {
//   late final flutterWebViewPlugin;
//   late WebViewController _controller;
//   Completer<WebViewController> controller = Completer<WebViewController>();
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       WebView.platform = AndroidWebView();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Image.asset(
//             'images/logos/Sodexo.png',
//             scale: 10.0,
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: WebView(
//         initialUrl: context.watch<StoreOrderingPaymentprovider>().sodexourl,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (webviewcontroller) {
//           controller.complete(webviewcontroller);
//           _controller = webviewcontroller;
//         },
//         onPageFinished: (finish) async {
//           //reading response on finish
//           final response = await _controller.runJavascriptReturningResult(
//               "document.documentElement.innerText");
//           if (response.contains('Payment Failed')) {
//             print('pppppppp' + jsonDecode(response));

//             Future.delayed(Duration(seconds: 2), () async {
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => PaymentSelection()));
//               Navigator.pop(context);
//               var payresult = await context
//                   .read<StoreOrderingPaymentprovider>()
//                   .updatepaymentstatus();
//               if (payresult == '0') {
//                 showMessage('Payment failed');
//               } else if (payresult == '1') {
//                 showMessage('Payment successful');
//               }
//             });
//           } //don't forget to decode into json
//         },
//       ),
//     );
//   }
// }
