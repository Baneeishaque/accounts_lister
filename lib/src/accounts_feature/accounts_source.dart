import 'package:accounts_lister/src/accounts_feature/accounts_full_response.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';

class AccountsSource extends AdvancedDataTableSource<Account> {
  List<Account> data = List<Account>.empty();
  int lastIndexSearchKey = -1;
  String lastValueSearchKey = '';
  bool lastIsClearAction = false;

  @override
  DataRow? getRow(int index) {
    final currentAccount = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentAccount.accountId),
      ),
      DataCell(
        Text(currentAccount.fullName),
      )
    ]);
  }

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Account>> getNextPage(
      NextPageRequest pageRequest) async {
    if (lastIsClearAction) {
      //Clear State
      return loadInitialData(pageRequest);
    } else if (lastIndexSearchKey != -1) {
      if (lastValueSearchKey.isEmpty) {
        //Index Search
        return loadFilteredData(
            data
                .where(
                    (account) => canIncludeOnFilteredDataBasedOnIndex(account))
                .toList(),
            pageRequest);
      } else {
        //Index & Value Search
        return loadFilteredData(
            data
                .where(
                    (account) => canIncludeOnFilteredDataBasedOnIndex(account))
                .where(
                    (account) => canIncludeOnFilteredDataBasedOnValue(account))
                .toList(),
            pageRequest);
      }
    } else {
      if (lastValueSearchKey.isEmpty) {
        //Initial State
        return loadInitialData(pageRequest);
      } else {
        //Value Search
        return loadFilteredData(
            data
                .where(
                    (rowData) => canIncludeOnFilteredDataBasedOnValue(rowData))
                .toList(),
            pageRequest);
      }
    }
  }

  bool canIncludeOnFilteredDataBasedOnValue(Account account) {
    return account.fullName
        .toLowerCase()
        .contains(lastValueSearchKey.toLowerCase());
  }

  bool canIncludeOnFilteredDataBasedOnIndex(Account account) =>
      account.accountId.contains(lastIndexSearchKey.toString());

  RemoteDataSourceDetails<Account> loadFilteredData(
      List<Account> filteredData, NextPageRequest pageRequest) {
    return RemoteDataSourceDetails(
        data.length,
        filteredData
            .skip(pageRequest.offset)
            .take(pageRequest.pageSize)
            .toList(),
        filteredRows: filteredData.length);
  }

  RemoteDataSourceDetails<Account> loadInitialData(
      NextPageRequest pageRequest) {
    return RemoteDataSourceDetails(
      data.length,
      data
          .skip(pageRequest.offset)
          //again in a real world example you would only get the right amount of rows
          .take(pageRequest.pageSize)
          .toList(),
    );
  }

  void filterData(
      {int indexSearchKey = -1,
      String valueSearchKey = '',
      bool isClearAction = false}) {
    lastIndexSearchKey = indexSearchKey;
    lastValueSearchKey = valueSearchKey;
    lastIsClearAction = isClearAction;
    setNextView();
  }
}
