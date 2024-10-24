import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/entry_field.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add', style: Theme.of(context).textTheme.bodyLarge),
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
            Divider(
              color: kCardBackgroundColor,
              thickness: 6.7,
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
                        'Item Image',
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
                        color: kCardBackgroundColor,
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
                      'ITEM INFO',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                              color: kHintColor),
                    ),
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.words,
                    label: 'ITEM TITLE',
                    hint: 'Enter Item Name',
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.words,
                    label: 'ITEM CATEGORY',
                    hint: 'Select Item Category',
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
                      'ITEM PRICE',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.67,
                              color: kHintColor),
                    ),
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.words,
                    label: 'ITEM PRICE',
                    hint: 'Enter Price',
                  ),
                  EntryField(
                    textCapitalization: TextCapitalization.words,
                    label: 'QUANTITY',
                    hint: 'Enter Quantity',
                  ),
                  Text('+ ADD MORE OPTIONS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 10,
                          letterSpacing: 0.5)),
                  SizedBox(
                    height: 80.0,
                  )
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomBar(
            text: 'Add',
            onTap: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
