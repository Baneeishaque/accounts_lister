import 'dart:convert';

import 'package:account_ledger_library/models/accounts_url_with_execution_status_model.dart';
import 'package:account_ledger_library/transaction_api.dart';
import 'package:accounts_lister/src/accounts_feature/accounts_full_response.dart';
import 'package:accounts_lister/src/accounts_feature/accounts_source.dart';
import 'package:accounts_lister/src/data_table_feature/data_table_view.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountsTableView extends StatefulWidget {
  const AccountsTableView({Key? key}) : super(key: key);

  static const routName = '/';

  @override
  State<AccountsTableView> createState() => _AccountsTableViewState();
}

class _AccountsTableViewState extends State<AccountsTableView> {
  late Future<AccountsFullResponse> futureAccountsFullResponse;
  var _rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final _source = AccountsSource();
  final _searchByValueController = TextEditingController();
  final _searchByIndexController = TextEditingController();
  String? _sourceUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _searchByValueController.text = '';
                  _searchByIndexController.text = '';
                  futureAccountsFullResponse = fetchAccountsFullResponse();
                });
              }),
        ],
      ),
      body: Center(
        child: FutureBuilder<AccountsFullResponse>(
            future: futureAccountsFullResponse,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                if (snapshot.data!.status == 0) {
                  _source.data = snapshot.data!.accounts;
                  return SingleChildScrollView(
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
                                  decoration: const InputDecoration(
                                      labelText: 'By index'),
                                  onSubmitted: (indexSearchKey) {
                                    if (indexSearchKey.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('No Index...'),
                                      ));
                                    } else {
                                      int? parseResult =
                                          int.tryParse(indexSearchKey);
                                      if (parseResult == null) {
                                        showInvalidIndexSnackBar(context);
                                      } else {
                                        if (_searchByValueController
                                            .text.isEmpty) {
                                          //Index Search
                                          _source.filterData(
                                              indexSearchKey: parseResult);
                                        } else {
                                          //Index & Value Search
                                          _source.filterData(
                                              indexSearchKey: parseResult,
                                              valueSearchKey:
                                                  _searchByValueController
                                                      .text);
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
                                  decoration: const InputDecoration(
                                      labelText: 'By value'),
                                  onSubmitted: (valueSearchKey) {
                                    if (valueSearchKey.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('No Value...'),
                                      ));
                                    } else {
                                      if (_searchByIndexController
                                          .text.isEmpty) {
                                        //Value Search
                                        _source.filterData(
                                            valueSearchKey: valueSearchKey);
                                      } else {
                                        //Index & Value Search
                                        int? parseResult = int.tryParse(
                                            _searchByIndexController.text);
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
                                          valueSearchKey:
                                              _searchByValueController.text);
                                    }
                                  } else {
                                    int? parseResult = int.tryParse(
                                        _searchByIndexController.text);
                                    if (parseResult == null) {
                                      showInvalidIndexSnackBar(context);
                                    } else {
                                      if (_searchByValueController
                                          .text.isEmpty) {
                                        //Index Search
                                        _source.filterData(
                                            indexSearchKey: parseResult);
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
                            DataColumn(label: Text('Index')),
                            DataColumn(label: Text('Full Name'))
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('Error, Status is ${snapshot.data!.status}');
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Text('No Data, No Error...');
              }
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchByValueController.text = '';
    _searchByIndexController.text = '';
    futureAccountsFullResponse = fetchAccountsFullResponse();
  }

  Future<AccountsFullResponse> fetchAccountsFullResponse() async {
    if (_sourceUrl == null) {
      AccountsUrlWithExecutionStatusModel accountsUrlWithExecutionStatus =
          runAccountLedgerGetAccountsUrlOperation();
      if (accountsUrlWithExecutionStatus.status == 0) {
        _sourceUrl = accountsUrlWithExecutionStatus.textData;
        return (await executeFetchAccountsFullResponse(_sourceUrl!));
      } else if (accountsUrlWithExecutionStatus.status == 1) {
        throw Exception('Error: ${accountsUrlWithExecutionStatus.error}');
      } else {
        throw Exception(
            'Error: Unknown Status Code ${accountsUrlWithExecutionStatus.status}');
      }
    }
    return (await executeFetchAccountsFullResponse(_sourceUrl!));
  }

  Future<AccountsFullResponse> executeFetchAccountsFullResponse(
      String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return AccountsFullResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load accounts...');
    }
  }
}
