import 'package:accounts_lister/src/data_table_feature/row_data.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';

class ExampleSource extends AdvancedDataTableSource<RowData> {
  final data = List<RowData>.generate(
      13, (index) => RowData(index, 'Value for no. $index'));
  String lastValueSearchKey = '';
  bool isClearAction = false;

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
    if (lastValueSearchKey.isEmpty || isClearAction) {
      return RemoteDataSourceDetails(
        data.length,
        data
            .skip(pageRequest.offset)
            //again in a real world example you would only get the right amount of rows
            .take(pageRequest.pageSize)
            .toList(),
      );
    } else {
      List<RowData> filteredData = data
          .where((rowData) => rowData.value
              .toLowerCase()
              .contains(lastValueSearchKey.toLowerCase()))
          .toList();
      return RemoteDataSourceDetails(
          data.length,
          filteredData
              .skip(pageRequest.offset)
              .take(pageRequest.pageSize)
              .toList(),
          filteredRows: filteredData.length);
    }
  }

  void filterByValue(
      {String valueSearchKey = '', bool passedIsClearAction = false}) {
    lastValueSearchKey = valueSearchKey;
    isClearAction = passedIsClearAction;
    setNextView();
  }
}
