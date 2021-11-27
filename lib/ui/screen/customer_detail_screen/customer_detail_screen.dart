import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
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
import 'dart:html';

import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);
  final CustomerUIModel customer;

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

  final GlobalKey<FormState> _formKeyPoint = GlobalKey<FormState>();

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

    Future.delayed(Duration.zero, () {
      var uri = Uri.dataFromString(window.location.href);
      Map<String, String> params = uri.queryParameters;
      var id = params['id'];

      viewModel.getCustomerPointDetails(id ?? widget.customer.customerId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');
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
          FloatingActionButton.extended(
            heroTag: 'btn3',
            icon: Icon(CupertinoIcons.add),
            label: Text('Thêm/đổi điểm'),
            onPressed: () {
              commentController.text = '';
              pointController.text = '';

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Container(
                    width: 600,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _formKeyPoint,
                          child: MyTextFormField(
                              lable: Text('Điểm'),
                              controller: pointController,
                              textInputType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Không được bỏ trống';
                                }
                              }),
                        ),
                        SizedBox(height: 20),
                        MyTextFormField(
                          lable: Text('Nội dung'),
                          controller: commentController,
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(height: 30),
                        MyButton(
                          child: Text(
                            'Thêm điểm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          height: 60,
                          onPressed: () async {
                            if (_formKeyPoint.currentState!.validate()) {
                              _dialog.show(message: 'Đợi 1 lát');
                              await viewModel.addPoint(
                                widget.customer.customerId!,
                                commentController.text.trim(),
                                int.parse(pointController.text.trim()),
                                1,
                              );
                              viewModel.getCustomerPointDetails(
                                  widget.customer.customerId!);
                              await viewModel.syncData();
                              _dialog.hide();
                              Get.back();
                            }
                          },
                          color: Color(0xFF06A014),
                        ),
                        SizedBox(height: 16),
                        MyButton(
                          child: Text(
                            'Đổi điểm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKeyPoint.currentState!.validate()) {
                              _dialog.show(message: 'Đợi 1 lát');
                              await viewModel.addPoint(
                                widget.customer.customerId!,
                                commentController.text.trim(),
                                int.parse(pointController.text.trim()),
                                2,
                              );
                              viewModel.getCustomerPointDetails(
                                  widget.customer.customerId!);
                              _dialog.hide();
                              Get.back();
                            }
                          },
                          height: 60,
                          color: Color(0xFFEA2027),
                        ),
                        SizedBox(height: 16),
                        MyButton(
                          child: Text(
                            'Huỷ bỏ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          height: 60,
                          color: Color(0xFF979797),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 1.sw - 0.3.sw,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 500,
                        height: 130,
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
                              'Tên KH:  ${widget.customer.name}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Số điện thoại:  ${widget.customer.phoneNumber}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Địa chỉ: ${widget.customer.address!}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color(0xFFF35369),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: EdgeInsets.all(30),
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Điểm tích luỹ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Consumer<ICustomerViewModel>(
                                builder: (_, _viewModel, __) {
                              return Text(
                                '${format.format(viewModel.customerPointDetails.fold<int>(0, (previousValue, element) => previousValue + element.point))}đ',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: Consumer<ICustomerViewModel>(
                        builder: (_, _viewModel, __) {
                      return ListView.separated(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            minVerticalPadding: 5,
                            onLongPress: () {
                              Get.defaultDialog(
                                title: 'Xác nhận xoá',
                                middleText: 'Bạn muốn xoá điểm này?',
                                textConfirm: 'Xoá',
                                textCancel: 'Huỷ bỏ',
                                confirmTextColor: Colors.white,
                                cancelTextColor: Color(0xFFEA2027),
                                buttonColor: Color(0xFFEA2027),
                                cancel: MyButton(
                                    child: Text('Huỷ bỏ'),
                                    onPressed: () {
                                      Get.back();
                                    }),
                                confirm: MyButton(
                                    child: Text('Huỷ bỏ'),
                                    onPressed: () async {
                                      _dialog.show(message: 'Chờ một lát...');

                                      await _viewModel.deletePoint(_viewModel
                                          .customerPointDetails[index]);
                                      await _viewModel.syncData();
                                      _dialog.hide();
                                      Get.back();
                                    }),
                              );
                            },
                            tileColor:
                                _viewModel.customerPointDetails[index].type == 1
                                    ? Color(0xFF00A400).withOpacity(0.2)
                                    : Color(0xFFEA2027).withOpacity(0.2),
                            title: Text(
                              'Nội dung: ' +
                                  _viewModel
                                      .customerPointDetails[index].comment,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('dd/mm/yyyy HH:mm').format(
                                _viewModel
                                    .customerPointDetails[index].createTime!,
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
                                  '${format.format(_viewModel.customerPointDetails[index].point)}đ',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
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
                                              await _viewModel.deletePoint(
                                                  _viewModel
                                                          .customerPointDetails[
                                                      index]);
                                              await _viewModel.syncData();
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
                        itemCount: _viewModel.customerPointDetails.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 0,
                          thickness: 1,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
