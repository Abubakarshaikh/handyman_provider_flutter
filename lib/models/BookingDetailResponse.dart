import 'package:handyman_provider_flutter/models/UserData.dart';

class BookingDetailResponse {
  BookingDetail? bookingDetail;
  Service? service;
  UserData? customer;
  List<BookingActivity>? bookingActivity;
  List<RatingData>? ratingData;
  ProviderData? providerData;
  List<UserData>? handymanData;

  // List<Null>? handymanData;

  BookingDetailResponse({this.bookingDetail, this.service, this.customer, this.bookingActivity, this.ratingData, this.providerData, this.handymanData});

  BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['booking_detail'] != null ? new BookingDetail.fromJson(json['booking_detail']) : null;
    service = json['service'] != null ? new Service.fromJson(json['service']) : null;
    customer = json['customer'] != null ? new UserData.fromJson(json['customer']) : null;
    if (json['booking_activity'] != null) {
      bookingActivity = [];
      json['booking_activity'].forEach((v) {
        bookingActivity!.add(new BookingActivity.fromJson(v));
      });
    }
    providerData = json['provider_data'] != null ? new ProviderData.fromJson(json['provider_data']) : null;
    if (json['rating_data'] != null) {
      ratingData = [];
      json['rating_data'].forEach((v) {
        ratingData!.add(new RatingData.fromJson(v));
      });
    }
    if (json['handyman_data'] != null) {
      handymanData = [];
      json['handyman_data'].forEach((v) {
        handymanData!.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingDetail != null) {
      data['booking_detail'] = this.bookingDetail!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.bookingActivity != null) {
      data['booking_activity'] = this.bookingActivity!.map((v) => v.toJson()).toList();
    }
    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.providerData != null) {
      data['provider_data'] = this.providerData!.toJson();
    }

    if (this.handymanData != null) {
      data['handyman_data'] = this.handymanData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingDetail {
  int? id;
  String? address;
  int? customerId;
  int? serviceId;
  int? providerId;
  num? price;
  int? quantity;
  String? type;
  num? discount;
  String? status;
  String? statusLabel;
  String? description;
  String? providerName;
  String? customerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;
  int? totalReview;
  num? totalRating;
  int? isCancelled;
  String? reason;
  String? date;
  String? startAt;
  String? endAt;
  String? durationDiff;
  int? paymentId;
  int? booking_address_id;

  BookingDetail(
      {this.id,
      this.address,
      this.customerId,
      this.serviceId,
      this.providerId,
      this.price,
      this.quantity,
      this.type,
      this.discount,
      this.status,
      this.statusLabel,
      this.description,
      this.providerName,
      this.customerName,
      this.serviceName,
      this.paymentStatus,
      this.paymentMethod,
      this.totalReview,
      this.totalRating,
      this.isCancelled,
      this.reason,
      this.date,
      this.startAt,
      this.endAt,
      this.durationDiff,
      this.paymentId,
      this.booking_address_id});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    customerId = json['customer_id'];
    serviceId = json['service_id'];
    providerId = json['provider_id'];
    price = json['price'];
    quantity = json['quantity'];
    type = json['type'];
    discount = json['discount'];
    status = json['status'];
    statusLabel = json['status_label'];
    description = json['description'];
    providerName = json['provider_name'];
    customerName = json['customer_name'];
    serviceName = json['service_name'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    totalReview = json['total_review'];
    totalRating = json['total_rating'];
    isCancelled = json['is_cancelled'];
    reason = json['reason'];
    date = json['date'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    durationDiff = json['duration_diff'];
    paymentId = json['payment_id'];
    booking_address_id=json['booking_address_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['customer_id'] = this.customerId;
    data['service_id'] = this.serviceId;
    data['provider_id'] = this.providerId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['description'] = this.description;
    data['provider_name'] = this.providerName;
    data['customer_name'] = this.customerName;
    data['service_name'] = this.serviceName;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['is_cancelled'] = this.isCancelled;
    data['reason'] = this.reason;
    data['date'] = this.date;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['duration_diff'] = this.durationDiff;
    data['payment_id'] = this.paymentId;
    data['booking_address_id'] = this.booking_address_id;
    return data;
  }
}

class Service {
  int? id;
  String? name;
  int? categoryId;
  int? providerId;
  num? price;
  String? priceFormat;
  String? type;
  num? discount;
  num? duration;
  int? status;
  String? description;
  int? isFeatured;
  String? providerName;
  int? cityId;
  String? categoryName;
  List<String>? attchments;
  int? totalReview;
  num? totalRating;

  Service(
      {this.id,
      this.name,
      this.categoryId,
      this.providerId,
      this.price,
      this.priceFormat,
      this.type,
      this.discount,
      this.duration,
      this.status,
      this.description,
      this.isFeatured,
      this.providerName,
      this.cityId,
      this.categoryName,
      this.attchments,
      this.totalReview,
      this.totalRating});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    providerId = json['provider_id'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    // discount = json['discount'];
    // duration = json['duration'];
    status = json['status'];
    description = json['description'];
    isFeatured = json['is_featured'];
    providerName = json['provider_name'];
    cityId = json['city_id'];
    categoryName = json['category_name'];
    attchments = json['attchments'].cast<String>();
    totalReview = json['total_review'];
    totalRating = json['total_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['provider_id'] = this.providerId;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['provider_name'] = this.providerName;
    data['city_id'] = this.cityId;
    data['category_name'] = this.categoryName;
    data['attchments'] = this.attchments;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  int? status;

  // String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      // this.description,
      this.userType,
      this.email,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.cityName,
      this.address,
      this.providertypeId,
      this.providertype,
      this.isFeatured,
      this.displayName,
      this.createdAt,
      this.updatedAt,
      this.profileImage});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    // description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    // data['description'] = this.description;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['providertype_id'] = this.providertypeId;
    data['providertype'] = this.providertype;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

class BookingActivity {
  int? id;
  int? bookingId;
  String? datetime;
  String? activityType;
  String? activityMessage;
  String? activityData;
  String? createdAt;
  String? updatedAt;

  BookingActivity({this.id, this.bookingId, this.datetime, this.activityType, this.activityMessage, this.activityData, this.createdAt, this.updatedAt});

  BookingActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    datetime = json['datetime'];
    activityType = json['activity_type'];
    activityMessage = json['activity_message'];
    activityData = json['activity_data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['datetime'] = this.datetime;
    data['activity_type'] = this.activityType;
    data['activity_message'] = this.activityMessage;
    data['activity_data'] = this.activityData;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class RatingData {
  int? id;
  num? rating;
  String? review;
  int? serviceId;
  int? bookingId;
  String? createdAt;
  String? customerName;
  String? profileImage;

  RatingData({this.id, this.rating, this.review, this.serviceId, this.bookingId, this.createdAt, this.customerName, this.profileImage});

  RatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    createdAt = json['created_at'];
    customerName = json['customer_name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['customer_name'] = this.customerName;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

class ProviderData {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;

  ProviderData(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      this.description,
      this.userType,
      this.email,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.cityName,
      this.address,
      this.providertypeId,
      this.providertype,
      this.isFeatured,
      this.displayName,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.timeZone,
      this.lastNotificationSeen});

  ProviderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['providertype_id'] = this.providertypeId;
    data['providertype'] = this.providertype;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    return data;
  }
}

class HandymanData {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;

  HandymanData(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      this.description,
      this.userType,
      this.email,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.cityName,
      this.address,
      this.providertypeId,
      this.providertype,
      this.isFeatured,
      this.displayName,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.timeZone,
      this.lastNotificationSeen});

  HandymanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['providertype_id'] = this.providertypeId;
    data['providertype'] = this.providertype;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    return data;
  }
}
