import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/entry_field.dart';
import 'package:delivoo_stores/Routes/routes.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const String id = 'register_page';
  final String? phoneNumber;

  ProfilePage({this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 16.7),
        ),
      ),

      //this column contains 3 textFields and a bottom bar
      body: RegisterForm(phoneNumber!),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final String phoneNumber;

  RegisterForm(this.phoneNumber);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  get kCardBackgroundColor => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Divider(
            color: kCardBackgroundColor,
            thickness: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Feature Image',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                              color: kHintColor),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 99.0,
                      width: 99.0,
                      child: Image.asset('images/layer_1.png'),
                    ),
                    SizedBox(width: 30.0),
                    Icon(
                      Icons.camera_alt,
                      color: kMainColor,
                      size: 19.0,
                    ),
                    SizedBox(width: 14.3),
                    Text('Upload Photo',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: kMainColor)),
                  ],
                ),
                SizedBox(
                  height: 25.3,
                )
              ],
            ),
          ),
          Divider(
            color: kCardBackgroundColor,
            thickness: 8.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Store Info',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.67,
                        color: kHintColor),
                  ),
                ),
                //name textField
                EntryField(
                  textCapitalization: TextCapitalization.words,
                  label: 'Store Name',
                  initialValue: 'Silver Leaf Vegetables',
                ),
                //category textField
                EntryField(
                  textCapitalization: TextCapitalization.words,
                  label: 'Category',
                  initialValue: 'Vegetables & Fruits',
                ),
                //phone textField
                EntryField(
                  label: 'Mobile Number',
                  initialValue: '+91 9999999999',
                  readOnly: true,
                ),
                //email textField
                EntryField(
                  textCapitalization: TextCapitalization.none,
                  label: 'Email Address',
                  initialValue: 'storename@email.com',
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          Divider(
            color: kCardBackgroundColor,
            thickness: 8.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Address',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.67,
                        color: kHintColor),
                  ),
                ),
                //address textField
                EntryField(
                  textCapitalization: TextCapitalization.words,
                  label: 'Store Address',
                  image: 'images/ic_pickup pointact.png',
                  initialValue:
                      '1124, Veggy Garden, Union Market, United States ',
                ),
              ],
            ),
          ),
          Divider(
            color: kCardBackgroundColor,
            thickness: 8.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Store Timings',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.67,
                        color: kHintColor),
                  ),
                ),
                Column(
                  children: <Widget>[
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      initialValue: '8:00 am',
                      label: 'Opening Time',
                    ),
                    SizedBox(width: 20.0),
                    EntryField(
                      textCapitalization: TextCapitalization.words,
                      label: 'Closing Time',
                      initialValue: '9:00 pm',
                    ),
                  ],
                ),
              ],
            ),
          ),
          //continue button bar
          BottomBar(
              text: 'Update Info',
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.accountPage);
              })
        ],
      ),
    );
  }
}
