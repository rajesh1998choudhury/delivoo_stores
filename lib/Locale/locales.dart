// import 'package:delivoo_stores/Locale/languages.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:intl/locale.dart';

// class AppLocalizations {
//   final Locale? locale;
//   AppLocalizations(this.locale);

//   static Languages language = Languages();

//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }

//   static Map<String, Map<String, String>> _localizedValues = {
//     'en': language.english(),
//     'ar': language.arabic(),
//     'pt': language.portuguese(),
//     'fr': language.french(),
//     'id': language.indonesian(),
//     'es': language.spanish(),
//   };

//   String? get invalidNumber {
//     return _localizedValues[locale?.languageCode]?['invalidNumber'];
//   }

//   String? get networkError {
//     return _localizedValues[locale?.languageCode]?['networkError'];
//   }

//   String? get register {
//     return _localizedValues[locale?.languageCode]?['register'];
//   }

//   String? get invalidName {
//     return _localizedValues[locale?.languageCode]?['invalidName'];
//   }

//   String? get invalidEmail {
//     return _localizedValues[locale?.languageCode]?['invalidEmail'];
//   }

//   String? get invalidNameAndEmail {
//     return _localizedValues[locale?.languageCode]?['invalidNameAndEmail'];
//   }

//   String? get fullName {
//     return _localizedValues[locale?.languageCode]?['fullName'];
//   }

//   String? get emailAddress {
//     return _localizedValues[locale?.languageCode]?['emailAddress'];
//   }

//   String? get mobileNumber {
//     return _localizedValues[locale?.languageCode]?['mobileNumber'];
//   }

//   String? get verificationText {
//     return _localizedValues[locale?.languageCode]?['verificationText'];
//   }

//   String? get verification {
//     return _localizedValues[locale?.languageCode]?['verification'];
//   }

//   String? get checkNetwork {
//     return _localizedValues[locale?.languageCode]?['checkNetwork'];
//   }

//   String? get invalidOTP {
//     return _localizedValues[locale?.languageCode]?['invalidOTP'];
//   }

//   String? get enterVerification {
//     return _localizedValues[locale?.languageCode]?['enterVerification'];
//   }

//   String? get verificationCode {
//     return _localizedValues[locale?.languageCode]?['verificationCode'];
//   }

//   String? get resend {
//     return _localizedValues[locale?.languageCode]?['resend'];
//   }

//   String? get offlineText {
//     return _localizedValues[locale?.languageCode]?['resend'];
//   }

//   String? get onlineText {
//     return _localizedValues[locale?.languageCode]?['resend'];
//   }

//   String? get goOnline {
//     return _localizedValues[locale?.languageCode]?['resend'];
//   }

//   String? get goOffline {
//     return _localizedValues[locale?.languageCode]?['resend'];
//   }

//   String? get orders {
//     return _localizedValues[locale?.languageCode]?['orders'];
//   }

//   String? get itemSold {
//     return _localizedValues[locale?.languageCode]?['itemSold'];
//   }

//   String? get earnings {
//     return _localizedValues[locale?.languageCode]?['earnings'];
//   }

//   String? get location {
//     return _localizedValues[locale?.languageCode]?['earnings'];
//   }

//   String? get grant {
//     return _localizedValues[locale?.languageCode]?['earnings'];
//   }

//   String? get bodyText1 {
//     return _localizedValues[locale?.languageCode]?['bodyText1'];
//   }

//   String? get bodyText2 {
//     return _localizedValues[locale?.languageCode]?['bodyText2'];
//   }

//   String? get mobileText {
//     return _localizedValues[locale?.languageCode]?['mobileText'];
//   }

//   String? get continueText {
//     return _localizedValues[locale?.languageCode]?['continueText'];
//   }

//   String? get homeText {
//     return _localizedValues[locale?.languageCode]?['homeText'];
//   }

//   String? get account {
//     return _localizedValues[locale?.languageCode]?['account'];
//   }

//   String? get orderText {
//     return _localizedValues[locale?.languageCode]?['orderText'];
//   }

//   String? get tnc {
//     return _localizedValues[locale?.languageCode]?['tnc'];
//   }

//   String? get insight {
//     return _localizedValues[locale?.languageCode]?['insight'];
//   }

//   String? get wallet {
//     return _localizedValues[locale?.languageCode]?['wallet'];
//   }

//   String? get support {
//     return _localizedValues[locale?.languageCode]?['support'];
//   }

//   String? get aboutUs {
//     return _localizedValues[locale?.languageCode]?['aboutUs'];
//   }

//   String? get login {
//     return _localizedValues[locale?.languageCode]?['login'];
//   }

//   String? get logout {
//     return _localizedValues[locale?.languageCode]?['logout'];
//   }

//   String? get loggingOut {
//     return _localizedValues[locale?.languageCode]?['loggingOut'];
//   }

//   String? get areYouSure {
//     return _localizedValues[locale?.languageCode]?['areYouSure'];
//   }

//   String? get yes {
//     return _localizedValues[locale?.languageCode]?['yes'];
//   }

//   String? get no {
//     return _localizedValues[locale?.languageCode]?['no'];
//   }

//   String? get sendToBank {
//     return _localizedValues[locale?.languageCode]?['sendToBank'];
//   }

//   String? get availableBalance {
//     return _localizedValues[locale?.languageCode]?['availableBalance'];
//   }

//   String? get accountHolderName {
//     return _localizedValues[locale?.languageCode]?['accountHolderName'];
//   }

//   String? get bankName {
//     return _localizedValues[locale?.languageCode]?['bankName'];
//   }

//   String? get branchCode {
//     return _localizedValues[locale?.languageCode]?['branchCode'];
//   }

//   String? get accountNumber {
//     return _localizedValues[locale?.languageCode]?['accountNumber'];
//   }

//   String? get enterAmountToTransfer {
//     return _localizedValues[locale?.languageCode]?['enterAmountToTransfer'];
//   }

//   String? get or {
//     return _localizedValues[locale?.languageCode]!['or'];
//   }

//   String? get bankInfo {
//     return _localizedValues[locale?.languageCode]?['bankInfo'];
//   }

//   String? get aboutDelivoo {
//     return _localizedValues[locale?.languageCode]?['aboutDelivoo'];
//   }

//   String? get aboutBody {
//     return _localizedValues[locale?.languageCode]?['aboutBody'];
//   }

//   String? get ourVision {
//     return _localizedValues[locale?.languageCode]?['ourVision'];
//   }

//   String? get companyPolicy {
//     return _localizedValues[locale?.languageCode]?['companyPolicy'];
//   }

//   String? get termsOfUse {
//     return _localizedValues[locale?.languageCode]?['termsOfUse'];
//   }

//   String? get message {
//     return _localizedValues[locale?.languageCode]?['message'];
//   }

//   String? get enterMessage {
//     return _localizedValues[locale?.languageCode]?['enterMessage'];
//   }

//   String? get orWrite {
//     return _localizedValues[locale?.languageCode]?['orWrite'];
//   }

//   String? get yourWords {
//     return _localizedValues[locale?.languageCode]?['yourWords'];
//   }

//   String? get online {
//     return _localizedValues[locale?.languageCode]?['online'];
//   }

//   String? get recent {
//     return _localizedValues[locale?.languageCode]?['recent'];
//   }

//   String? get vegetable {
//     return _localizedValues[locale?.languageCode]?['vegetable'];
//   }

//   String? get today {
//     return _localizedValues[locale?.languageCode]?['today'];
//   }

//   String? get viewAll {
//     return _localizedValues[locale?.languageCode]?['viewAll'];
//   }

//   String? get editProfile {
//     return _localizedValues[locale?.languageCode]?['editProfile'];
//   }

//   String? get featureImage {
//     return _localizedValues[locale?.languageCode]?['featureImage'];
//   }

//   String? get uploadPhoto {
//     return _localizedValues[locale?.languageCode]?['uploadPhoto'];
//   }

//   String? get profileInfo {
//     return _localizedValues[locale?.languageCode]?['profileInfo'];
//   }

//   String? get gender {
//     return _localizedValues[locale?.languageCode]?['gender'];
//   }

//   String? get documentation {
//     return _localizedValues[locale?.languageCode]?['documentation'];
//   }

//   String? get govtID {
//     return _localizedValues[locale?.languageCode]?['govtID'];
//   }

//   String? get upload {
//     return _localizedValues[locale?.languageCode]?['upload'];
//   }

//   String? get updateInfo {
//     return _localizedValues[locale?.languageCode]?['updateInfo'];
//   }

//   String? get instruction {
//     return _localizedValues[locale?.languageCode]?['instruction'];
//   }

//   String? get cod {
//     return _localizedValues[locale?.languageCode]?['cod'];
//   }

//   String? get store {
//     return _localizedValues[locale?.languageCode]?['store'];
//   }

//   String? get ready {
//     return _localizedValues[locale?.languageCode]?['ready'];
//   }

//   String? get storeText {
//     return _localizedValues[locale?.languageCode]?['storeText'];
//   }

//   String? get storeProfile {
//     return _localizedValues[locale?.languageCode]?['storeProfile'];
//   }

//   String? get top {
//     return _localizedValues[locale?.languageCode]?['top'];
//   }

//   String? get payment {
//     return _localizedValues[locale?.languageCode]?['payment'];
//   }

//   String? get service {
//     return _localizedValues[locale?.languageCode]?['service'];
//   }

//   String? get sub {
//     return _localizedValues[locale?.languageCode]?['sub'];
//   }

//   String? get total {
//     return _localizedValues[locale?.languageCode]?['total'];
//   }

//   String? get sales {
//     return _localizedValues[locale?.languageCode]?['sales'];
//   }

//   String? get tomato {
//     return _localizedValues[locale?.languageCode]?['tomato'];
//   }

//   String? get onion {
//     return _localizedValues[locale?.languageCode]?['onion'];
//   }

//   String? get fingers {
//     return _localizedValues[locale?.languageCode]?['fingers'];
//   }

//   String? get closingTime {
//     return _localizedValues[locale?.languageCode]?['closingTime'];
//   }

//   String? get openingTime {
//     return _localizedValues[locale?.languageCode]?['openingTime'];
//   }

//   String? get storeTimings {
//     return _localizedValues[locale?.languageCode]?['storeTimings'];
//   }

//   String? get storeAddress {
//     return _localizedValues[locale?.languageCode]?['storeAddress'];
//   }

//   String? get address {
//     return _localizedValues[locale?.languageCode]?['address'];
//   }

//   String? get category {
//     return _localizedValues[locale?.languageCode]?['category'];
//   }

//   String? get product {
//     return _localizedValues[locale?.languageCode]?['product'];
//   }

//   String? get stock {
//     return _localizedValues[locale?.languageCode]?['stock'];
//   }

//   String? get pending {
//     return _localizedValues[locale?.languageCode]?['pending'];
//   }

//   String? get item {
//     return _localizedValues[locale?.languageCode]?['item'];
//   }

//   String? get add {
//     return _localizedValues[locale?.languageCode]?['add'];
//   }

//   String? get edit {
//     return _localizedValues[locale?.languageCode]?['edit'];
//   }

//   String? get info {
//     return _localizedValues[locale?.languageCode]?['info'];
//   }

//   String? get title {
//     return _localizedValues[locale?.languageCode]?['title'];
//   }

//   String? get enterTitle {
//     return _localizedValues[locale?.languageCode]?['enterTitle'];
//   }

//   String? get itemCategory {
//     return _localizedValues[locale?.languageCode]?['itemCategory'];
//   }

//   String? get selectCategory {
//     return _localizedValues[locale?.languageCode]?['selectCategory'];
//   }

//   String? get price {
//     return _localizedValues[locale?.languageCode]?['price'];
//   }

//   String? get enterPrice {
//     return _localizedValues[locale?.languageCode]?['enterPrice'];
//   }

//   String? get quantity {
//     return _localizedValues[locale?.languageCode]?['quantity'];
//   }

//   String? get enterQuantity {
//     return _localizedValues[locale?.languageCode]?['enterQuantity'];
//   }

//   String? get addMore {
//     return _localizedValues[locale?.languageCode]?['addMore'];
//   }

//   String? get image {
//     return _localizedValues[locale?.languageCode]?['image'];
//   }

//   String? get submit {
//     return _localizedValues[locale?.languageCode]?['submit'];
//   }
// }

// // class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
// //   const AppLocalizationsDelegate();

// //   @override
// //   Future<bool> isSupported(Locale locale) =>
// //       ['en', 'ar', 'pt', 'fr', 'id', 'es'].contains(locale.languageCode);

// //   @override
// //   Future<AppLocalizations> load(Locale locale) async {
// //     // Returning a SynchronousFuture here because an async "load" operation
// //     // isn't needed to produce an instance of AppLocalizations.
// //     return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
// //   }

// //   @override
// //   bool shouldReload(AppLocalizationsDelegate old) => false;
// // }
