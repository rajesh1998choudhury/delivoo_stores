import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';

class InsightDetailPage extends StatefulWidget {
  @override
  _InsightDetailPageState createState() => _InsightDetailPageState();
}

class _InsightDetailPageState extends State<InsightDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insight Details',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                _createDataTable(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: _createBottomTable())),
        ],
      ),
    );
  }
}

DataTable _createDataTable() {
  return DataTable(
    columns: _createColumns(),
    rows: _createRows(),
    dividerThickness: 2,
    // dataRowHeight: 60,
    showBottomBorder: true,
    headingTextStyle:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    headingRowColor: WidgetStateProperty.resolveWith(
        (states) => kMainColor.withOpacity(0.8)),
  );
}

DataTable _createBottomTable() {
  return DataTable(
    columns: _createBottom(),
    rows: [],
    showBottomBorder: false,
    headingTextStyle:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    headingRowColor: WidgetStateProperty.resolveWith(
        (states) => kMainColor.withOpacity(0.8)),
  );
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(
        label: Text(
          'Order#',
          style: TextStyle(fontSize: 15),
        ),
        tooltip: 'Book identifier'),
    DataColumn(
        label: Text(
      'Amount',
      style: TextStyle(fontSize: 15),
    )),
    DataColumn(
        label: Text(
      'Comission',
      style: TextStyle(fontSize: 15),
    ))
  ];
}

List<DataColumn> _createBottom() {
  return [
    DataColumn(
        label: Text('Total', style: TextStyle(fontSize: 15)),
        tooltip: 'Book identifier'),
    DataColumn(
        label: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Amount', style: TextStyle(fontSize: 15)),
        Text('\₹ 300000', style: TextStyle(fontSize: 15)),
      ],
    )),
    DataColumn(
        label: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('commission', style: TextStyle(fontSize: 15)),
        Text('\₹ 200000', style: TextStyle(fontSize: 15)),
      ],
    ))
  ];
}

List<DataRow> _createRows() {
  return [
    DataRow(cells: [
      DataCell(Text('12150')),
      DataCell(Text(
        '\₹ 500',
      )),
      DataCell(Text('\₹ 200'))
    ]),
    DataRow(cells: [
      DataCell(Text('12139')),
      DataCell(Text('\₹ 600')),
      DataCell(Text('\₹ 300'))
    ]),
    DataRow(cells: [
      DataCell(Text('12150')),
      DataCell(Text(
        '\₹ 500',
      )),
      DataCell(Text('\₹ 200'))
    ]),
    DataRow(cells: [
      DataCell(Text('12139')),
      DataCell(Text('\₹ 600')),
      DataCell(Text('\₹ 300'))
    ]),
    DataRow(cells: [
      DataCell(Text('12150')),
      DataCell(Text(
        '\₹ 500',
      )),
      DataCell(Text('\₹ 200'))
    ]),
    DataRow(cells: [
      DataCell(Text('12139')),
      DataCell(Text('\₹ 600')),
      DataCell(Text('\₹ 300'))
    ]),
    DataRow(cells: [
      DataCell(Text('12150')),
      DataCell(Text(
        '\₹ 500',
      )),
      DataCell(Text('\₹ 200'))
    ]),
    DataRow(cells: [
      DataCell(Text('12139')),
      DataCell(Text('\₹ 600')),
      DataCell(Text('\₹ 300'))
    ]),
    DataRow(cells: [
      DataCell(Text('12150')),
      DataCell(Text(
        '\₹ 500',
      )),
      DataCell(Text('\₹ 200'))
    ]),
    DataRow(cells: [
      DataCell(Text('12139')),
      DataCell(Text('\₹ 600')),
      DataCell(Text('\₹ 300'))
    ]),
  ];
}
