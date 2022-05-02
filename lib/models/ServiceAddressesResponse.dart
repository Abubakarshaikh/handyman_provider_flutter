class ServiceAddressesResponse {
  Pagination? pagination;
  List<Data>? data;

  ServiceAddressesResponse({this.pagination, this.data});

  ServiceAddressesResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? totalItems;
  int? perPage;
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

class Data {
  int? id;
  int? providerId;
  String? latitude;
  String? longitude;
  var status;
  String? address;
  String? providerName;
  bool? isSelected;

  Data({
    this.id,
    this.providerId,
    this.latitude,
    this.longitude,
    this.status,
    this.address,
    this.isSelected,
    this.providerName,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    address = json['address'];
    providerName = json['provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['address'] = this.address;
    data['provider_name'] = this.providerName;
    return data;
  }
}
