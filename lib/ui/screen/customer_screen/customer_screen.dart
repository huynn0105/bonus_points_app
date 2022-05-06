import 'dart:async';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  late String _sortColumnName;
  late bool _sortAscending;
  int _rowsPerPage = 10;
  late ICustomerViewModel _viewModel;
  late SimpleFontelicoProgressDialog _dialog;
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ICustomerViewModel>();
    controller = TextEditingController();
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    Future.delayed(Duration.zero, () async {
      _dialog.show(message: 'Đợi một lát...');
      //await _viewModel.syncData();
      _dialog.hide();
    });
    _sortColumnName = 'browser';
    _sortAscending = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ICustomerViewModel>(builder: (_, __, ___) {
              return WebDataTable(
                header: Row(
                  children: [
                    width > 700
                        ? Text(
                            'Danh sách khách hàng',
                            style: headerStyle,
                          )
                        : SizedBox.shrink(),
                    const SizedBox(width: 20),
                    width > 830
                        ? ElevatedButton.icon(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(170, 55),
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed(MyRouter.addCustomer);
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 28,
                            ),
                            label: Text(
                              'Thêm khách hàng',
                              style: dataStyle,
                            ),
                          )
                        : FloatingActionButton(
                            onPressed: () {
                              Get.toNamed(MyRouter.addCustomer);
                            },
                            child: const Icon(
                              Icons.add,
                              size: 28,
                            )),
                  ],
                ),
                actions: [
                  SizedBox(
                    width: width / 5 + 170,
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.clear();
                                context.read<ICustomerViewModel>().isSearch =
                                    false;
                              },
                              icon: Icon(Icons.clear, color: Colors.black),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<ICustomerViewModel>()
                                    .searchCustomer(controller.text);
                              },
                              icon: Icon(Icons.search, color: Colors.black),
                            ),
                          ],
                        ),
                        hintText: 'Tìm kiếm...',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                      onSubmitted: (value) {
                        context
                            .read<ICustomerViewModel>()
                            .searchCustomer(controller.text);
                      },
                    ),
                  ),
                  width > 1300 ? SizedBox(width: 100) : SizedBox.shrink(),
                ],
                source: WebDataTableSource(
                  sortColumnName: _sortColumnName,
                  sortAscending: _sortAscending,
                  columns: [
                    WebDataColumn(
                      name: 'name',
                      label: Text(
                        'Tên khách hàng',
                        style: headerStyle,
                      ),
                      dataCell: (value) => DataCell(Text(
                        '$value',
                        style: dataStyle,
                      )),
                    ),
                    WebDataColumn(
                      name: 'phoneNumber',
                      label: Text(
                        'SĐT',
                        style: headerStyle,
                      ),
                      dataCell: (value) => DataCell(Text(
                        '$value',
                        style: dataStyle,
                      )),
                    ),
                    WebDataColumn(
                      name: 'address',
                      label: Text(
                        'Địa chỉ',
                        style: headerStyle,
                      ),
                      dataCell: (value) => DataCell(Text(
                        '$value',
                        style: dataStyle,
                      )),
                    ),
                    WebDataColumn(
                      name: 'totalPointThuong',
                      label: Text(
                        'Điểm',
                        style: headerStyle,
                      ),
                      dataCell: (value) => DataCell(Text(
                        '$value',
                        style: dataStyle,
                      )),
                    ),
                    WebDataColumn(
                      name: 'totalPointSuaLon',
                      label: Text(
                        'Điểm lon',
                        style: headerStyle,
                      ),
                      dataCell: (value) => DataCell(Text(
                        '$value',
                        style: dataStyle,
                      )),
                    ),
                    WebDataColumn(
                      name: 'tienNo',
                      label: Text(
                        'Nợ',
                        style: headerStyle,
                      ),
                      dataCell: (value) => DataCell(Text(
                        '$value',
                        style: dataStyle,
                      )),
                    ),
                    WebDataColumn(
                      name: 'customer',
                      label: Text(
                        'Tuỳ chọn',
                        style: headerStyle,
                      ),
                      sortable: false,
                      dataCell: (value) => DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _viewModel.currentCustomer = value;
                                Get.toNamed(
                                  MyRouter.detail,
                                  arguments: value,
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 34,
                                color: Color(0xffEFCD11),
                              ),
                            ),
                            const SizedBox(width: 15),
                            IconButton(
                              onPressed: () async {
                                await Get.defaultDialog(
                                  title: 'Xác nhận xoá',
                                  middleText: 'Bạn muốn xoá khách hàng này?',
                                  titleStyle: TextStyle(fontSize: 22),
                                  middleTextStyle: TextStyle(fontSize: 20),
                                  contentPadding: EdgeInsets.all(16),
                                  actions: [
                                    MyButton(
                                        width: 40,
                                        child: Text(
                                          'Huỷ bỏ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        color: Colors.grey,
                                        onPressed: () {
                                          Get.back();
                                        }),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    MyButton(
                                        width: 40,
                                        child: Text(
                                          'Xoá',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        color: Color(0xFFEA2027),
                                        onPressed: () async {
                                          _dialog.show(
                                              message: 'Chờ một lát...');
                                          await _viewModel
                                              .deleteCustomer(value);
                                          _dialog.hide();
                                          Get.back();
                                        }),
                                  ],
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.delete,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  rows: !_viewModel.isSearch
                      ? _viewModel.customerUIs.map((e) => e.values).toList()
                      : _viewModel.customersToDisplay
                          .map((e) => e.values)
                          .toList(),
                  onTapRow: (rows, index) {
                    print('onTapRow(): index = $index, row = ${rows[index]}');

                    _viewModel.currentCustomer = rows[index]['customer'];
                    Get.toNamed(
                      MyRouter.detail,
                      arguments: _viewModel.currentCustomer,
                    );
                  },
                  primaryKeyName: 'name',
                ),
                horizontalMargin: 30,
                columnSpacing: (width / 7 - 96) < 0 ? 0 : (width / 7 - 96),
                onPageChanged: (offset) {
                  print('onPageChanged(): offset = $offset');
                },
                onSort: (columnName, ascending) {
                  print(
                      'onSort(): columnName = $columnName, ascending = $ascending');
                  setState(() {
                    _sortColumnName = columnName;
                    _sortAscending = ascending;
                  });
                },
                dataRowHeight: 75,
                headingRowHeight: 70,
                onRowsPerPageChanged: (rowsPerPage) {
                  print('onRowsPerPageChanged(): rowsPerPage = $rowsPerPage');
                  setState(() {
                    if (rowsPerPage != null) {
                      _rowsPerPage = rowsPerPage;
                    }
                  });
                },
                rowsPerPage: _rowsPerPage,
              );
            }),
          ),
        ),
      ),
    );
  }
}

TextStyle dataStyle = const TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
);

TextStyle headerStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
