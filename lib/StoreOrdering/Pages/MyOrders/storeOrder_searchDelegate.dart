// ignore_for_file: unnecessary_null_comparison

import 'package:delivoo_stores/Provider/OrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';

class MyOrdersSearch extends SearchDelegate {
  final List<String> allcaliforniaplacessuggestions =
      navigatorKey.currentState!.context.read<StoreOrderProvider>().items;

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
            await context
                .read<OrderProvider>()
                .getPastOrders(fromdate: null, toDate: null, searchText: null);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
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
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14),
        ),
        onTap: () async {
          query = locationsuggestions[index];
          await context.read<StoreOrderProvider>().getPastOrders(
              fromdate: context.read<StoreOrderProvider>().firstDay,
              toDate: context.read<StoreOrderProvider>().lastDay,
              searchText: query);
          close(context, query);
          Navigator.pop(context);
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
      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
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
