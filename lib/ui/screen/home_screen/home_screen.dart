import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/enum.dart';
import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/screen/add_customer_screen/add_customer_screen.dart';
import 'package:bonus_points_app/ui/screen/add_point_screen/add_point_screen.dart';
import 'package:bonus_points_app/ui/screen/delete_customer_screen/delete_customer_screen.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ICustomerViewModel _viewModel;
  late ProgressDialog _dialog;
  late TextEditingController searchController;
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  void initState() {
    _startDate = null;
    _endDate = null;
    _viewModel = context.read<ICustomerViewModel>();
    searchController = TextEditingController();
    _dialog = ProgressDialog(context: context);

    Future.delayed(Duration.zero, () async {
      _dialog.show(
        barrierColor: Colors.black26,
        msg:
            'Đang tải dữ liệu lần đầu tiên!\nVui lòng không tải lại trang hoặc\nthoát trang để dữ liệu được đồng bộ hoàn toàn!',
        max: 100,
        msgMaxLines: 3,
        msgFontWeight: FontWeight.w500,
        msgFontSize: 20,
      );
      await _viewModel.syncData();
      _dialog.close();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: const Color(0xFFf5f6fa),
        title: Text('Danh sách khách hàng'),
        centerTitle: true,
        leading: SizedBox.shrink(),
        elevation: 5,
        titleTextStyle: TextStyle(
          fontSize: 25,
          color: Colors.black,
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
              child: Consumer<ICustomerViewModel>(builder: (_, _viewModel, __) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            textInputAction: TextInputAction.search,
                            controller: searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _viewModel.searchCustomer(value);
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      searchController.text = '';
                                      _viewModel.searched = false;
                                      _viewModel.searchCustomer('');
                                    },
                                    icon:
                                        Icon(Icons.clear, color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      if (searchController.text.isNotEmpty) {
                                        _viewModel.searchCustomer(
                                            searchController.text);
                                      }
                                    },
                                    icon:
                                        Icon(Icons.search, color: Colors.black),
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
                        SizedBox(width: 50),
                        MyButton(
                          width: 160,
                          onPressed: () {
                            showDateRange(context, (args) {
                              if (args != null) {
                                if (args is PickerDateRange) {
                                  _startDate = args.startDate;
                                  if (args.endDate != null) {
                                    _endDate = DateTime(
                                        args.endDate!.year,
                                        args.endDate!.month,
                                        args.endDate!.day,
                                        23,
                                        59,
                                        59);
                                  } else {
                                    _endDate = DateTime(
                                        args.startDate!.year,
                                        args.startDate!.month,
                                        args.startDate!.day,
                                        23,
                                        59,
                                        59);
                                  }
                                  _viewModel.filterByDateRange(
                                      _startDate!, _endDate!);
                                }
                              }
                              Get.back();
                            });
                          },
                          color: Colors.blue.shade200,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list_alt,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Lọc ngày',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          borderRadius: 20,
                        ),
                        SizedBox(width: 10),
                        MyButton(
                          width: 160,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: AddCustomerScreen(),
                              ),
                            );
                          },
                          color: const Color(0xFFeadc03),
                          child: Text(
                            'Thêm khách hàng',
                            style: TextStyle(color: Colors.black),
                          ),
                          borderRadius: 20,
                        ),
                      ],
                    ),
                    _startDate != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 160),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                DateFormat('dd MMM yyyy', 'vi').format(
                                      _startDate!,
                                    ) +
                                    (DateFormat(' - dd MMM yyyy', 'vi').format(
                                      _endDate!,
                                    )),
                              ),
                            ))
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _viewModel.customerUIs.isNotEmpty
                          ? ListView.builder(
                              itemCount: !_viewModel.searched
                                  ? _viewModel.customerUIs.length
                                  : _viewModel.customersToDisplay.length,
                              itemBuilder: (ctx, index) {
                                final Customer customer = !_viewModel.searched
                                    ? _viewModel.customerUIs[index]
                                    : _viewModel.customersToDisplay[index];
                                return CustomerItem(
                                  customer: customer,
                                  index: index,
                                );
                              },
                            )
                          : ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 150),
                                  child: Center(
                                    child: Text(
                                      !_viewModel.searched
                                          ? 'Chưa có khách hàng'
                                          : 'Không tìm thấy khách hàng',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
      floatingActionButton: Selector<ICustomerViewModel, FilterType>(
          selector: (_, _vm) => _vm.filterType,
          builder: (context, __, ___) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyFunction(
                    title: 'Vừa cập nhật',
                    color: Colors.green.shade300,
                    active: _viewModel.filterType == FilterType.crateTime,
                    onPreesed: () {
                      _viewModel.filterBy(FilterType.crateTime);
                      _reset();
                    }),
                SizedBox(height: 16),
                MyFunction(
                  title: 'Top điểm thường',
                  color: Colors.orange,
                  active: _viewModel.filterType == FilterType.point,
                  onPreesed: () {
                    _viewModel.filterBy(FilterType.point);
                    _reset();
                  },
                ),
                SizedBox(height: 16),
                MyFunction(
                  title: 'Top điểm lon',
                  active: _viewModel.filterType == FilterType.point1,
                  color: Colors.blue.shade600,
                  onPreesed: () {
                    _viewModel.filterBy(FilterType.point1);
                    _reset();
                  },
                ),
                SizedBox(height: 16),
                MyFunction(
                  title: 'Top nợ',
                  active: _viewModel.filterType == FilterType.owe,
                  color: Colors.red.shade600,
                  onPreesed: () {
                    _viewModel.filterBy(FilterType.owe);
                    _reset();
                  },
                ),
                SizedBox(height: 16),
                MyFunction(
                  title: 'Top mua nhiều',
                  active: _viewModel.filterType == FilterType.buybest,
                  color: Colors.teal,
                  onPreesed: () {
                    _viewModel.filterBy(FilterType.buybest);
                    _reset();
                  },
                ),
              ],
            );
          }),
    );
  }

  void _reset() {
    _startDate = null;
    _endDate = null;
    searchController.text = '';
  }
}

class MyFunction extends StatelessWidget {
  const MyFunction({
    Key? key,
    this.active = false,
    required this.color,
    required this.title,
    required this.onPreesed,
  }) : super(key: key);
  final String title;
  final Color color;
  final bool active;
  final VoidCallback onPreesed;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      width: 230,
      onPressed: onPreesed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (active)
            SizedBox(
              width: 60,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          Text(title),
        ],
      ),
      color: color,
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
          Get.toNamed(MyRouter.detail, arguments: customer);
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
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'SĐT: ${customer.phoneNumber!}',
                      style: TextStyle(
                        fontSize: 16,
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
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 125,
                          child: Text(
                            'Điểm thường:',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${format.format(customer.point)}',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 125,
                          child: Text(
                            'Điểm sữa lon:',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${format.format(customer.pointLon)}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 125,
                          child: Text(
                            'Nợ:',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${format.format(customer.owe)} VNĐ',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Tổng điểm năm 2024: ${format.format(customer.bestByYear2024)}',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 15,
                        fontWeight: FontWeight.w700,

                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: AddPoint(
                                customer: customer,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xff00b90a),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          _viewModel.currentCustomer = customer;
                          Get.toNamed(
                            MyRouter.detail,
                            arguments: customer,
                          );
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xffEFCD11),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: DeleteCustomer(customer: customer),
                            ),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.delete_solid,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          activeColor: Colors.green[600],
                          value: customer.isLunarGift,
                          onChanged: (newValue) async {
                            await _viewModel.changeGift(
                                newValue ?? false, customer);
                          },
                        ),
                      ),
                      Text(
                        'Đã tặng quà',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> showDateRange(
    BuildContext context, final Function(Object?)? onSubmit) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.all(16.r),
      content: SizedBox(
        height: 350.0,
        width: 350.0,
        child: SfDateRangePicker(
          confirmText: 'Xác nhận',
          onCancel: () {
            Get.back();
          },
          onSubmit: onSubmit,
          cancelText: 'Huỷ bỏ',
          view: DateRangePickerView.month,
          showActionButtons: true,
          initialDisplayDate: DateTime.now(),
          initialSelectedDate: DateTime.now(),
          selectionMode: DateRangePickerSelectionMode.range,
        ),
      ),
    ),
  );
}
