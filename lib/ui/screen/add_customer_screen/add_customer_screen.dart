import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/view_model/implements/customer_view_model.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController pointController;
  late TextEditingController point1Controller;
  late TextEditingController oweController;
  late TextEditingController addressController;
  late ICustomerViewModel viewModel;
  late SimpleFontelicoProgressDialog _dialog;
  PointType pointType = PointType.thuong;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    pointController = TextEditingController();
    oweController = TextEditingController();
    point1Controller = TextEditingController();
    addressController = TextEditingController();
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Text(
                'Khách hàng mới',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.highlight_remove,
                  color: Colors.grey,
                  size: 35,
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 15),
          Text(
            'Thông tin khách hàng mới',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          MyTextFormField(
            width: 620,
            lable: 'Họ và tên',
            controller: usernameController,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              MyTextFormField(
                width: 300,
                lable: 'Số điện thoại',
                controller: phoneController,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Không được bỏ trống';
                  }
                  return null;
                },
              ),
              SizedBox(width: 20),
              MyTextFormField(
                width: 300,
                lable: 'Địa chỉ',
                controller: addressController,
                textInputType: TextInputType.text,
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Loại',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              MyTextFormField(
                width: 200,
                lable: 'Điểm thường',
                controller: pointController,
                textInputType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(width: 20),
              MyTextFormField(
                width: 200,
                lable: 'Điểm lon',
                controller: point1Controller,
                textInputType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(width: 20),
              MyTextFormField(
                width: 200,
                lable: 'Tiền nợ',
                controller: oweController,
                textInputType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                child: Text(
                  'Huỷ bỏ',
                ),
                onPressed: () {
                  Get.back();
                },
                color: Colors.grey,
              ),
              SizedBox(width: 20),
              MyButton(
                child: Text('Thêm'),
                onPressed: () async {
                  await _onPressed();
                },
                color: Color(0xFF00b90a),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _onPressed() async {
    _dialog.show(message: 'Đợi một lát...');

    final point = int.tryParse(pointController.text) ?? 0;
    final point1 = int.tryParse(pointController.text) ?? 0;
    final owe = int.tryParse(pointController.text) ?? 0;
    Customer customerEntity = Customer(
      name: usernameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      point: point,
      address: addressController.text.trim(),
      point1: point1,
      owe: owe,
    );
    await viewModel.addCustomer(customerEntity);
    _dialog.hide();
    Get.back();
  }
}
