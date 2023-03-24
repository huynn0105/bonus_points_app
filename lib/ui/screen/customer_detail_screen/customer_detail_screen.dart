import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);
  final Customer customer;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late TextEditingController usernameController;
  late MaskedTextController phoneController;
  late TextEditingController pointController;
  late TextEditingController addressController;
  late TextEditingController commentController;
  late ICustomerViewModel viewModel;
  late SimpleFontelicoProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    phoneController = MaskedTextController(mask: '000,000,0000');
    pointController = TextEditingController();
    addressController = TextEditingController();
    commentController = TextEditingController();
    viewModel = context.read<ICustomerViewModel>();
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);

    Future.delayed(Duration.zero, () async {
      _dialog.show(message: 'Đợi 1 lát');
      await viewModel.getCustomerPointDetails(widget.customer.id!);
      _dialog.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBCCD2),
        title: Text(
          'Chi tiết điểm',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20),
          FloatingActionButton.extended(
            heroTag: 'btn4',
            onPressed: () {
              Get.toNamed(
                MyRouter.addCustomer,
                arguments: widget.customer,
              );
            },
            label: Text('Chỉnh sửa thông tin'),
            icon: Icon(Icons.edit),
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 1.sw - 0.3.sw,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                InfoCustomer(viewModel: viewModel),
                SizedBox(height: 30),
                _tabSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCustomer extends StatelessWidget {
  const InfoCustomer({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final ICustomerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Color(0xFFF5C33B),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Tên KH:  ${viewModel.currentCustomer?.name}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Số điện thoại:   ${viewModel.currentCustomer?.phoneNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Địa chỉ:  ${viewModel.currentCustomer?.address}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BoxPoint(),
        ),
      ],
    );
  }
}

class BoxPoint extends StatelessWidget {
  const BoxPoint({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Consumer<ICustomerViewModel>(builder: (_, viewModel, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Điểm thường',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${format.format(viewModel.currentCustomer?.point ?? 0)}đ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Điểm sữa lon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${format.format(viewModel.currentCustomer?.point1 ?? 0)}đ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiền nợ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${format.format(viewModel.currentCustomer?.owe ?? 0)} VNĐ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

Widget _tabSection(BuildContext context) {
  return Expanded(
    child: DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.blue,
              ),
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "Điểm thường"),
                Tab(text: "Điểm lon"),
                Tab(text: "Ghi nợ"),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Consumer<ICustomerViewModel>(builder: (_, _vm, __) {
                return TabBarView(children: [
                  _ListPointDetail(
                    pointDetailList: _vm.customerPointDetailsThuong,
                    pointType: PointType.thuong,
                  ),
                  _ListPointDetail(
                    pointDetailList: _vm.customerPointDetailsSuaLon,
                    pointType: PointType.lon,
                  ),
                  _ListPointDetail(
                    pointDetailList: _vm.customerPointDetailsGhiNo,
                    pointType: PointType.no,
                  ),
                ]);
              }),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ListPointDetail extends StatelessWidget {
  const _ListPointDetail({
    Key? key,
    required this.pointDetailList,
    required this.pointType,
  }) : super(key: key);

  final List<PointDetail> pointDetailList;
  final PointType pointType;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');

    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'btn3',
              icon: Icon(CupertinoIcons.add),
              label: Text('Thêm'),
              onPressed: () async {
                //await dialogPoint(context, pointType);
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        ...pointDetailList.map(
          (pointDetail) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              minVerticalPadding: 5,
              tileColor: pointDetail.type == 1
                  ? Color(0xFF00A400).withOpacity(0.2)
                  : Color(0xFFEA2027).withOpacity(0.2),
              title: Text(
                'Nội dung: ' + pointDetail.comment,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(
                  pointDetail.createTime!,
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pointType == PointType.no
                        ? '${format.format(pointDetail.value)}vnđ'
                        : '${format.format(pointDetail.value)}đ',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      Get.defaultDialog(
                        title: 'Xác nhận xoá',
                        middleText: 'Bạn muốn xoá điểm này?',
                        titleStyle: TextStyle(fontSize: 22),
                        middleTextStyle: TextStyle(fontSize: 20),
                        actions: [
                          MyButton(
                              width: 40,
                              child: Text(
                                'Huỷ bỏ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
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
                              final _dialog = SimpleFontelicoProgressDialog(
                                  context: context, barrierDimisable: false);

                              _dialog.show(message: 'Chờ một lát...');
                              await context
                                  .read<ICustomerViewModel>()
                                  .deletePoint(pointDetail);
                              _dialog.hide();
                              Get.back();
                            },
                          ),
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
        ),
        pointDetailList.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  pointType == PointType.no
                      ? 'Không có nợ!!!'
                      : 'Chưa có điểm!!!',
                  style: TextStyle(fontSize: 19),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

