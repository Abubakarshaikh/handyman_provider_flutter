class ProviderDocumentListResponse {
  Pagination? pagination;
  List<ProviderDocuments>? providerDocuments;

  ProviderDocumentListResponse({this.pagination, this.providerDocuments});

  ProviderDocumentListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      providerDocuments = [];
      json['data'].forEach((v) {
        providerDocuments!.add(new ProviderDocuments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.providerDocuments != null) {
      data['data'] = this.providerDocuments!.map((v) => v.toJson()).toList();
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

  Pagination(
      {this.totalItems,
        this.perPage,
        this.currentPage,
        this.totalPages,
        this.from,
        this.to,
        this.nextPage,
        this.previousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
   /* totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    from = json['from'];
    to = json['to'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];*/
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

class ProviderDocuments {
  int? id;
  int? providerId;
  int? documentId;
  String? documentName;
  int? isVerified;
  String? providerDocument;

  ProviderDocuments(
      {this.id,
        this.providerId,
        this.documentId,
        this.documentName,
        this.isVerified,this.providerDocument});

  ProviderDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    documentId = json['document_id'];
    documentName = json['document_name'];
    isVerified = json['is_verified'];
    providerDocument = json['provider_document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['document_id'] = this.documentId;
    data['document_name'] = this.documentName;
    data['is_verified'] = this.isVerified;
    data['provider_document'] = this.providerDocument;
    return data;
  }
}
