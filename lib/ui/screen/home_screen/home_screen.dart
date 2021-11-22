import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/router.dart';
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

  Widget appBarTitle = Text(
    'Danh sách khách hàng',
    style: TextStyle(
      color: Colors.black,
      fontSize: 17.sp,
      fontWeight: FontWeight.w600,
    ),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.black,
  );

  @override
  void initState() {
    viewModel = context.read<ICustomerViewModel>();
    focusScope = FocusNode();
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    Future.delayed(Duration.zero, () {
      viewModel.getCustomers();
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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: appBarTitle,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 48.h,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                filteredElements = viewModel.customerUIs;
                isSearch = !isSearch;

                setState(() {
                  if (isSearch) {
                    this.actionIcon = Icon(Icons.close, color: Colors.black);
                    focusScope.requestFocus();
                    this.appBarTitle = TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textInputAction: TextInputAction.search,
                      focusNode: focusScope,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        hintText: "Tìm kiếm khách hàng...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onChanged: _filterElements,
                    );
                  } else {
                    this.actionIcon = Icon(Icons.search, color: Colors.black);
                    this.appBarTitle = Text(
                      'Danh sách khách hàng',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                });
              },
            ),
          ]),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.syncData();
          viewModel.getCustomers();
        },
        child: Consumer<ICustomerViewModel>(
          builder: (_, _viewModel, __) => _viewModel.customerUIs.isNotEmpty
              ? ListView.builder(
                  itemCount: isSearch
                      ? filteredElements.length
                      : _viewModel.customerUIs.length,
                  itemBuilder: (ctx, index) {
                    final CustomerUIModel customer = isSearch
                        ? filteredElements[index]
                        : _viewModel.customerUIs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      color: index % 2 == 0 ? Colors.grey[50] : null,
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
                              confirmTextColor: Colors.white,
                              cancelTextColor: Color(0xFFEA2027),
                              buttonColor: Color(0xFFEA2027),
                              onConfirm: () async {
                                await _viewModel.deleteCustomer(customer);
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${customer.phoneNumber!}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    customer.address != null
                                        ? Text(
                                            '${customer.address!}',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Text(
                                '${format.format(customer.pointTotal)}đ',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              _dialog.show(message: 'Chờ một lát...');
              await viewModel.syncData();
              viewModel.getCustomers();
              _dialog.hide();
            },
            child: Icon(Icons.refresh),
          ),
          SizedBox(width: 10.w),
          FloatingActionButton(
            onPressed: () {
              Get.toNamed(MyRouter.addCustomer);
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
