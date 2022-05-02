import 'package:handyman_provider_flutter/models/BookingDetailResponse.dart';

class BookingListResponse {
  List<Data>? data;
  Pagination? pagination;

  BookingListResponse({required this.data, required this.pagination});

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => Data.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? totalItems;
  String? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  String? nextPage;
  String? previousPage;

  Pagination({this.totalItems, this.perPage, this.currentPage, this.totalPages, this.from, this.to, this.nextPage, this.previousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    from = json['from'];
    to = json['to'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_items'] = this.totalItems;
    data['per_page'] = this.perPage;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['from'] = this.from;
    data['to'] = this.to;
    data['next_page'] = this.nextPage;
    data['previous_page'] = this.previousPage;
    return data;
  }
}
//
// class Data {
//   int? id;
//   String? address;
//   int? customerId;
//   int? serviceId;
//   int? providerId;
//   num? price;
//   String? type;
//   String? date;
//   num? discount;
//   String? status;
//   String? statusLabel;
//   String? description;
//   String? providerName;
//   String? customerName;
//   String? serviceName;
//   String? paymentStatus;
//   String? paymentMethod;
//
//   Data({
//     this.id,
//     this.address,
//     this.customerId,
//     this.serviceId,
//     this.providerId,
//     this.price,
//     this.type,
//     this.date,
//     this.discount,
//     this.status,
//     this.statusLabel,
//     this.description,
//     this.providerName,
//     this.customerName,
//     this.serviceName,
//     this.paymentStatus,
//     this.paymentMethod,
//   });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     address = json['address'];
//     customerId = json['customer_id'];
//     serviceId = json['service_id'];
//     providerId = json['provider_id'];
//     price = json['price'];
//     type = json['type'];
//     date = json['date'];
//     discount = json['discount'];
//     status = json['status'];
//     statusLabel = json['status_label'];
//     description = json['description'];
//     providerName = json['provider_name'];
//     customerName = json['customer_name'];
//     serviceName = json['service_name'];
//     paymentStatus = json['payment_status'];
//     paymentMethod = json['payment_method'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['address'] = this.address;
//     data['customer_id'] = this.customerId;
//     data['service_id'] = this.serviceId;
//     data['provider_id'] = this.providerId;
//     data['price'] = this.price;
//     data['type'] = this.type;
//     data['date'] = this.date;
//     data['discount'] = this.discount;
//     data['status'] = this.status;
//     data['status_label'] = this.statusLabel;
//     data['description'] = this.description;
//     data['provider_name'] = this.providerName;
//     data['customer_name'] = this.customerName;
//     data['service_name'] = this.serviceName;
//     data['payment_status'] = this.paymentStatus;
//     data['payment_method'] = this.paymentMethod;
//     return data;
//   }
// }

class Data {
  String? address;
  int? customer_id;
  String? customer_name;
  String? date;
  String? description;
  num? discount;
  String? duration_diff;
  String? duration_diff_hour;
  List<Handyman>? handyman;
  int? id;
  int? payment_id;
  String? payment_method;
  String? payment_status;
  num? price;
  int? provider_id;
  String? provider_name;
  List<String>? service_attchments;
  int? service_id;
  String? service_name;
  String? status;
  String? status_label;
  String? type;
  int? booking_address_id;

  Data(
      {this.address,
      this.customer_id,
      this.customer_name,
      this.date,
      this.description,
      this.discount,
      this.duration_diff,
      this.duration_diff_hour,
      this.handyman,
      this.id,
      this.payment_id,
      this.payment_method,
      this.payment_status,
      this.price,
      this.provider_id,
      this.provider_name,
      this.service_attchments,
      this.service_id,
      this.service_name,
      this.status,
      this.status_label,
      this.type,
      this.booking_address_id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      address: json['address'],
      customer_id: json['customer_id'],
      customer_name: json['customer_name'],
      date: json['date'],
      description: json['description'],
      discount: json['discount'],
      duration_diff: json['duration_diff'],
      duration_diff_hour: json['duration_diff_hour'],
      handyman: (json['handyman'] as List).map((i) => Handyman.fromJson(i)).toList(),
      id: json['id'],
      payment_id: json['payment_id'],
      payment_method: json['payment_method'],
      payment_status: json['payment_status'],
      price: json['price'],
      provider_id: json['provider_id'],
      provider_name: json['provider_name'],
      service_attchments: json['service_attchments'] != null ? new List<String>.from(json['service_attchments']) : null,
      service_id: json['service_id'],
      service_name: json['service_name'],
      status: json['status'],
      status_label: json['status_label'],
      type: json['type'],
      booking_address_id: json['booking_address_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customer_id;
    data['customer_name'] = this.customer_name;
    data['date'] = this.date;
    data['discount'] = this.discount;
    data['duration_diff'] = this.duration_diff;
    data['id'] = this.id;
    data['price'] = this.price;
    data['provider_id'] = this.provider_id;
    data['provider_name'] = this.provider_name;
    data['service_id'] = this.service_id;
    data['service_name'] = this.service_name;
    data['status'] = this.status;
    data['status_label'] = this.status_label;
    data['type'] = this.type;
    data['address'] = this.address;
    data['description'] = this.description;
    data['duration_diff_hour'] = this.duration_diff_hour;
    data['handyman'] = this.handyman;
    data['payment_id'] = this.payment_id;
    data['payment_method'] = this.payment_method;
    data['payment_status'] = this.payment_status;
    data['service_attchments'] = this.service_attchments;
    data['booking_address_id'] = this.booking_address_id;
    return data;
  }
}

class Handyman {
  int? id;
  int? bookingId;
  int? handymanId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  HandymanData? handyman;

  Handyman({this.id, this.bookingId, this.handymanId, this.createdAt, this.updatedAt, this.deletedAt, this.handyman});

  Handyman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    handymanId = json['handyman_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    handyman = json['handyman'] != null ? new HandymanData.fromJson(json['handyman']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['handyman_id'] = this.handymanId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.toJson();
    }
    return data;
  }
}

class HandymanX {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? userType;
  String? loginType;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? address;
  int? providerId;
  String? playerId;
  int? status;
  int? providertypeId;
  int? isFeatured;
  String? displayName;
  String? timeZone;
  String? lastNotificationSeen;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  HandymanX(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerifiedAt,
      this.userType,
      this.loginType,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.address,
      this.providerId,
      this.playerId,
      this.status,
      this.providertypeId,
      this.isFeatured,
      this.displayName,
      this.timeZone,
      this.lastNotificationSeen,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  HandymanX.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    userType = json['user_type'];
    loginType = json['login_type'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    providerId = json['provider_id'];
    playerId = json['player_id'];
    status = json['status'];
    providertypeId = json['providertype_id'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['user_type'] = this.userType;
    data['login_type'] = this.loginType;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['provider_id'] = this.providerId;
    data['player_id'] = this.playerId;
    data['status'] = this.status;
    data['providertype_id'] = this.providertypeId;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

// class Handyman {
//   int? booking_id;
//   String? created_at;
//   String? deleted_at;
//   HandymanX? handyman;
//   int? handyman_id;
//   int? id;
//   String? updated_at;
//
//   Handyman({this.booking_id, this.created_at, this.deleted_at, this.handyman, this.handyman_id, this.id, this.updated_at});
//
//   factory Handyman.fromJson(Map<String, dynamic> json) {
//     return Handyman(
//       booking_id: json['booking_id'],
//       created_at: json['created_at'],
//       deleted_at: json['deleted_at'],
//       handyman: json['handyman'],
//       handyman_id: json['handyman_id'],
//       id: json['id'],
//       updated_at: json['updated_at'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['booking_id'] = this.booking_id;
//     data['handyman_id'] = this.handyman_id;
//     data['id'] = this.id;
//     data['created_at'] = this.created_at;
//     data['deleted_at'] = this.deleted_at;
//     data['handyman'] = this.handyman;
//     data['updated_at'] = this.updated_at;
//     return data;
//   }
// }
//
// class HandymanX {
//   String? address;
//   int? city_id;
//   String? contact_number;
//   int? country_id;
//   String? created_at;
//   String? deleted_at;
//   String? display_name;
//   String? email;
//   String? email_verified_at;
//   String? first_name;
//   int? id;
//   int? is_featured;
//   String? last_name;
//   String? last_notification_seen;
//   String? login_type;
//   String? player_id;
//   int? provider_id;
//   int? providertype_id;
//   int? state_id;
//   int? status;
//   String? time_zone;
//   String? updated_at;
//   String? user_type;
//   String? username;
//
//   HandymanX(
//       {this.address,
//       this.city_id,
//       this.contact_number,
//       this.country_id,
//       this.created_at,
//       this.deleted_at,
//       this.display_name,
//       this.email,
//       this.email_verified_at,
//       this.first_name,
//       this.id,
//       this.is_featured,
//       this.last_name,
//       this.last_notification_seen,
//       this.login_type,
//       this.player_id,
//       this.provider_id,
//       this.providertype_id,
//       this.state_id,
//       this.status,
//       this.time_zone,
//       this.updated_at,
//       this.user_type,
//       this.username});
//
//   factory HandymanX.fromJson(Map<String, dynamic> json) {
//     return HandymanX(
//       address: json['address'],
//       city_id: json['city_id'],
//       contact_number: json['contact_number'],
//       country_id: json['country_id'],
//       created_at: json['created_at'],
//       deleted_at: json['deleted_at'],
//       display_name: json['display_name'],
//       email: json['email'],
//       email_verified_at: json['email_verified_at'],
//       first_name: json['first_name'],
//       id: json['id'],
//       is_featured: json['is_featured'],
//       last_name: json['last_name'],
//       last_notification_seen: json['last_notification_seen'],
//       login_type: json['login_type'],
//       player_id: json['player_id'],
//       provider_id: json['provider_id'],
//       providertype_id: json['providertype_id'],
//       state_id: json['state_id'],
//       status: json['status'],
//       time_zone: json['time_zone'],
//       updated_at: json['updated_at'],
//       user_type: json['user_type'],
//       username: json['username'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['address'] = this.address;
//     data['city_id'] = this.city_id;
//     data['contact_number'] = this.contact_number;
//     data['country_id'] = this.country_id;
//     data['created_at'] = this.created_at;
//     data['display_name'] = this.display_name;
//     data['email'] = this.email;
//     data['first_name'] = this.first_name;
//     data['id'] = this.id;
//     data['is_featured'] = this.is_featured;
//     data['last_name'] = this.last_name;
//     data['last_notification_seen'] = this.last_notification_seen;
//     data['player_id'] = this.player_id;
//     data['provider_id'] = this.provider_id;
//     data['state_id'] = this.state_id;
//     data['status'] = this.status;
//     data['time_zone'] = this.time_zone;
//     data['updated_at'] = this.updated_at;
//     data['user_type'] = this.user_type;
//     data['username'] = this.username;
//     data['deleted_at'] = this.deleted_at;
//     data['email_verified_at'] = this.email_verified_at;
//     data['login_type'] = this.login_type;
//     data['providertype_id'] = this.providertype_id;
//     return data;
//   }
// }
//
//
