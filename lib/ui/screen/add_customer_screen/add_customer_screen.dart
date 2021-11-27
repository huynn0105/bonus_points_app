import 'package:bonus_points_app/core/ui_model/customer_ui_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/global/router.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

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
  late SimpleFontelicoProgressDialog _dialog;
  final GlobalKey<FormState> _formKeyPhoneNumber = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.customer?.name);
    phoneController = MaskedTextController(
        mask: '000,0000,000', text: widget.customer?.phoneNumber);
    pointController =
        TextEditingController(text: widget.customer?.pointTotal.toString());
    addressController = TextEditingController(text: widget.customer?.address);
    viewModel = context.read<ICustomerViewModel>();
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
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
        backgroundColor: Colors.green,
        title: Text(
          widget.customer == null
              ? 'Thêm khách hàng'
              : 'Cập nhập thông tin khách hàng',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      backgroundColor: Color(0xFFF5F6F7),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 1.sw - 0.3.sw,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8,
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
                    Form(
                      key: _formKeyPhoneNumber,
                      child: MyTextFormField(
                        lable: Text('Số điện thoại'),
                        controller: phoneController,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Không được bỏ trống';
                          }
                          return null;
                        },
                      ),
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
                            height: 60.h,
                            onPressed: () {
                              Get.back();
                            },
                            color: Color(0xFFEA2027).withOpacity(0.86),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: MyButton(
                            child: Text(
                                widget.customer == null ? 'Thêm' : 'Cập nhập'),
                            onPressed: () async {
                              if (_formKeyPhoneNumber.currentState!
                                  .validate()) {
                                _dialog.show(message: 'Đợi một lát...');

                                CustomerUIModel customerUIModel =
                                    CustomerUIModel(
                                  customerId: widget.customer?.customerId,
                                  name: usernameController.text.trim(),
                                  phoneNumber: phoneController.text.trim(),
                                  pointTotal: int.parse(pointController.text),
                                  address: addressController.text.trim(),
                                );
                                if (widget.customer == null)
                                  await viewModel.addCustomer(customerUIModel);
                                else {
                                  await viewModel
                                      .updateCustomer(customerUIModel);
                                }
                                await viewModel.syncData();
                                _dialog.hide();
                                Get.offAllNamed(MyRouter.home);
                              }
                            },
                            height: 60.h,
                            color: Color(0xFF06A014),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
