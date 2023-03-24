import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class AddPoint extends StatefulWidget {
  const AddPoint({
    Key? key,
    required this.customer,
    this.onAddPoint,
  }) : super(key: key);
  final Customer customer;
  final void Function(int, int, int)? onAddPoint;

  @override
  State<AddPoint> createState() => _AddPointState();
}

class _AddPointState extends State<AddPoint> {
  late TextEditingController pointController;
  late TextEditingController point1Controller;
  late TextEditingController oweController;
  late TextEditingController cmtController;
  late SimpleFontelicoProgressDialog _dialog;
  late ICustomerViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    pointController = TextEditingController();
    oweController = TextEditingController();
    point1Controller = TextEditingController();
    cmtController = TextEditingController();

    _viewModel = context.read<ICustomerViewModel>();
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox.shrink(),
            Text(
              'Thêm / đổi điểm',
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
        SizedBox(height: 30),
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
        MyTextFormField(
          width: 640,
          lable: 'Nội dung',
          controller: cmtController,
          maxLines: 4,
        ),
        SizedBox(height: 50),
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
              child: Text(
                'Đổi điểm',
              ),
              onPressed: () async {
                _dialog.show(message: 'Đợi 1 lát');
                int point = int.tryParse(pointController.text.trim()) ?? 0;
                int point1 = int.tryParse(point1Controller.text.trim()) ?? 0;
                int owe = int.tryParse(oweController.text.trim()) ?? 0;
                await _viewModel.addPoint(
                  widget.customer,
                  cmtController.text.trim(),
                  -point,
                  -point1,
                  -owe,
                );

                widget.onAddPoint?.call(-point, -point1, -owe);

                _dialog.hide();
                Get.back();
              },
              color: Color(0xFFEA2027),
            ),
            SizedBox(width: 20),
            MyButton(
              child: Text('Thêm điểm'),
              onPressed: () async {
                _dialog.show(message: 'Đợi 1 lát');
                int point = int.tryParse(pointController.text.trim()) ?? 0;
                int point1 = int.tryParse(point1Controller.text.trim()) ?? 0;
                int owe = int.tryParse(oweController.text.trim()) ?? 0;
                await _viewModel.addPoint(
                  widget.customer,
                  cmtController.text.trim(),
                  point,
                  point1,
                  owe,
                );

                widget.onAddPoint?.call(point, point1, owe);

                _dialog.hide();
                Get.back();
              },
              color: Color(0xFF00b90a),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
