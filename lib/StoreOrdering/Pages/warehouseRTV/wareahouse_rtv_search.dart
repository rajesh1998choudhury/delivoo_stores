// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';

class WarehouseItemSearch extends SearchDelegate {
  final orderId;
  WarehouseItemSearch({Key? key, this.orderId});
  final List<String> allcaliforniaplacessuggestions = navigatorKey
      .currentState!.context
      .read<StoreOrderProvider>()
      .returnStoreItems;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            FocusScope.of(context).unfocus();
            query = '';
            prefs.setString('searchWReturnItem', query);
            await context.read<StoreOrderProvider>().selectedQuery(query);

            await context
                .read<StoreOrderProvider>()
                .returnWarehouseStoreItemsApi(
                    deliveryDate:
                        context.read<StoreOrderProvider>().dateValue.toString(),
                    loading: true,
                    itemName: query,
                    qr: "");
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
            color: Theme.of(context).textTheme.headlineLarge!.color,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          query = locationsuggestions[index];
          prefs.setString('searchWReturnItem', query);
          await context.read<StoreOrderProvider>().selectedQuery(query);

          await context.read<StoreOrderProvider>().returnWarehouseStoreItemsApi(
              deliveryDate:
                  context.read<StoreOrderProvider>().dateValue.toString(),
              loading: true,
              itemName: query,
              qr: "");
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
