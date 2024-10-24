// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/entry_field.dart';
import 'package:delivoo_stores/Pages/approval.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Provider/profileProvider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:delivoo_stores/geo/LocationProvider.dart';
import 'package:delivoo_stores/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//register page for registration of a new user
class RegisterPage extends StatelessWidget {
  final String phoneNumber;
  get getmobile => phoneNumber;
  RegisterPage(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    // final loginProvider = context.read<LoginProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Register',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),

      //this column contains 3 textFields and a bottom bar
      body: WillPopScope(
        onWillPop: onWillPop,
        child: FadedSlideAnimation(
          child: RegisterForm(phoneNumber),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final String phoneNumber;

  RegisterForm(this.phoneNumber);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

final TextEditingController pincodeController = TextEditingController(
    text: navigatorKey.currentState?.context
        .read<LocationServiceProvider>()
        .locationResult
        ?.postalCode
        .toString());

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _shopController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addr1Controller = TextEditingController();
  final TextEditingController _addr2Controller = TextEditingController();
  final TextEditingController pincodeController = TextEditingController(
      text: navigatorKey.currentState?.context
          .read<LocationServiceProvider>()
          .locationResult
          ?.postalCode
          .toString());
  String? svalue, cvalue, location, account, tev;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int i = 0;
  String? place;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await context
          .read<LocationServiceProvider>()
          .showPlacePicker(context)
          .then((value) {
        print('value: $value');
        pincodeController.text =
            context.read<LocationServiceProvider>().locationResult!.postalCode!;
        context
            .read<LoginProvider>()
            .checkAvailablePincode(pincodeController.text);
        if (context.read<LoginProvider>().pincodes?.d?.length == 1) {
          context
                  .read<ProfileProvider>()
                  .companyInfoDetais
                  ?.d
                  ?.companyinfo
                  ?.locationid =
              context.read<LoginProvider>().pincodes?.d?[0].locationId;
          prefs.setString(
              'LocationId',
              context
                  .read<LoginProvider>()
                  .pincodes!
                  .d![0]
                  .locationId
                  .toString());
        }
      });
    });
    super.initState();
  }

  final picker = ImagePicker();

  Future chooseImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    context.read<LoginProvider>().setImage(File(pickedImage!.path));
    //context.read<GetUserDetailsProvider>().updateProfileImage(_image);
    return;
  }

  Future clickImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    context.read<LoginProvider>().setImage(File(pickedImage!.path));
    //context.read<LoginProvider>().image = File(pickedImage!.path);

    //context.read<GetUserDetailsProvider>().updateProfileImage(_image);
    return;
  }

  Future<void> retriveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      context.read<LoginProvider>().image = response.file as File?;
    } else {
      print('Retrieve error ' + response.exception!.code);
    }
  }

  Widget _previewImage() {
    return Center(
        child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white)),
      child: (context.watch<LoginProvider>().image != null)
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.file(
                File(context.watch<LoginProvider>().image!.path),
                fit: BoxFit.cover,
              ),
            )
          : Image.asset("images/account/shop.png"),
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: ScrollPhysics(),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 8)
                        ],
                        color: kMainColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Center(
                              child: FutureBuilder<void>(
                            future: retriveLostData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return const Text('Picking an image');
                                case ConnectionState.done:
                                  return _previewImage();
                                default:
                                  return const Text('Picked an image');
                              }
                            },
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          PopupMenuButton<String>(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1,
                                      color: kWhiteColor,
                                      style: BorderStyle.solid)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      FeatherIcons.image,
                                    ),
                                    Text(
                                      "Add Image",
                                      style: TextStyle(
                                          fontSize: 10, color: kWhiteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onSelected: (value) async {
                              if (value.compareTo("Camera") == 0) {
                                clickImage();
                              } else if (value.compareTo("Gallery") == 0) {
                                chooseImage();
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      FeatherIcons.camera,
                                      color: kMainColor,
                                    ),
                                    Text("Camera"),
                                  ],
                                ),
                                value: "Camera",
                              ),
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                      color: kMainColor,
                                    ),
                                    Text("Gallery"),
                                  ],
                                ),
                                value: "Gallery",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //shopname textField
                  EntryField(
                    controller: _shopController,
                    label: 'Store Name',
                    image: 'images/icons/shop.png',
                    validator: (value) {
                      if (value!.isEmpty || value.startsWith(RegExp(r'[\s]')))
                        return 'Enter Your Shop Name';
                      else if (value.contains(RegExp(r"[;'^,]")))
                        return "cannot contain ; ^ '";
                      else
                        null;
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                    ],
                  ),
                  EntryField(
                    controller: _nameController,
                    label: "Contact Person Name",
                    image: 'images/icons/ic_name.png',
                    validator: (value) {
                      if (value!.isEmpty || value.startsWith(RegExp(r'[\s]')))
                        return 'Enter Your Name';
                      else if (RegExp(r'[!@#<>$?":_`~;[\]\\|=+)(*&^%0-9-]')
                          .hasMatch(value))
                        return 'Enter correct name';
                      else
                        return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9 ,\"@_#-+=()?!*:;!/|.%]")),
                      FilteringTextInputFormatter.deny(RegExp("['~^&`]")),
                    ],
                  ),

                  //email textField
                  EntryField(
                    controller: _emailController,
                    label: 'Email Address',
                    image: 'images/icons/ic_mail.png',
                    keyboardType: TextInputType.emailAddress,
                    // validator: (value) {
                    //   if (value == null ||
                    //       value.isEmpty ||
                    //       value == '' ||
                    //       !value.contains('@') ||
                    //       !value.contains('.'))
                    //     return 'Enter Your Email';
                    //   else {
                    //     return null;
                    //   }
                    // }
                  ),

                  //phone textField
                  EntryField(
                    enabled: false,
                    label: 'Mobile Number',
                    image: 'images/icons/ic_phone.png',
                    keyboardType: TextInputType.number,
                    initialValue: widget.phoneNumber,
                    readOnly: true,
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                    child: TextFormField(
                      controller: pincodeController,
                      onChanged: (value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (value.length == 6) {
                          context
                              .read<ProfileProvider>()
                              .companyInfoDetais
                              ?.d
                              ?.companyinfo
                              ?.locationid = "";
                          await context
                              .read<LoginProvider>()
                              .checkAvailablePincode(value);
                          if (context
                                  .read<LoginProvider>()
                                  .pincodes!
                                  .d!
                                  .length ==
                              1) {
                            prefs.setString(
                                'LocationId',
                                context
                                    .read<LoginProvider>()
                                    .pincodes!
                                    .d![0]
                                    .locationId!);
                            print(
                                "LocationId ${prefs.getString('LocationId')}");
                            await context
                                .read<LocationServiceProvider>()
                                .showPlacePicker(context);
                            print(
                                "LocationId ${prefs.getString('LocationId')}");
                          }
                          FocusScope.of(context).unfocus();
                        }
                      },
                      style: Theme.of(context).textTheme.bodySmall,
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a post code/pin code";
                        }
                        context
                            .read<ProfileProvider>()
                            .companyInfoDetais
                            ?.d
                            ?.companyinfo
                            ?.comppincode = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Postal code / Pin code*',
                        icon: Image.asset(
                          'images/icons/zip-code.png',
                          color: kMainColor,
                          height: 20,
                        ),
                      ),
                    ),
                  ),

                  context.watch<LoginProvider>().pincodes == null
                      ? Container()
                      : context.watch<LoginProvider>().pincodes!.d!.length > 1
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 8.0),
                              child: DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isDense: true,
                                value: place,
                                alignment: AlignmentDirectional.center,
                                hint: Container(
                                    width: 250,
                                    child: Text(
                                      'Select Location',
                                      textAlign: TextAlign.center,
                                    )),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 15),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: kMainColor,
                                ),
                                iconSize: 24.0,
                                elevation: 10,
                                onChanged: (String? newValue) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  setState(() {
                                    place = newValue;
                                    context
                                        .read<ProfileProvider>()
                                        .companyInfoDetais
                                        ?.d
                                        ?.companyinfo
                                        ?.locationid = newValue;
                                    print(newValue);
                                    prefs.setString('LocationId', newValue!);
                                  });
                                  await context
                                      .read<LocationServiceProvider>()
                                      .showPlacePicker(context);
                                },
                                // validator: (value) {
                                //   if (context
                                //               .read<ProfileProvider>()
                                //               .companyInfoDetais
                                //               ?.d
                                //               ?.companyinfo
                                //               ?.locationid ==
                                //           null ||
                                //       context
                                //           .read<ProfileProvider>()
                                //           .companyInfoDetais!
                                //           .d!
                                //           .companyinfo!
                                //           .locationid!
                                //           .isEmpty ||
                                //       context
                                //               .read<ProfileProvider>()
                                //               .companyInfoDetais
                                //               ?.d
                                //               ?.companyinfo
                                //               ?.locationid ==
                                //           "") {
                                //     return 'Select a place';
                                //   } else
                                //     return null;
                                // },
                                items: context
                                    .watch<LoginProvider>()
                                    .pincodes
                                    ?.d!
                                    .map<DropdownMenuItem<String>>((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.locationId,
                                    child: Text(
                                      item.locationName!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : EntryField(
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
                              enabled: false,
                              label: context
                                  .watch<LoginProvider>()
                                  .pincodes!
                                  .d![0]
                                  .locationName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                              image: 'images/icons/shop.png',
                              keyboardType: TextInputType.number,
                              readOnly: true,
                            ),
                  context.watch<LocationServiceProvider>().getAddress != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/icons/home-address.png',
                                color: kMainColor,
                                height: 20,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.86,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Text(context
                                            .watch<LocationServiceProvider>()
                                            .getAddress !=
                                        null
                                    ? context
                                        .watch<LocationServiceProvider>()
                                        .getAddress
                                    : ""),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  EntryField(
                    controller: _addr1Controller,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    label: 'Address line 1',
                    image: 'images/icons/home-address.png',
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9 ,\"@_#-+=()?!*:;!/|.%]")),
                      FilteringTextInputFormatter.deny(RegExp("['~^&`]")),
                    ],
                    validator: (value) {
                      if (value!.startsWith(RegExp(r'[\s]')))
                        return 'Enter your address';
                      if (value.contains(RegExp(r"[;'^]")))
                        return "cannot contain ; ^ '";
                      else
                        return null;
                    },
                  ),
                  EntryField(
                    controller: _addr2Controller,
                    label: 'Address line 2',
                    image: 'images/icons/home-address.png',
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-zA-Z0-9 ,\"@_#-+=()?!*:;!/|.%]")),
                      FilteringTextInputFormatter.deny(RegExp("['~^&`]")),
                    ],
                  ),

                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),

            //continue button bar
          ],
        ),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: BottomBar(
              text: 'Continue',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var response = await context
                    .read<LoginProvider>()
                    .checkAvailablePincode(pincodeController.text);
                if (response != "0") {
                  if (prefs.getString('LocationId') == null) {
                    showMessage("Select Location");
                  } else if (_formKey.currentState!.validate()) {
                    var validUser =
                        await context.read<LoginProvider>().CheckUserInfo(
                              widget.phoneNumber,
                              _emailController.text,
                            );
                    if (validUser == "validUser") {
                      var result = await context.read<LoginProvider>().register(
                            lat: context
                                .read<LocationServiceProvider>()
                                .locationResult
                                ?.latLng
                                ?.latitude
                                .toString(),
                            long: context
                                .read<LocationServiceProvider>()
                                .locationResult
                                ?.latLng
                                ?.longitude
                                .toString(),
                            name: _nameController.text,
                            pincode: pincodeController.text,
                            email: _emailController.text,
                            shopName: _shopController.text,
                            address1: _addr1Controller.text,
                            address2: _addr2Controller.text,
                            mapadress: context
                                        .read<LocationServiceProvider>()
                                        .getAddress !=
                                    null
                                ? context
                                    .read<LocationServiceProvider>()
                                    .getAddress
                                : "",
                          );
                      if (result == 'success') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Approval()));
                      }
                    }
                  }
                }
              }),
        )
      ],
    );
  }
}
