import 'dart:io';

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

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    phoneController = MaskedTextController(mask: '000,000,0000');
    pointController = TextEditingController();
    addressController = TextEditingController();
    commentController = TextEditingController();
    viewModel = context.read<ICustomerViewModel>();
    Future.delayed(Duration.zero, () {
      viewModel.getCustomerPointDetails(widget.customer.customerId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.customer.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 48.h,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                MyRouter.addCustomer,
                arguments: widget.customer,
              );
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.add),
        onPressed: () {
          commentController.text = '';
          pointController.text = '';

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            builder: (context) => Container(
              padding: Platform.isAndroid
                  ? EdgeInsets.only(
                      right: 16.w,
                      left: 16.w,
                      top: 16.h,
                      bottom: MediaQuery.of(context).viewInsets.bottom)
                  : EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextFormField(
                    lable: Text('??i???m'),
                    controller: pointController,
                    textInputType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  SizedBox(height: 20.h),
                  MyTextFormField(
                    lable: Text('N???i dung'),
                    controller: commentController,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: Platform.isAndroid ? 10.h : 30.h),
                  MyButton(
                    child: Text(
                      'Th??m ??i???m',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    height: Platform.isAndroid ? 44.h : 60.h,
                    onPressed: () async {
                      await viewModel.addPoint(
                        widget.customer.customerId!,
                        commentController.text.trim(),
                        int.parse(pointController.text.trim()),
                        1,
                      );
                      viewModel
                          .getCustomerPointDetails(widget.customer.customerId!);
                      Get.back();
                    },
                    color: Color(0xFF06A014),
                  ),
                  SizedBox(height: Platform.isAndroid ? 6.h : 16.h),
                  MyButton(
                    child: Text(
                      '?????i ??i???m',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      await viewModel.addPoint(
                        widget.customer.customerId!,
                        commentController.text.trim(),
                        int.parse(pointController.text.trim()),
                        2,
                      );
                      viewModel
                          .getCustomerPointDetails(widget.customer.customerId!);
                      Get.back();
                    },
                    height: Platform.isAndroid ? 44.h : 60.h,
                    color: Color(0xFFEA2027),
                  ),
                  SizedBox(height: Platform.isAndroid ? 6.h : 16.h),
                  MyButton(
                    child: Text(
                      'Hu??? b???',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    height: Platform.isAndroid ? 44.h : 60.h,
                    color: Color(0xFF979797),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'S??? ??i???n tho???i:  ${widget.customer.phoneNumber}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '?????a ch???: ${widget.customer.address!}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(18.r),
            ),
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.symmetric(horizontal: 40.h),
            child: Column(
              children: [
                Text(
                  '??i???m t??ch lu???',
                  style: TextStyle(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Consumer<ICustomerViewModel>(builder: (_, _viewModel, __) {
                  return Text(
                    '${format.format(viewModel.customerPointDetails.fold<int>(0, (previousValue, element) => previousValue + element.point))}??',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Consumer<ICustomerViewModel>(builder: (_, _viewModel, __) {
              return ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  onLongPress: () {
                    Get.defaultDialog(
                        title: 'X??c nh???n xo??',
                        middleText: 'B???n mu???n xo?? ??i???m n??y?',
                        textConfirm: 'Xo??',
                        textCancel: 'Hu??? b???',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Color(0xFFEA2027),
                        buttonColor: Color(0xFFEA2027),
                        onConfirm: () async {
                          await _viewModel.deletePoint(
                              _viewModel.customerPointDetails[index]);
                          Get.back();
                        });
                  },
                  tileColor: _viewModel.customerPointDetails[index].type == 1
                      ? Color(0xFF06A014).withOpacity(0.2)
                      : Color(0xFFEA2027).withOpacity(0.2),
                  title: Text(
                    _viewModel.customerPointDetails[index].comment,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd/mm/yyyy HH:mm').format(
                      _viewModel.customerPointDetails[index].createTime!,
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: Text(
                    '${format.format(_viewModel.customerPointDetails[index].point)}??',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                itemCount: _viewModel.customerPointDetails.length,
                separatorBuilder: (_, __) => Divider(
                  height: 0,
                  thickness: 1.h,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
