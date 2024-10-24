// ignore_for_file: body_might_complete_normally_nullable, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/entry_field.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Provider/profileProvider.dart';
import 'package:delivoo_stores/Provider/select_time_provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:delivoo_stores/geo/LocationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';

import '../Utils/AppConstants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _deliveryTypeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _addr1Controller = TextEditingController();
  final TextEditingController _addr2Controller = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _shopOpenController = TextEditingController();
  final TextEditingController _shopCloseController = TextEditingController();
  final TextEditingController _fssaiController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  var mobile = '';
  String? place;
  int group = 0;

  Future chooseImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);

    context.read<LoginProvider>().setImage(File(pickedImage!.path));
    return;
  }

  Future clickImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    context.read<LoginProvider>().setImage(File(pickedImage!.path));
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

  // Widget _previewImage() {
  //   return Center(
  //       child: Container(
  //     width: 100,
  //     height: 100,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         border: Border.all(color: Colors.white)),
  //     child: (context.read<LoginProvider>().image != null)
  //         ? Padding(
  //             padding: const EdgeInsets.all(2.0),
  //             child: Image.file(
  //               File(context.read<LoginProvider>().image!.path),
  //               fit: BoxFit.cover,
  //             ),
  //           )
  //         : Image.asset("images/account/shop.png"),
  //   ));
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fromTime =
        context.watch<SelectTimeProvider>().selectedTime!.format(context);
    final tillTime =
        context.watch<SelectTimeProvider>().selectedTillTime!.format(context);
    final customerInfo = context.read<ProfileProvider>().companyInfoDetais!.d;
    final shopDetails = customerInfo!.companyinfo!;
    _storeNameController.text = shopDetails.companyName.toString();
    _nameController.text = shopDetails.contactPerson.toString();
    _phoneController.text = shopDetails.phone.toString();
    _gstController.text = shopDetails.gstin.toString();
    _panController.text = shopDetails.panNo.toString();
    _addr1Controller.text = shopDetails.compaddress1.toString();
    _addr2Controller.text = shopDetails.compaddress2.toString();
    _pincodeController.text = shopDetails.comppincode.toString();

    _shopOpenController.text = shopDetails.openTime.toString();

    _shopCloseController.text = shopDetails.closeTime.toString();
    _fssaiController.text = shopDetails.fssainumber.toString();
    _deliveryTypeController.text = shopDetails.deliveryType.toString() == "1"
        ? "Quick Delivery"
        : _deliveryTypeController.text =
            shopDetails.deliveryType.toString() == "2" ? "Slot Delivery" : "";

////////////////////////////////////////////////////////////////////////
    _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length));
    _storeNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _storeNameController.text.length));
    _gstController.selection = TextSelection.fromPosition(
        TextPosition(offset: _gstController.text.length));
    _panController.selection = TextSelection.fromPosition(
        TextPosition(offset: _panController.text.length));
    _addr1Controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _addr1Controller.text.length));
    _addr2Controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _addr2Controller.text.length));
    _pincodeController.selection = TextSelection.fromPosition(
        TextPosition(offset: _pincodeController.text.length));
    _fssaiController.selection = TextSelection.fromPosition(
        TextPosition(offset: _fssaiController.text.length));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          context.read<SelectTimeProvider>().isSelected = false;
          print("false");
          return Future.value(true);
        },
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: 1.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 8)
                            ],
                            color: kMainColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Center(
                              //     child: FutureBuilder<void>(
                              //   future: retriveLostData(),
                              //   builder: (BuildContext context,
                              //       AsyncSnapshot<void> snapshot) {
                              //     switch (snapshot.connectionState) {
                              //       case ConnectionState.none:
                              //       case ConnectionState.waiting:
                              //         return const Text('Picking an image');
                              //       case ConnectionState.done:
                              //         return _previewImage();
                              //       default:
                              //         return const Text('Picked an image');
                              //     }
                              //   },
                              // )),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              // PopupMenuButton<String>(
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10),
                              //         border: Border.all(
                              //             width: 1,
                              //             color: kWhiteColor,
                              //             style: BorderStyle.solid)),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(2.0),
                              //       child: Row(
                              //         children: [
                              //           Icon(
                              //             FeatherIcons.image,
                              //           ),
                              //           Text(
                              //             "Change Image",
                              //             style: TextStyle(
                              //                 fontSize: 10, color: kWhiteColor),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              //   onSelected: (value) async {
                              //     if (value.compareTo("Camera") == 0) {
                              //       clickImage();
                              //     } else if (value.compareTo("Gallery") == 0) {
                              //       chooseImage();
                              //     }
                              //   },
                              //   itemBuilder: (context) => [
                              //     PopupMenuItem(
                              //       child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceEvenly,
                              //         children: [
                              //           Icon(
                              //             FeatherIcons.camera,
                              //             color: kMainColor,
                              //           ),
                              //           Text("Camera"),
                              //         ],
                              //       ),
                              //       value: "Camera",
                              //     ),
                              //     PopupMenuItem(
                              //       child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceEvenly,
                              //         children: [
                              //           Icon(
                              //             Icons.photo_library,
                              //             color: kMainColor,
                              //           ),
                              //           Text("Gallery"),
                              //         ],
                              //       ),
                              //       value: "Gallery",
                              //     ),
                              //   ],
                              // ),

                              // Container(
                              //   width: 100,
                              //   height: 100,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5),
                              //       border: Border.all(color: Colors.white)),
                              //   child: shopDetails.imgpath != null &&
                              //           shopDetails.imgpath != ""
                              //       ? Padding(
                              //           padding: const EdgeInsets.all(2.0),
                              //           child: CachedNetworkImage(
                              //             imageUrl: BaseUrl +
                              //                 "companyImages/" +
                              //                 shopDetails.imgpath!,
                              //             fit: BoxFit.fill,
                              //           ),
                              //         )
                              //       : Image.asset("images/account/shop.png"),
                              // ),
                              Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.white),
                                    image: shopDetails.imgpath != null &&
                                            shopDetails.imgpath != ""
                                        ? DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                BaseUrl +
                                                    "companyImages/" +
                                                    shopDetails.imgpath!,
                                                cacheKey: shopDetails.imgpath),
                                            onError:
                                                (exception, stackTrace) async {
                                              await context
                                                  .read<ProfileProvider>()
                                                  .notifyImage();
                                            },
                                          )
                                        : DecorationImage(
                                            image: AssetImage(
                                                'images/account/shop.png')),
                                  )),

                              SizedBox(
                                width: 10,
                              ),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    shopDetails.companyName ?? "",
                                    style: TextStyle(color: kWhiteColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Storename textField
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          readOnly:
                              context.watch<LoginProvider>().storeType == "0"
                                  ? true
                                  : false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _storeNameController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.startsWith(RegExp(r'[\s]')))
                              return 'Enter Your Shop Name';
                            else if (value.contains(RegExp(r"[;'^,]")))
                              return "cannot contain ; ^ '";
                            else
                              shopDetails.companyName = value;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ]")),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Shop Name',
                            hintText: 'Enter your Shop name',
                            icon: Image.asset(
                              'images/icons/shop.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          readOnly:
                              context.watch<LoginProvider>().storeType == "0"
                                  ? true
                                  : false,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 21) {
                              return 'Please enter Name, Max 20 characters';
                            }
                            shopDetails.contactPerson = value;
                            shopDetails.contactPerson = _nameController.text;
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ]")),
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Contact Person Name',
                            hintText: 'Enter your name',
                            icon: Image.asset(
                              'images/icons/ic_name.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),

                      //phone textField
                      EntryField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _phoneController,
                        enabled: false,
                        label: 'Mobile Number',
                        style: TextStyle(color: Colors.grey),
                        image: 'images/icons/ic_phone.png',
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),
                      //GST textField
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          readOnly:
                              context.watch<LoginProvider>().storeType == "0"
                                  ? true
                                  : false,
                          style: Theme.of(context).textTheme.bodySmall,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _gstController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.startsWith(RegExp(r'[\s]')))
                              return 'Enter Correct Gst Number';
                            else if (value.contains(RegExp(r"[;'^,]")))
                              return "cannot contain ; ^ '";
                            else
                              shopDetails.gstin = value;
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ]")),
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'GST Number',
                            icon: Image.asset(
                              'images/icons/tax.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      //Pan textField
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          readOnly:
                              context.watch<LoginProvider>().storeType == "0"
                                  ? true
                                  : false,
                          style: Theme.of(context).textTheme.bodySmall,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _panController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.startsWith(RegExp(r'[\s]')))
                              return 'Enter Correct PAN';
                            else if (value.contains(RegExp(r"[;'^,]")))
                              return "cannot contain ; ^ '";
                            else
                              shopDetails.panNo = value;
                            shopDetails.panNo = _panController.text;
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ]")),
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'PAN Number',
                            icon: Image.asset(
                              'images/icons/credit-card.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      //fssai number
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          readOnly:
                              context.watch<LoginProvider>().storeType == "0"
                                  ? true
                                  : false,
                          style: Theme.of(context).textTheme.bodySmall,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _fssaiController,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.startsWith(RegExp(r'[\s]')))
                              return 'Enter Correct FSSAI';
                            else if (value.contains(RegExp(r"[;'^,]")))
                              return "cannot contain ; ^ '";
                            else
                              shopDetails.fssainumber = value;
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ]")),
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'FSSAI Number',
                            icon: Image.asset(
                              'images/icons/diet.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          readOnly:
                              context.watch<LoginProvider>().storeType == "0"
                                  ? true
                                  : false,
                          controller: _pincodeController,
                          onChanged: (value) async {
                            if (value.length == 6) {
                              shopDetails.locationid = "";
                              shopDetails.locationName = "";
                              var response = await context
                                  .read<LoginProvider>()
                                  .checkAvailablePincode(value);
                              if (response != "0") {
                                if (context
                                        .read<LoginProvider>()
                                        .pincodes!
                                        .d!
                                        .length ==
                                    1) {
                                  shopDetails.locationid = context
                                      .read<LoginProvider>()
                                      .pincodes!
                                      .d![0]
                                      .locationId;

                                  await context
                                      .read<LocationServiceProvider>()
                                      .showPlacePicker(context)
                                      .then((value) {
                                    context
                                        .read<ProfileProvider>()
                                        .changeAddress(context
                                                    .read<
                                                        LocationServiceProvider>()
                                                    .getAddress !=
                                                null
                                            ? context
                                                .read<LocationServiceProvider>()
                                                .getAddress
                                            : "");
                                  });
                                }
                              } else {
                                _pincodeController.text = "";
                                shopDetails.comppincode = "";
                                context
                                    .read<ProfileProvider>()
                                    .companyInfoDetais
                                    ?.d
                                    ?.companyinfo
                                    ?.locationName = "";
                                context
                                    .read<LoginProvider>()
                                    .pincodes!
                                    .d![0]
                                    .locationName = "";
                                context.read<LoginProvider>().pincodes?.d = [];
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
                            shopDetails.comppincode = value;
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Postal code / Pin code*',
                            icon: Image.asset(
                              'images/icons/zip-code.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      context.watch<LoginProvider>().pincodes!.d!.length > 1
                          ? Padding(
                              padding: EdgeInsets.only(left: 40, right: 8),
                              child: DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                isDense: true,
                                value: place,
                                alignment: AlignmentDirectional.center,
                                hint: Container(
                                    width: 250,
                                    child: Text(
                                      context
                                                      .watch<ProfileProvider>()
                                                      .companyInfoDetais
                                                      ?.d
                                                      ?.companyinfo
                                                      ?.locationName ==
                                                  null ||
                                              context
                                                      .watch<ProfileProvider>()
                                                      .companyInfoDetais
                                                      ?.d
                                                      ?.companyinfo
                                                      ?.locationName ==
                                                  ""
                                          ? 'Select a place'
                                          : context
                                              .watch<ProfileProvider>()
                                              .companyInfoDetais!
                                              .d!
                                              .companyinfo!
                                              .locationName!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
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
                                onChanged:
                                    context.watch<LoginProvider>().storeType ==
                                            "0"
                                        ? null
                                        : (String? newValue) async {
                                            setState(() {
                                              place = newValue;
                                              shopDetails.locationid = newValue;
                                            });
                                            await context
                                                .read<LocationServiceProvider>()
                                                .showPlacePicker(context)
                                                .then((value) {
                                              context
                                                  .read<ProfileProvider>()
                                                  .changeAddress(context
                                                              .read<
                                                                  LocationServiceProvider>()
                                                              .getAddress !=
                                                          null
                                                      ? context
                                                          .read<
                                                              LocationServiceProvider>()
                                                          .getAddress
                                                      : "");
                                            });
                                          },
                                validator: (value) {
                                  if (shopDetails.locationid == null ||
                                      shopDetails.locationid!.isEmpty ||
                                      shopDetails.locationid == "") {
                                    return 'Select a place';
                                  } else
                                    return null;
                                },
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
                                          .d!
                                          .length >
                                      0
                                  ? context
                                      .watch<LoginProvider>()
                                      .pincodes!
                                      .d![0]
                                      .locationName!
                                  : "Invalid Pincode",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14),
                              image: 'images/icons/shop.png',
                              keyboardType: TextInputType.number,
                              readOnly: true,
                            ),
                      context
                                  .watch<ProfileProvider>()
                                  .companyInfoDetais!
                                  .d
                                  ?.companyinfo
                                  ?.mapAddress !=
                              ""
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
                                    width: MediaQuery.of(context).size.width *
                                        0.86,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: Text(context
                                        .watch<ProfileProvider>()
                                        .companyInfoDetais!
                                        .d!
                                        .companyinfo!
                                        .mapAddress!),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      // Container(
                      //     width: MediaQuery.of(context).size.width * 0.86,
                      //     decoration: BoxDecoration(
                      //       border: Border(
                      //         bottom: BorderSide(color: Colors.grey),
                      //       ),
                      //     ),
                      //     child: Text('No Adress Selected'),
                      //   ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _addr1Controller,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.startsWith(RegExp(r'[\s]')))
                              return 'Enter Address 1';
                            else if (value.contains(RegExp(r"[;'^]")))
                              return "cannot contain ; ^ '";
                            else
                              shopDetails.compaddress1 = value;
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ,\"@_#-+=()?!*:;!/|.%]")),
                            FilteringTextInputFormatter.deny(RegExp("['~^&`]")),
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Address line 1',
                            icon: Image.asset(
                              'images/icons/home-address.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          autofocus: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _addr2Controller,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.startsWith(RegExp(r'[\s]')))
                              return 'Enter Address 2';
                            else if (value.contains(RegExp(r"[;'^]")))
                              return "cannot contain ; ^ '";
                            else
                              shopDetails.compaddress2 = value;
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9 ,\"@_#-+=()?!*:;!/|.%]")),
                            FilteringTextInputFormatter.deny(RegExp("['~^&`]")),
                            UpperCaseTextFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Address line 2',
                            icon: Image.asset(
                              'images/icons/home-address.png',
                              color: kMainColor,
                              height: 20,
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      //Delivery type
                    ],
                  ),
                ),
                //shop opening time textField
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    readOnly: true,
                    onTap: () {
                      context.read<SelectTimeProvider>().isSelected = true;
                      context.read<SelectTimeProvider>().pickTime(context);
                      _shopOpenController.text = fromTime;
                    },
                    style: Theme.of(context).textTheme.bodySmall,
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _shopOpenController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Select shop opening time";
                      }
                      _shopOpenController.text = fromTime;
                      shopDetails.openTime = _shopOpenController.text;
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Shop Opening Time',
                      icon: Image.asset(
                        'images/icons/open.png',
                        color: kMainColor,
                        height: 20,
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                //shop closing time textField
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      context
                          .read<SelectTimeProvider>()
                          .pickTillTime(context, shopDetails.openTime);
                      _shopCloseController.text = tillTime;
                    },
                    style: Theme.of(context).textTheme.bodySmall,
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _shopCloseController,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == fromTime) {
                        return "Please Select shop Closing time";
                      } else
                        _shopCloseController.text = tillTime;
                      shopDetails.closeTime = _shopCloseController.text;

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Shop Closing Time',
                      icon: Image.asset(
                        'images/icons/closed-sign.png',
                        color: kMainColor,
                        height: 20,
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                context.watch<LoginProvider>().storeType == "0"
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Delivery Type',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 15),
                            ),
                            RadioListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(
                                "Quick Delivery",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              groupValue: context
                                          .watch<ProfileProvider>()
                                          .companyInfoDetais!
                                          .d!
                                          .companyinfo!
                                          .deliveryType !=
                                      ""
                                  ? int.parse(context
                                      .watch<ProfileProvider>()
                                      .companyInfoDetais!
                                      .d!
                                      .companyinfo!
                                      .deliveryType!)
                                  : null,
                              onChanged: (value) {
                                context
                                    .read<ProfileProvider>()
                                    .setDeliveryType(value.toString());
                              },
                              value: 1,
                              activeColor: kMainColor,
                            ),
                            RadioListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(
                                "Slot Delivery",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              groupValue: context
                                          .watch<ProfileProvider>()
                                          .companyInfoDetais!
                                          .d!
                                          .companyinfo!
                                          .deliveryType !=
                                      ""
                                  ? int.parse(context
                                      .watch<ProfileProvider>()
                                      .companyInfoDetais!
                                      .d!
                                      .companyinfo!
                                      .deliveryType!)
                                  : null,
                              onChanged: (value) {
                                context
                                    .read<ProfileProvider>()
                                    .setDeliveryType(value.toString());
                              },
                              value: 2,
                              activeColor: kMainColor,
                            )
                          ],
                        ),
                      ),
                SizedBox(
                  height: 100,
                )
                //continue button bar
              ],
            ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: BottomBar(
                  text: 'Update',
                  onTap: () async {
                    print(shopDetails.locationid);
                    print(shopDetails.comppincode);
                    if (shopDetails.openTime == null ||
                        shopDetails.openTime == "" ||
                        shopDetails.closeTime == null ||
                        shopDetails.closeTime == "") {
                      showMessage(
                          "Please select valid time for shop open and close.");
                    } else if (context.read<LoginProvider>().storeType == "1" ||
                        context.read<LoginProvider>().storeType == "2") {
                      if (shopDetails.deliveryType == "" ||
                          shopDetails.deliveryType == null) {
                        print("select delivery type");
                        showMessage("Please select delivery type");
                      } else {
                        print("1");
                        updateDetails(context);
                      }
                    } else {
                      print("2");
                      updateDetails(context);
                    }
                    context.read<SelectTimeProvider>().isSelected = false;
                  }),
            )
          ],
        ),
      ),
    );
  }

  void updateDetails(ctx) async {
    var response = await context
        .read<LoginProvider>()
        .checkAvailablePincode(_pincodeController.text);
    if (response != "0") {
      if (_formKey.currentState!.validate()) {
        var result = await context.read<ProfileProvider>().UpdateProfile(
              context
                          .read<LocationServiceProvider>()
                          .locationResult
                          ?.latLng
                          ?.latitude !=
                      null
                  ? context
                      .read<LocationServiceProvider>()
                      .locationResult
                      ?.latLng
                      ?.latitude
                      .toString()
                  : context
                      .read<ProfileProvider>()
                      .companyInfoDetais!
                      .d!
                      .companyinfo!
                      .latitude,
              context
                          .read<LocationServiceProvider>()
                          .locationResult
                          ?.latLng
                          ?.longitude !=
                      null
                  ? context
                      .read<LocationServiceProvider>()
                      .locationResult
                      ?.latLng
                      ?.longitude
                      .toString()
                  : context
                      .read<ProfileProvider>()
                      .companyInfoDetais!
                      .d!
                      .companyinfo!
                      .longitude,
            );
        if (result == 'success') {
          Navigator.pop(ctx);
          Fluttertoast.showToast(
              msg: "Details Updated Sucessfully....",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
        }
      }
    }
  }
}
