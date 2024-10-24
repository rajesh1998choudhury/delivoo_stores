// ignore_for_file: must_be_immutable, non_constant_identifier_names, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:delivoo_stores/Auth/Verification/UI/verification_page.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number_picker/mobile_number_picker.dart';
import 'package:provider/provider.dart';
//import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class MobileInput extends StatefulWidget with ChangeNotifier {
  late String m;
  get getm => m;

  @override
  _MobileInputState createState() => _MobileInputState();
}

class _MobileInputState extends State<MobileInput> {
  ApiProvider apiProvider = ApiProvider();

  MobileNumberPicker mobileNumber = MobileNumberPicker();
  MobileNumber mobileNumberObject = MobileNumber();

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  fk() => _formKey;
  String? isoCode;
  int? m_no;
  late String m;
  LoginProvider loginProvider = LoginProvider();

  get inputFormatters => null;

  String? signature;

  @override
  void initState() {
    super.initState();
    // _getSignatureCode();
    context.read<LoginProvider>().isnumselected = false;
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => mobileNumber.mobileNumber());

    mobileNumber.getMobileNumberStream.listen((event) {
      if (event!.states == PhoneNumberStates.PhoneNumberSelected) {
        setState(() {
          mobileNumberObject = event;
        });
        _controller.text = mobileNumberObject.phoneNumber!;
        context.read<LoginProvider>().isnumselected = true;
      }
    });
  }

  // _getSignatureCode() async {
  //   signature = await SmsVerification.getAppSignature();
  //   print("signature $signature");
  // }

  @override
  void dispose() {
    mobileNumber.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          CountryCodePicker(
            onChanged: (value) {
              isoCode = value.code;
            },
            builder: (value) => buildButton(value),
            initialSelection: '+91',
            textStyle: Theme.of(context).textTheme.bodySmall,
            showFlag: false,
            showFlagDialog: true,
            favorite: ['+91', 'US'],
          ),
          SizedBox(
            width: 10.0,
          ),
          //takes phone number as input
          Expanded(
            child: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                style: Theme.of(context).textTheme.headlineMedium,
                controller: _controller,
                keyboardType: TextInputType.number,
                readOnly: false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(color: Colors.grey),
                    counterText: ''),

                onChanged: (value) async {
                  context.read<LoginProvider>().isnumselected = false;
                  if (value.indexOf('1') == 0) {
                    setState(() {
                      m_no = 11;
                    });
                  } else
                    setState(() {
                      m_no = 10;
                    });
                  print(m_no);
                },

                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(m_no),
                ],

                validator: (value) {
                  if (value!.isEmpty) {
                    //showMessage('Enter a Mobile Number');
                    return 'Enter a Mobile Number';
                  }
                  if (value.length < 10 || value.startsWith(RegExp(r'[0]'))) {
                    //showMessage('Enter a valid Mobile Number');
                    return 'Invalid Mobile Number';
                  }
                  return null;
                },
                //border: InputBorder.none,
              ),
            ),
          ),

          //if phone number is valid, button gets enabled and takes to register screen
          ElevatedButton(
            child: Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1),
              backgroundColor: kMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                print(_controller.text.substring(_controller.text.length - 10));

                widget.m =
                    _controller.text.substring(_controller.text.length - 10);

                var result = await context
                    .read<LoginProvider>()
                    .sendOtp(_controller.text, signature);
                if (context.read<LoginProvider>().isnumselected == true) {
                  await context.read<LoginProvider>().getOTP();
                }
                if (result == '1') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VerificationPage(_controller.text),
                      ));
                } else {
                  final internet = await InternetAddress.lookup('google.com');
                  if (internet.isNotEmpty &&
                      internet[0].rawAddress.isNotEmpty) {
                    showSnackBar(
                        content:
                            'This Number is already registered with Kisanserv($result).Kindly use another Number.',
                        context: context);
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  buildButton(CountryCode? isoCode) {
    return Row(
      children: <Widget>[
        Text(
          '$isoCode',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  authUser() {
    if (_formKey.currentState!.validate()) {
      String requestJson = jsonEncode({
        'membermobileno': _controller.text,
      });
    }
  }
}
