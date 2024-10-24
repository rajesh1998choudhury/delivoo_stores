import 'package:animation_wrappers/animation_wrappers.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Components/entry_field.dart';

class SupportPage extends StatefulWidget {
  static const String id = 'support_page';
  final String? number;

  SupportPage({this.number});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Future<void> _makePhoneCall(String url, scheme) async {
    try {
      await launchUrl(
        Uri(scheme: scheme, path: url),
      );
    } on Exception {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text('Support',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white)),
      ),
      body: FadedSlideAnimation(
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  color: Theme.of(context).cardColor,
                  child: FadedScaleAnimation(
                    child: Image(
                      image: AssetImage(
                          "images/logos/alphastore_icon.png"), //delivoo logo
                      height: 130.0,
                      width: 99.7,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 16.0),
                        child: Text(
                          'Or Write us your queries',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                        child: Text(
                          'Your words means a lot to us.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      EntryField(
                        image: 'images/icons/ic_phone.png',
                        label: 'Call us on',
                        initialValue: '+91 844 844 1068',
                        readOnly: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            _makePhoneCall('+91 844 844 1068', 'tel');
                          },
                        ),
                      ),
                      EntryField(
                        image: 'images/icons/ic_mail.png',
                        label: 'Email us at',
                        hint: 'Type your message',
                        initialValue: 'customer.care@kisanserv.com',
                        readOnly: true,
                        maxLines: 5,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.outgoing_mail,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            _makePhoneCall(
                                'customer.care@kisanserv.com', 'mailto');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 34,
                ),
              ],
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
