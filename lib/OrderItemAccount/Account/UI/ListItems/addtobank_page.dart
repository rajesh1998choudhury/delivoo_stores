import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/entry_field.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Themes/style.dart';
import 'package:flutter/material.dart';

class AddToBank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send to Bank',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w500)),
        titleSpacing: 0.0,
      ),
      body: Add(),
    );
  }
}

class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Available Balance',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  letterSpacing: 0.67,
                                  color: kHintColor,
                                  fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '\$ 748.50',
                        style: listTitleTextStyle.copyWith(
                            fontSize: 35.0,
                            color: kMainColor,
                            letterSpacing: 0.18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: kCardBackgroundColor,
              thickness: 8.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Bank Info',
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
                  EntryField(
                    textCapitalization: TextCapitalization.words,
                    //controller: _nameController,
                    label: 'Account Holder Name',
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.words,
                    //controller: _categoryController,
                    label: 'Bank Name',
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.none,
                    //controller: _emailController,
                    label: 'Branch Code',
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.none,
                    //controller: _emailController,
                    label: 'Account Number',
                  ),
                ],
              ),
            ),
            Divider(
              color: kCardBackgroundColor,
              thickness: 8.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: EntryField(
                textCapitalization: TextCapitalization.words,
                //controller: _addressController,
                label: 'Enter amount to transfer',
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomBar(
            text: 'Send to Bank',
            onTap: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
