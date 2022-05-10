import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/ui/screen/customer_detail_screen/customer_detail_screen_1.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class DeleteCustomer extends StatelessWidget {
  const DeleteCustomer({
    Key? key,
    required this.customer,
  }) : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    
    return SizedBox(
      width: 450,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.shrink(),
              Text(
                'Xác nhận xoá',
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
          SizedBox(height: 20),
          Text('Bạn muốn xoá khách hàng này?'),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                  width: 150,
                  child: Text(
                    'Huỷ bỏ',
                  ),
                  color: Colors.grey,
                  onPressed: () {
                    Get.back();
                  }),
              SizedBox(width: 20),
              MyButton(
                  width: 150,
                  child: Text(
                    'Xoá',
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Color(0xFFEA2027),
                  onPressed: () async {
                    _dialog.show(message: 'Chờ một lát...');
                    await context
                        .read<ICustomerViewModel>()
                        .deleteCustomer(customer);
                    _dialog.hide();
                    Get.back();
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
