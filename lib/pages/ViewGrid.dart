import 'package:flutter/material.dart';
import 'package:mydailystore/pages/CreateStorePage.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// ignore: must_be_immutable
class ViewGridPage extends StatefulWidget {
  String id;
  final data;

  ViewGridPage({super.key, required this.data, required this.id});

  @override
  State<ViewGridPage> createState() => _ViewGridPageState();
}

class _ViewGridPageState extends State<ViewGridPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateStorePage(docId: widget.id),
                ),
              );
            },
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: SfDataGrid(
        source: _DataSource(data: widget.data),
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            columnName: "Amount",
            label: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Text('Amount'),
            ),
          ),
          GridColumn(
            columnName: 'About',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text('About'),
            ),
          ),
          GridColumn(
            columnName: 'Fee',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text('Fee'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSource extends DataGridSource {
  final List data;

  _DataSource({required this.data});

  @override
  List<DataGridRow> get rows => data
      .map((d) => DataGridRow(cells: [
            DataGridCell(columnName: 'Amount', value: d['amount']),
            DataGridCell(columnName: 'About', value: d['about']),
            DataGridCell(columnName: 'Fee', value: d['fee']),
          ]))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            dataCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
