class CustomerUIModel {
  String? customerId;
  String name;
  String? phoneNumber;
  int pointTotal;
  String? address;
  DateTime? createTime;

  CustomerUIModel(
      {this.customerId,
      required this.name,
      this.phoneNumber,
      required this.pointTotal,
      this.address,
      this.createTime});
}
