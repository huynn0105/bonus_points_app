import 'package:bonus_points_app/core/model/customer/customer.dart';
import 'package:bonus_points_app/core/model/point_detail/point_detail.dart';
import 'package:bonus_points_app/core/view_model/interfaces/icustomer_view_model.dart';
import 'package:bonus_points_app/ui/screen/add_point_screen/add_point_screen.dart';
import 'package:bonus_points_app/ui/screen/delete_customer_screen/delete_customer_screen.dart';
import 'package:bonus_points_app/ui/widgets/my_button.dart';
import 'package:bonus_points_app/ui/widgets/my_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      totalPointeController,
      oweController;
  late TextEditingController phoneController;
  late TextEditingController commentController;
  late ICustomerViewModel _viewModel;
  late SimpleFontelicoProgressDialog _dialog;

  @override
  void initState() {
    super.initState();
    Customer customer = widget.customer;
    usernameController = TextEditingController(text: customer.name);
    point1Controller = TextEditingController(text: customer.point1.toString());
    oweController = TextEditingController(text: customer.owe.toString());
    totalPointeController = TextEditingController(text: customer.bestByYear.toString());
    phoneController = TextEditingController(text: customer.phoneNumber);
    pointController = TextEditingController(text: customer.point.toString());
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
          onPressed: () {
            Get.back();
          },
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: AddPoint(
                    customer: widget.customer,
                    onAddPoint: (point, point1, owe) {
                      pointController.text =
                          (int.parse(pointController.text) + point).toString();
                      point1Controller.text =
                          (int.parse(point1Controller.text) + point1)
                              .toString();
                      oweController.text =
                          (int.parse(oweController.text) + owe).toString();
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add,
              color: Colors.green,
              size: 35,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 1.sw - 0.3.sw,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Thông tin khách hàng ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    MyTextFormField(
                      width: 1.sw,
                      lable: 'Họ và tên',
                      controller: usernameController,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextFormField(
                            width: 1.sw,
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
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: MyTextFormField(
                            width: 1.sw,
                            lable: 'Địa chỉ',
                            controller: addressController,
                            textInputType: TextInputType.text,
                          ),
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
                        Expanded(
                          child: MyTextFormField(
                            width: 1.sw,
                            lable: 'Điểm thường',
                            readOnly: true,
                            controller: pointController,
                            textInputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: MyTextFormField(
                            width: 1.sw,
                            lable: 'Điểm lon',
                            readOnly: true,
                            controller: point1Controller,
                            textInputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          child: MyTextFormField(
                            width: 1.sw,
                            lable: 'Tiền nợ',
                            readOnly: true,
                            controller: oweController,
                            textInputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    MyTextFormField(
                      width: 300.w,
                      lable:
                          'Tổng điểm thường (Không tính đã đổi điểm) tính từ 2022',
                      readOnly: true,
                      controller: totalPointeController,
                      textInputType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: DeleteCustomer(
                                  customer: widget.customer,
                                ),
                              ),
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
                          onPressed: () async {
                            await _viewModel
                                .updateCustomer(widget.customer.copyWith(
                              address: addressController.text,
                              phoneNumber: phoneController.text,
                              name: usernameController.text,
                              createTime: DateTime.now(),
                            ));
                            Get.back();
                          },
                          child: Text(
                            'Cập nhập',
                            style: bodyStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 14),
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
                        MyButton(
                            child: Text(
                              'Thêm điểm',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            color: const Color(0xFF0EFCD11),
                            borderRadius: 25,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: AddPoint(
                                    customer: widget.customer,
                                    onAddPoint: (point, point1, owe) {
                                      pointController.text =
                                          (int.parse(pointController.text) +
                                                  point)
                                              .toString();
                                      point1Controller.text =
                                          (int.parse(point1Controller.text) +
                                                  point1)
                                              .toString();
                                      oweController.text =
                                          (int.parse(oweController.text) + owe)
                                              .toString();
                                    },
                                  ),
                                ),
                              );
                            })
                      ],
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
                          Expanded(
                            child: Text(
                              'Điểm/ Nợ',
                              style: bodyStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<ICustomerViewModel>(builder: (_, _vm, __) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _TransactionItem(
                          detail: _vm.customerPointDetails[index],
                          color: index % 2 == 0
                              ? Colors.grey.shade100
                              : Colors.grey.shade300,
                        ),
                        itemCount: _vm.customerPointDetails.length,
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
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

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    Key? key,
    required this.detail,
    required this.color,
  }) : super(key: key);
  final PointDetail detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');

    String getType() {
      switch (detail.type) {
        case 0:
          return detail.value > 0 ? 'Điểm' : 'Đổi điểm';
        case 1:
          return detail.value > 0 ? 'Điểm lon' : 'Đổi điểm lon';
        case 2:
          return detail.value > 0 ? 'Nợ' : 'Trả nợ';
        default:
          return '';
      }
    }

    return Container(
      color: color,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: EdgeInsets.only(bottom: 4),
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
              getType(),
              style: bodyStyle,
            ),
          ),
          Expanded(
            child: Text(
              detail.type == 2
                  ? '${format.format(detail.value)}vnđ'
                  : '${format.format(detail.value)} điểm',
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );
  }
}
