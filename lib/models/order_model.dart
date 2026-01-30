import 'package:get/get_rx/src/rx_types/rx_types.dart';

class OrderModel {
  final String? id;
  final RxString status;
  final RxnString nextStatus;
  final double? amount;
  final DateTime? dateCreated;
  final DateTime? timeDelivered;
  final OrderDetails? order;
  // Fields from socket data
  final String? number;
  final int? minsEstimated;

  final String? otp;

  OrderModel({
    this.id,
    required String status,
    this.otp,

    this.amount,
    this.dateCreated,
    this.timeDelivered,
    this.order,
    this.number,
    this.minsEstimated,
  }) : status = status.obs,
       nextStatus = RxnString(_nextStatusMap[status]);

  void updateStatus(String newStatus) {
    status.value = newStatus;
    nextStatus.value = _nextStatusMap[newStatus];
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'], // Handle both _id and id
      status: json['status'],
      otp: json['otp'],
      amount: (json['amount'] as num?)?.toDouble(),
      dateCreated: json['dateCreated'] != null
          ? DateTime.tryParse(json['dateCreated'])
          : null,
      timeDelivered: json['timeDelivered'] != null
          ? DateTime.tryParse(json['timeDelivered'])
          : null,
      order: json['order'] != null
          ? OrderDetails.fromJson(json['order'])
          : null,
      number: json['number'], // From socket
      minsEstimated: json['minsEstimated'], // From socket
    );
  }
  static const Map<String, String> _nextStatusMap = {
    'OUT_FOR_DELIVERY': 'ARRIVED',
    'ARRIVED': 'DELIVERED',
    // Rider flow
    // 'DRIVER_ASSIGNED': 'PICKED_UP',
    // 'PICKED_UP': 'OUT_FOR_DELIVERY',
    // 'OUT_FOR_DELIVERY': 'ARRIVED',
    // 'ARRIVED': 'DELIVERED',
  };
}

class OrderDetails {
  final AddressModel? address;
  final String? paymentMethod;

  OrderDetails({this.address, this.paymentMethod});

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      paymentMethod: json['paymentMethod'],
    );
  }
}

class AddressModel {
  final String? latitude;
  final String? longitude;
  final String? mobileNumber;
  final String? city;
  final String? street1;
  final String? street2;
  final String? pincode;
  final String? name;

  AddressModel({
    this.latitude,
    this.longitude,
    this.mobileNumber,
    this.city,
    this.street1,
    this.street2,
    this.pincode,
    this.name,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      mobileNumber: json['mobileNumber'],
      city: json['city'],
      street1: json['street1'],
      street2: json['street2'],
      pincode: json['pincode'],
      name: json['name'],
    );
  }

  String get fullAddress {
    return [
      street1,
      street2,
      city,
      pincode,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }
}
