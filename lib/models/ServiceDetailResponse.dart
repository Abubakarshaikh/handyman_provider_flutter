class ServiceDetailResponse {
    // List<Object>? coupon_data;
    // CustomerReview? customer_review;
    Provider? provider;
    // List<Object>? rating_data;
    ServiceDetail? service_detail;

    ServiceDetailResponse({this.provider, this.service_detail});

    factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
        return ServiceDetailResponse(
            // coupon_data: json['coupon_data'] != null ? (json['coupon_data'] as List).map((i) => Object.fromJson(i)).toList() : null,
            // customer_review: json['customer_review'] != null ? CustomerReview!.fromJson(json['customer_review']) : null,
            provider: json['provider'] != null ? Provider.fromJson(json['provider']) : null, 
            // rating_data: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => Object.fromJson(i)).toList() : null,
            service_detail: json['service_detail'] != null ? ServiceDetail.fromJson(json['service_detail']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();

        // if (this.customer_review != null) {
        //     data['customer_review'] = this.customer_review;
        // }
        if (this.provider != null) {
            data['provider'] = this.provider!.toJson();
        }
        if (this.service_detail != null) {
            data['service_detail'] = this.service_detail!.toJson();
        }
        return data;
    }
}

class CustomerReview {

    CustomerReview({CustomerReview});
    //
    // factory CustomerReview.fromJson(Map<String, dynamic> json) {
    //     return CustomerReview(
    //     );
    // }
    //
    // Map<String, dynamic> toJson() {
    //     final Map<String, dynamic> data = new Map<String, dynamic>();
    //     return data;
    // }
}

class ServiceDetail {
    List<String>? attchments;
    int? category_id;
    String? category_name;
    String? description;
    num? discount;
    String? duration;
    int? id;
    int? is_favourite;
    int? is_featured;
    String? name;
    num? price;
    var price_format;
    int? provider_id;
    String? provider_name;
    List<ServiceAddressMapping>? service_address_mapping;
    var status;
    num? total_rating;
    num? total_review;
    String? type;

    ServiceDetail({this.attchments, this.category_id, this.category_name, this.description, this.discount, this.duration, this.id, this.is_favourite, this.is_featured, this.name, this.price, this.price_format, this.provider_id, this.provider_name, this.service_address_mapping, this.status, this.total_rating, this.total_review, this.type});

    factory ServiceDetail.fromJson(Map<String, dynamic> json) {
        return ServiceDetail(
            attchments: json['attchments'] != null ? new List<String>.from(json['attchments']) : [],
            category_id: json['category_id'], 
            category_name: json['category_name'], 
            description: json['description'], 
            discount: json['discount'] ,
            duration: json['duration'],
            id: json['id'], 
            is_favourite: json['is_favourite'], 
            is_featured: json['is_featured'], 
            name: json['name'], 
            price: json['price'], 
            price_format: json['price_format'], 
            provider_id: json['provider_id'], 
            provider_name: json['provider_name'],
            service_address_mapping: json['service_address_mapping'] != null ? (json['service_address_mapping'] as List).map((i) => ServiceAddressMapping.fromJson(i)).toList() : null, 
            status: json['status'], 
            total_rating: json['total_rating'], 
            total_review: json['total_review'],
            type: json['type'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['category_id'] = this.category_id;
        data['category_name'] = this.category_name;
        data['description'] = this.description;
        data['duration'] = this.duration;
        data['id'] = this.id;
        data['is_favourite'] = this.is_favourite;
        data['is_featured'] = this.is_featured;
        data['name'] = this.name;
        data['price'] = this.price;
        data['price_format'] = this.price_format;
        data['provider_id'] = this.provider_id;
        data['status'] = this.status;
        data['total_rating'] = this.total_rating;
        data['total_review'] = this.total_review;
        data['type'] = this.type;
        if (this.attchments != null) {
            data['attchments'] = this.attchments;
        }
        if (this.discount != null) {
            data['discount'] = this.discount;
        }
        if (this.provider_name != null) {
            data['provider_name'] = this.provider_name;
        }
        if (this.service_address_mapping != null) {
            data['service_address_mapping'] = this.service_address_mapping!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class ServiceAddressMapping {
    String? created_at;
    int? id;
    int? provider_address_id;
    ProviderAddressMapping? provider_address_mapping;
    int? service_id;
    String? updated_at;

    ServiceAddressMapping({this.created_at, this.id, this.provider_address_id, this.provider_address_mapping, this.service_id, this.updated_at});

    factory ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
        return ServiceAddressMapping(
            created_at: json['created_at'] ,
            id: json['id'], 
            provider_address_id: json['provider_address_id'], 
            provider_address_mapping: json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null, 
            service_id: json['service_id'], 
            updated_at: json['updated_at'] ,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['provider_address_id'] = this.provider_address_id;
        data['service_id'] = this.service_id;
        if (this.created_at != null) {
            data['created_at'] = this.created_at;
        }
        if (this.provider_address_mapping != null) {
            data['provider_address_mapping'] = this.provider_address_mapping!.toJson();
        }
        if (this.updated_at != null) {
            data['updated_at'] = this.updated_at;
        }
        return data;
    }
}

class ProviderAddressMapping {
    String? address;
    String? created_at;
    int? id;
    String? latitude;
    String? longitude;
    int? provider_id;
    var status;
    String? updated_at;

    ProviderAddressMapping({this.address, this.created_at, this.id, this.latitude, this.longitude, this.provider_id, this.status, this.updated_at});

    factory ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
        return ProviderAddressMapping(
            address: json['address'], 
            created_at: json['created_at'], 
            id: json['id'], 
            latitude: json['latitude'], 
            longitude: json['longitude'], 
            provider_id: json['provider_id'], 
            status: json['status'], 
            updated_at: json['updated_at'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['created_at'] = this.created_at;
        data['id'] = this.id;
        data['latitude'] = this.latitude;
        data['longitude'] = this.longitude;
        data['provider_id'] = this.provider_id;
        data['status'] = this.status;
        data['updated_at'] = this.updated_at;
        return data;
    }
}

class Provider {
    String? address;
    int? city_id;
    String? city_name;
    String? contact_number;
    int? country_id;
    String? created_at;
    String? description;
    String? display_name;
    String? email;
    String? first_name;
    int? id;
    int? is_featured;
    String? last_name;
    String? last_notification_seen;
    String? login_type;
    String? profile_image;
    var provider_id;
    String? providertype;
    var providertype_id;
    var service_address_id;
    int? state_id;
    int? status;
    String? time_zone;
    var uid;
    String? updated_at;
    String? user_type;
    String? username;

    Provider({this.address, this.city_id, this.city_name, this.contact_number, this.country_id, this.created_at, this.description, this.display_name, this.email, this.first_name, this.id, this.is_featured, this.last_name, this.last_notification_seen, this.login_type, this.profile_image, this.provider_id, this.providertype, this.providertype_id, this.service_address_id, this.state_id, this.status, this.time_zone, this.uid, this.updated_at, this.user_type, this.username});

    factory Provider.fromJson(Map<String, dynamic> json) {
        return Provider(
            address: json['address'], 
            city_id: json['city_id'], 
            city_name: json['city_name'], 
            contact_number: json['contact_number'], 
            country_id: json['country_id'], 
            created_at: json['created_at'], 
            description: json['description'] ,
            display_name: json['display_name'], 
            email: json['email'], 
            first_name: json['first_name'], 
            id: json['id'], 
            is_featured: json['is_featured'], 
            last_name: json['last_name'], 
            last_notification_seen: json['last_notification_seen'], 
            login_type: json['login_type'] ,
            profile_image: json['profile_image'], 
            provider_id: json['provider_id'] ,
            providertype: json['providertype'], 
            providertype_id: json['providertype_id'], 
            service_address_id: json['service_address_id'] ,
            state_id: json['state_id'], 
            status: json['status'], 
            time_zone: json['time_zone'], 
            uid: json['uid'] ,
            updated_at: json['updated_at'], 
            user_type: json['user_type'], 
            username: json['username'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address'] = this.address;
        data['city_id'] = this.city_id;
        data['city_name'] = this.city_name;
        data['contact_number'] = this.contact_number;
        data['country_id'] = this.country_id;
        data['created_at'] = this.created_at;
        data['display_name'] = this.display_name;
        data['email'] = this.email;
        data['first_name'] = this.first_name;
        data['id'] = this.id;
        data['is_featured'] = this.is_featured;
        data['last_name'] = this.last_name;
        data['last_notification_seen'] = this.last_notification_seen;
        data['profile_image'] = this.profile_image;
        data['providertype'] = this.providertype;
        data['providertype_id'] = this.providertype_id;
        data['state_id'] = this.state_id;
        data['status'] = this.status;
        data['time_zone'] = this.time_zone;
        data['updated_at'] = this.updated_at;
        data['user_type'] = this.user_type;
        data['username'] = this.username;
        if (this.description != null) {
            data['description'] = this.description;
        }
        if (this.login_type != null) {
            data['login_type'] = this.login_type;
        }
        if (this.provider_id != null) {
            data['provider_id'] = this.provider_id;
        }
        if (this.service_address_id != null) {
            data['service_address_id'] = this.service_address_id.toJson();
        }
        if (this.uid != null) {
            data['uid'] = this.uid.toJson();
        }
        return data;
    }
}