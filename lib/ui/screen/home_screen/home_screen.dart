import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
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
  late TextEditingController controller;

  @override
  void initState() {
    viewModel = context.read<ICustomerViewModel>();
    controller = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Danh sách khách hàng'),
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
                          controller: controller,
                          decoration: InputDecoration(
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.clear();
                                    context
                                        .read<ICustomerViewModel>()
                                        .isSearch = false;
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
                            hintText: "Tìm kiếm khách hàng...",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
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
                              builder: (_, _viewModel, __) {
                            return _viewModel.customerUIs.isNotEmpty
                                ? ListView.builder(
                                    itemCount: !_viewModel.isSearch
                                        ? _viewModel.customerUIs.length
                                        : _viewModel.customersToDisplay.length,
                                    itemBuilder: (ctx, index) {
                                      final Customer customer = !_viewModel.isSearch
                                          ? _viewModel.customerUIs[index]
                                          : _viewModel
                                              .customersToDisplay[index];
                                      return CustomerItem(
                                          customer: customer, index: index);
                                    },
                                  )
                                : ListView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 150),
                                        child: Center(
                                          child: Text(
                                            !_viewModel.isSearch
                                                ? 'Chưa có khách hàng'
                                                : 'Không tìm thấy khách hàng',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn1_2',
            onPressed: () {
            
            },
            icon: Icon(CupertinoIcons.money_dollar),
            label: Text('Danh sách nợ'),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 20),
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
    );
  }
}

class CustomerItem extends StatelessWidget {
  const CustomerItem({
    Key? key,
    required this.customer,
    required this.index,
  }) : super(key: key);

  final Customer customer;

  final int index;

  @override
  Widget build(BuildContext context) {
    final SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    final _viewModel = context.read<ICustomerViewModel>();
    final format = NumberFormat('# ###');
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: index % 2 == 0 ? Colors.grey[50] : null,
      child: InkWell(
        onTap: () {
          _viewModel.currentCustomer = customer;
          Get.toNamed(
            MyRouter.detail,
            arguments: customer,
          );
        },
        child: ListTile(
          leading: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Sđt: ${customer.phoneNumber!}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Địa chỉ: ${customer.address}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm thường: ${format.format(customer.totalPointThuong)}',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Điểm sữa lon: ${format.format(customer.totalPointSuaLon)}',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Nợ: ${format.format(customer.tienNo)} VNĐ',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Get.defaultDialog(
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
                            _dialog.show(message: 'Chờ một lát...');
                            await _viewModel.deleteCustomer(customer);
                            _dialog.hide();
                            Get.back();
                          }),
                    ],
                  );
                },
                icon: Icon(
                  CupertinoIcons.delete_solid,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
