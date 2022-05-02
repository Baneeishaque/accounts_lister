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
  final _searchByValueController = TextEditingController();
  final _searchByIndexController = TextEditingController();

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
                      controller: _searchByIndexController,
                      decoration: const InputDecoration(labelText: 'By index'),
                      onSubmitted: (indexSearchKey) {
                        if (indexSearchKey.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('No Index...'),
                          ));
                        } else {
                          int? parseResult = int.tryParse(indexSearchKey);
                          if (parseResult == null) {
                            showInvalidIndexSnackBar(context);
                          } else {
                            if (_searchByValueController.text.isEmpty) {
                              //Index Search
                              _source.filterData(indexSearchKey: parseResult);
                            } else {
                              //Index & Value Search
                              _source.filterData(
                                  indexSearchKey: parseResult,
                                  valueSearchKey:
                                      _searchByValueController.text);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _searchByValueController,
                      decoration: const InputDecoration(labelText: 'By value'),
                      onSubmitted: (valueSearchKey) {
                        if (valueSearchKey.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('No Value...'),
                          ));
                        } else {
                          if (_searchByIndexController.text.isEmpty) {
                            //Value Search
                            _source.filterData(valueSearchKey: valueSearchKey);
                          } else {
                            //Index & Value Search
                            int? parseResult =
                                int.tryParse(_searchByIndexController.text);
                            if (parseResult == null) {
                              showInvalidIndexSnackBar(context);
                            } else {
                              _source.filterData(
                                  indexSearchKey: parseResult,
                                  valueSearchKey: valueSearchKey);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _searchByValueController.text = '';
                      });
                      _source.filterData(isClearAction: true);
                    },
                    icon: const Icon(Icons.clear)),
                IconButton(
                    onPressed: () {
                      if (_searchByIndexController.text.isEmpty) {
                        if (_searchByValueController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('No Search Key...'),
                          ));
                        } else {
                          //Value Search
                          _source.filterData(
                              valueSearchKey: _searchByValueController.text);
                        }
                      } else {
                        int? parseResult =
                            int.tryParse(_searchByIndexController.text);
                        if (parseResult == null) {
                          showInvalidIndexSnackBar(context);
                        } else {
                          if (_searchByValueController.text.isEmpty) {
                            //Index Search
                            _source.filterData(indexSearchKey: parseResult);
                          } else {
                            //Index &Value Search
                            _source.filterData(
                                indexSearchKey: parseResult,
                                valueSearchKey: _searchByValueController.text);
                          }
                        }
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
                DataColumn(label: Text('Row No.')),
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

  void showInvalidIndexSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Invalid Index...'),
    ));
  }

  @override
  void initState() {
    super.initState();
    _searchByValueController.text = '';
    _searchByIndexController.text = '';
  }
}
