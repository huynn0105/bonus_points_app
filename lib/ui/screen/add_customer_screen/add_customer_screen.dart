import 'dart:io';

import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/widgets/my_app_bar.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({
    Key? key,
    this.customer,
  }) : super(key: key);
  final CustomerUIModel? customer;

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late TextEditingController usernameController;
  late MaskedTextController phoneController;
  late TextEditingController pointController;
  late TextEditingController addressController;
  late ICustomerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.customer?.name);
    phoneController = MaskedTextController(
        mask: '0000,000,000', text: widget.customer?.phoneNumber);
    pointController =
        TextEditingController(text: widget.customer?.pointTotal.toString());
    addressController = TextEditingController(text: widget.customer?.address);
    viewModel = context.read<ICustomerViewModel>();
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.customer == null
              ? 'Thêm khách hàng'
              : 'Cập nhập thông tin khách hàng',
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormField(
                lable: Text('Họ và tên'),
                controller: usernameController,
              ),
              SizedBox(height: 10),
              MyTextFormField(
                lable: Text('Số điện thoại'),
                controller: phoneController,
                textInputType: TextInputType.number,
              ),
              SizedBox(height: 10.h),
              MyTextFormField(
                lable: Text('Địa chỉ'),
                controller: addressController,
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 10.h),
              widget.customer == null
                  ? MyTextFormField(
                      lable: Text('Điểm'),
                      controller: pointController,
                      textInputType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      child: Text(
                        'Huỷ bỏ',
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                      height: Platform.isAndroid ? 44.h : 60.h,
                      onPressed: () {
                        Get.back();
                      },
                      color: Color(0xFFEA2027).withOpacity(0.86),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: MyButton(
                      child:
                          Text(widget.customer == null ? 'Thêm' : 'Cập nhập'),
                      onPressed: () async {
                        CustomerUIModel customerUIModel = CustomerUIModel(
                          customerId: widget.customer?.customerId,
                          name: usernameController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          pointTotal: int.parse(pointController.text),
                          address: addressController.text.trim(),
                        );
                        if (widget.customer == null)
                          await viewModel.addCustomer(customerUIModel);
                        else {
                          await viewModel.updateCustomer(customerUIModel);
                        }
                        viewModel.getCustomers();
                        Get.offAllNamed(MyRouter.home);
                      },
                      height: Platform.isAndroid ? 44.h : 60.h,
                      color: Color(0xFF06A014),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
