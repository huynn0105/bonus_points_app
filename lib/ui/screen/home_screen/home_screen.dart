import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/enum.dart';
import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ICustomerViewModel viewModel;
  late SimpleFontelicoProgressDialog _dialog;

  late List<CustomerUIModel> filteredElements;

  bool isSearch = false;
  late FocusNode focusScope;

  @override
  void initState() {
    viewModel = context.read<ICustomerViewModel>();
    focusScope = FocusNode();
    focusScope.addListener(() {
      if (focusScope.hasFocus) {
        isSearch = true;
      } else {
        isSearch = false;
      }
    });

    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    Future.delayed(Duration.zero, () async {
      _dialog.show(message: 'Đợi một lát...');
      await viewModel.syncData();
      _dialog.hide();
    });
    super.initState();
  }

  @override
  void dispose() {
    focusScope.dispose();
    super.dispose();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = viewModel.customerUIs
          .where((e) =>
              e.name.toUpperCase().contains(s) ||
              e.phoneNumber!.toUpperCase().contains(s))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');
    return Selector<ICustomerViewModel, Types>(
        selector: (_, _vm) => _vm.selectType,
        builder: (_, __, ___) => Scaffold(
              appBar: AppBar(
                backgroundColor: viewModel.selectType != Types.Thuong
                    ? Colors.amber
                    : Colors.blue,
                title: Text(viewModel.selectType == Types.Thuong
                    ? 'Tích điểm thường'
                    : 'Tích điểm sữa hợp'),
                centerTitle: true,
                elevation: 0,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color(0xFFF5F6F7),
              body: Center(
                child: SizedBox(
                  width: 1.sw - 0.3.sw,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  textInputAction: TextInputAction.search,
                                  focusNode: focusScope,
                                  onChanged: _filterElements,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.search, color: Colors.black),
                                    hintText: "Tìm kiếm khách hàng...",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              FloatingActionButton.extended(
                                heroTag: 'btn2',
                                onPressed: () {
                                  Get.toNamed(MyRouter.addCustomer);
                                },
                                icon: Icon(Icons.add),
                                backgroundColor: Colors.green,
                                label: Text('Thêm khách hàng'),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Expanded(
                            child: Consumer<ICustomerViewModel>(
                              builder: (_, _viewModel, __) => _viewModel
                                      .customerUIs.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: isSearch
                                          ? filteredElements.length
                                          : _viewModel.customerUIs.length,
                                      itemBuilder: (ctx, index) {
                                        final CustomerUIModel customer =
                                            isSearch
                                                ? filteredElements[index]
                                                : _viewModel.customerUIs[index];
                                        return Card(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 8.h,
                                          ),
                                          color: index % 2 == 0
                                              ? Colors.grey[50]
                                              : null,
                                          child: InkWell(
                                            onTap: () {
                                              Get.toNamed(
                                                MyRouter.detail,
                                                arguments: customer,
                                              );
                                            },
                                            onLongPress: () {
                                              Get.defaultDialog(
                                                  title: 'Xác nhận xoá',
                                                  middleText:
                                                      'Bạn muốn xoá khách ${customer.name}?',
                                                  textConfirm: 'Xoá',
                                                  textCancel: 'Huỷ bỏ',
                                                  confirmTextColor:
                                                      Colors.white,
                                                  cancelTextColor:
                                                      Color(0xFFEA2027),
                                                  buttonColor:
                                                      Color(0xFFEA2027),
                                                  onConfirm: () async {
                                                    await _viewModel
                                                        .deleteCustomer(
                                                            customer);
                                                    Get.back();
                                                  });
                                            },
                                            child: ListTile(
                                              leading: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              minLeadingWidth: 10.w,
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          customer.name,
                                                          style: TextStyle(
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(height: 4.h),
                                                        Text(
                                                          'Sđt: ${customer.phoneNumber!}',
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(height: 3.h),
                                                        Text(
                                                          'Địa chỉ ${customer.address}',
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    '${format.format(customer.pointTotal)}đ',
                                                    style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  IconButton(
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                        title: 'Xác nhận xoá',
                                                        middleText:
                                                            'Bạn muốn xoá khách hàng này?',
                                                        titleStyle: TextStyle(
                                                            fontSize: 22),
                                                        middleTextStyle:
                                                            TextStyle(
                                                                fontSize: 20),
                                                        contentPadding:
                                                            EdgeInsets.all(16),
                                                        actions: [
                                                          MyButton(
                                                              width: 40,
                                                              child: Text(
                                                                'Huỷ bỏ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              color:
                                                                  Colors.grey,
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
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              color: Color(
                                                                  0xFFEA2027),
                                                              onPressed:
                                                                  () async {
                                                                _dialog.show(
                                                                    message:
                                                                        'Chờ một lát...');
                                                                await _viewModel
                                                                    .deleteCustomer(
                                                                        customer);
                                                                _dialog.hide();
                                                                Get.back();
                                                              }),
                                                        ],
                                                      );
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons
                                                          .delete_solid,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  : ListView(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 150.h),
                                          child: Center(
                                            child: Text(
                                              !isSearch
                                                  ? 'Chưa có khách hàng'
                                                  : 'Không tìm thấy khách hàng',
                                              style: TextStyle(fontSize: 17.sp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Selector<ICustomerViewModel, Types>(
                      selector: (_, _vm) => _vm.selectType,
                      builder: (_, ___, __) {
                        return FloatingActionButton.extended(
                          heroTag: 'btn5',
                          onPressed: () async {
                            _dialog.show(message: 'Chờ một lát...');
                            if (viewModel.selectType == Types.Thuong)
                              await viewModel.selectTypes(Types.SuaHop);
                            else {
                              await viewModel.selectTypes(Types.Thuong);
                            }
                            _dialog.hide();
                          },
                          label: Text(
                            viewModel.selectType == Types.Thuong
                                ? 'Tích điểm sữa hợp'
                                : 'Tích điểm thường',
                          ),
                          icon: Icon(Icons.store_mall_directory_rounded),
                          backgroundColor: viewModel.selectType == Types.Thuong
                              ? Colors.amber
                              : Colors.blue,
                        );
                      }),
                  SizedBox(width: 10.w),
                  FloatingActionButton.extended(
                    heroTag: 'btn1',
                    onPressed: () async {
                      _dialog.show(message: 'Chờ một lát...');
                      await viewModel.syncData();

                      _dialog.hide();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Làm mới danh sách'),
                    backgroundColor: Colors.deepOrange,
                  ),
                ],
              ),
            ));
  }
}
