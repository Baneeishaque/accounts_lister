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
  var _rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final _source = ExampleSource();
  final _searchController = TextEditingController();

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _searchController,
                      decoration:
                          const InputDecoration(labelText: 'Search by value'),
                      onSubmitted: (valueSearchKey) {
                        if (valueSearchKey.isNotEmpty) {
                          _source.filterByValue(valueSearchKey: valueSearchKey);
                        } else {
                          // TODO : No search key toast
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.text = '';
                      });
                      _source.filterByValue(passedIsClearAction: true);
                    },
                    icon: const Icon(Icons.clear)),
                IconButton(
                    onPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        _source.filterByValue(
                            valueSearchKey: _searchController.text);
                      } else {
                        // TODO : No search key toast
                      }
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
            AdvancedPaginatedDataTable(
              addEmptyRows: false,
              source: _source,
              showFirstLastButtons: true,
              rowsPerPage: _rowsPerPage,
              availableRowsPerPage: const [1, 5, 10, 50],
              onRowsPerPageChanged: (newRowsPerPage) {
                if (newRowsPerPage != null) {
                  setState(() {
                    _rowsPerPage = newRowsPerPage;
                  });
                }
              },
              columns: const [
                DataColumn(label: Text('Row no')),
                DataColumn(label: Text('Value'))
              ],
            ),
          ],
        ),
      ),

      // SingleChildScrollView(
      //   child: AdvancedPaginatedDataTable(
      //     addEmptyRows: false,
      //     source: source,
      //     showFirstLastButtons: true,
      //     rowsPerPage: rowsPerPage,
      //     availableRowsPerPage: const [1, 5, 10, 50],
      //     onRowsPerPageChanged: (newRowsPerPage) {
      //       if (newRowsPerPage != null) {
      //         setState(() {
      //           rowsPerPage = newRowsPerPage;
      //         });
      //       }
      //     },
      //     columns: const [
      //       DataColumn(label: Text('Row no')),
      //       DataColumn(label: Text('Value'))
      //     ],
      //   ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }
}
