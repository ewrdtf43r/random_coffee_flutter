class OrderResponseModel {
  final String message;
  final String orderId;

  OrderResponseModel({required this.message, required this.orderId});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      message: json['message'] as String,
      orderId: json['orderId'] as String,
    );
  }
}
