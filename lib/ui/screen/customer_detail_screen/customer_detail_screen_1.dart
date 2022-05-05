import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class CustomerDetailScreen1 extends StatefulWidget {
  const CustomerDetailScreen1({
    Key? key,
    required this.customer,
  }) : super(key: key);
  final Customer customer;

  @override
  State<CustomerDetailScreen1> createState() => _CustomerDetailScreen1State();
}

class _CustomerDetailScreen1State extends State<CustomerDetailScreen1> {
  late TextEditingController usernameController,
      pointController,
      addressController,
      point1Controller,
      oweController;
  late MaskedTextController phoneController;
  late TextEditingController commentController;
  late ICustomerViewModel _viewModel;
  late SimpleFontelicoProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    Customer customer = widget.customer;
    usernameController = TextEditingController(text: customer.name);
    point1Controller =
        TextEditingController(text: customer.totalPointSuaLon.toString());
    oweController = TextEditingController(text: customer.tienNo.toString());
    phoneController =
        MaskedTextController(mask: '000,000,0000', text: customer.phoneNumber);
    pointController =
        TextEditingController(text: customer.totalPointThuong.toString());
    addressController = TextEditingController(text: customer.address);
    commentController = TextEditingController();
    _viewModel = context.read<ICustomerViewModel>();
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);

    Future.delayed(Duration.zero, () async {
      _dialog.show(message: 'Đợi 1 lát');
      await _viewModel.getCustomerPointDetails(widget.customer.id!);
      _dialog.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          color: Colors.black,
          iconSize: 35,
          onPressed: () {},
        ),
        toolbarHeight: 68,
        backgroundColor: const Color(0xFFf5f6fa),
        title: const Text(
          'Chi tiết điểm',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.add,
              color: Colors.green,
              size: 35,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Họ và tên',
                      labelStyle: headerStyle,
                    ),
                    controller: usernameController,
                    style: bodyStyle,
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Địa chỉ',
                      labelStyle: headerStyle,
                    ),
                    controller: addressController,
                    style: bodyStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Số điện thoại',
                      labelStyle: headerStyle,
                    ),
                    controller: phoneController,
                    style: bodyStyle,
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Điểm',
                      labelStyle: headerStyle,
                    ),
                    controller: pointController,
                    style: bodyStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Điểm lon',
                      labelStyle: headerStyle,
                    ),
                    controller: point1Controller,
                    style: bodyStyle,
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Nợ',
                      labelStyle: headerStyle,
                      suffix: const Text('VNĐ'),
                    ),
                    controller: oweController,
                    style: bodyStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFf44336)),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(140, 49),
                    ),
                  ),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
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
                              await _viewModel.deleteCustomer(widget.customer);
                              _dialog.hide();
                              Get.back();
                            }),
                      ],
                    );
                  },
                  child: Text(
                    'Xoá',
                    style: bodyStyle,
                  ),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF00b90a)),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(140, 49),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Cập nhập',
                    style: bodyStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF182236),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Text(
                'Lịch sử',
                style: headerStyle.copyWith(color: Colors.white),
              ),
            ),
            Container(
              color: Colors.brown.shade100,
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Thời gian',
                      style: bodyStyle,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Nội dung',
                      style: bodyStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Loại',
                      style: bodyStyle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            //ListView.builder(itemBuilder: (context,index)=>_TransactionItem(widget.customer.),)
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    Key? key,
     required this.detail,
  }) : super(key: key);
  final PointDetail detail;
  @override
  Widget build(BuildContext context) {
        final format = NumberFormat('#,###');

    return Container(
      color: Colors.green.shade100,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Text(
                         DateFormat('dd/MM/yyyy HH:mm').format(
                  detail.createTime!,
                ),
              style: bodyStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              detail.comment,
              style: bodyStyle,
            ),
          ),
          Expanded(
            child: Text(
               detail.type != 1
                        ? '${format.format(detail.point)}vnđ'
                        : '${format.format(detail.point)}đ',
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle bodyStyle = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
);

TextStyle headerStyle = const TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.w400,
);
