import 'package:bonus_points_app/core/hive_database/entities/customer/customer_entity.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
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
  final CustomerEntity? customer;

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController pointController;
  late TextEditingController addressController;
  late ICustomerViewModel viewModel;
  late SimpleFontelicoProgressDialog _dialog;
  PointType pointType = PointType.thuong;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.customer?.name);
    phoneController = TextEditingController(text: widget.customer?.phoneNumber);
    pointController = TextEditingController(
        text: widget.customer?.totalPointThuong.toString());
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
        leading: BackButton(color: Colors.white),
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
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyTextFormField(
                        lable: Text('Họ và tên'),
                        controller: usernameController,
                      ),
                      SizedBox(height: 20),
                      MyTextFormField(
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
                      SizedBox(height: 20),
                      MyTextFormField(
                        lable: Text('Địa chỉ'),
                        controller: addressController,
                        textInputType: TextInputType.text,
                      ),
                      widget.customer == null
                          ? SizedBox(
                              height: 120,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: MyTextFormField(
                                      lable: Text('Điểm hoặc Tiền'),
                                      controller: pointController,
                                      textInputType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  CustomCheckBox(
                                    title: 'Điểm thường',
                                    value: pointType == PointType.thuong,
                                    onPressed: () {
                                      pointType = PointType.thuong;
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  CustomCheckBox(
                                    title: 'Điểm sữa lon',
                                    value: pointType == PointType.lon,
                                    onPressed: () {
                                      pointType = PointType.lon;
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(width: 30),
                                  CustomCheckBox(
                                    title: 'Ghi nợ',
                                    value: pointType == PointType.no,
                                    onPressed: () {
                                      pointType = PointType.no;
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(width: 50),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              child: Text(
                                'Huỷ bỏ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              height: 60,
                              onPressed: () {
                                Get.back();
                              },
                              color: Color(0xFFEA2027).withOpacity(0.86),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: MyButton(
                              child: Text(widget.customer == null
                                  ? 'Thêm'
                                  : 'Cập nhập'),
                              onPressed: () async {
                                await _onPressed();
                              },
                              height: 60,
                              color: Color(0xFF06A014),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPressed() async {
    _dialog.show(message: 'Đợi một lát...');

    if (widget.customer == null) {
      final point = int.tryParse(pointController.text) ?? 0;
      CustomerEntity customerEntity = CustomerEntity(
        name: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        totalPointThuong: pointType == PointType.thuong ? point : 0,
        address: addressController.text.trim(),
        totalPointSuaLon: pointType == PointType.lon ? point : 0,
        tienNo: pointType == PointType.no ? point : 0,
      );
      await viewModel.addCustomer(customerEntity, point, pointType);
    } else {
      CustomerEntity customerEntity = widget.customer!.copyWith(
        address: addressController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        name: usernameController.text.trim(),
      );
      await viewModel.updateCustomer(customerEntity);
    }
    _dialog.hide();
    Get.back();
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.title,
    required this.value,
    required this.onPressed,
  }) : super(key: key);
  final String title;
  final bool value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2,
                color: Colors.blue,
              ),
              color: value ? Colors.blue : Colors.white,
            ),
            child: value
                ? Center(
                    child: Icon(
                      Icons.check,
                      size: 36.0,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
