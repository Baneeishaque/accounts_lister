import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:accounts_lister/src/data_table_feature/example_source.dart';

class DataTableView extends StatefulWidget {
  const DataTableView({Key? key}) : super(key: key);

  static const routName = '/';

  @override
  State<DataTableView> createState() => _DataTableViewState();
}

class _DataTableViewState extends State<DataTableView> {
  var rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final source = ExampleSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // TODO : Refresh Data
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: AdvancedPaginatedDataTable(
          addEmptyRows: false,
          source: source,
          showFirstLastButtons: true,
          rowsPerPage: rowsPerPage,
          availableRowsPerPage: const [1, 5, 10, 50],
          onRowsPerPageChanged: (newRowsPerPage) {
            if (newRowsPerPage != null) {
              setState(() {
                rowsPerPage = newRowsPerPage;
              });
            }
          },
          columns: const [
            DataColumn(label: Text('Row no')),
            DataColumn(label: Text('Value'))
          ],
        ),
      ),
    );
  }
}
