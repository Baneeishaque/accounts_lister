import 'package:accounts_lister/src/data_table_feature/row_data.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';

class ExampleSource extends AdvancedDataTableSource<RowData> {
  final data = List<RowData>.generate(
      13, (index) => RowData(index, 'Value for no. $index'));
  int lastIndexSearchKey = -1;
  String lastValueSearchKey = '';
  bool lastIsClearAction = false;

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Text(currentRowData.index.toString()),
      ),
      DataCell(
        Text(currentRowData.value),
      )
    ]);
  }

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<RowData>> getNextPage(
      NextPageRequest pageRequest) async {
    if (lastIsClearAction) {
      //Clear State
      return loadInitialData(pageRequest);
    } else if (lastIndexSearchKey != -1) {
      if (lastValueSearchKey.isEmpty) {
        //Index Search
        return loadFilteredData(
            data
                .where((rowData) => rowData.index == lastIndexSearchKey)
                .toList(),
            pageRequest);
      } else {
        //Index & Value Search
        return loadFilteredData(
            data
                .where((rowData) => rowData.index == lastIndexSearchKey)
                .where((rowData) => rowData.value
                    .toLowerCase()
                    .contains(lastValueSearchKey.toLowerCase()))
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
                .where((rowData) => rowData.value
                    .toLowerCase()
                    .contains(lastValueSearchKey.toLowerCase()))
                .toList(),
            pageRequest);
      }
    }
  }

  RemoteDataSourceDetails<RowData> loadFilteredData(
      List<RowData> filteredData, NextPageRequest pageRequest) {
    return RemoteDataSourceDetails(
        data.length,
        filteredData
            .skip(pageRequest.offset)
            .take(pageRequest.pageSize)
            .toList(),
        filteredRows: filteredData.length);
  }

  RemoteDataSourceDetails<RowData> loadInitialData(
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
