// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../StoreOrdering/StoreOrderingProvider/StoreOrderingProvider.dart';

class ItemSearch extends SearchDelegate {
  final orderId;
  ItemSearch({Key? key, this.orderId});
  final List<String> allcaliforniaplacessuggestions = navigatorKey
      .currentState!.context
      .read<StoreOrderProvider>()
      .Invoiceitems;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            query = '';
            await context.read<StoreOrderProvider>().geInvoiceData(
                loading: true,
                orderNo: orderId != null ? orderId : "",
                phoneNumber: "",
                scanner: "",
                itemName: query);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> locationsuggestions = allcaliforniaplacessuggestions
        .where(
          (placesuggestions) => placesuggestions.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    return ListView.builder(
      itemCount: locationsuggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          locationsuggestions[index],
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineLarge!.color,
            fontSize: 14,
          ),
        ),
        onTap: () async {
          query = locationsuggestions[index];
          await context.read<StoreOrderProvider>().geInvoiceData(
              loading: true,
              orderNo: orderId != null ? orderId : "",
              phoneNumber: "",
              scanner: "",
              itemName: query);
          close(context, query);
        },
      ),
    );
  }
}

List<TextSpan> highlightOccurrences(String source, String query) {
  if (query == null ||
      query.isEmpty ||
      !source.toLowerCase().contains(query.toLowerCase())) {
    return [TextSpan(text: source)];
  }
  final matches = query.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));
    }

    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    ));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(
        text: source.substring(match.end, source.length),
      ));
    }

    lastMatchEnd = match.end;
  }
  return children;
}
