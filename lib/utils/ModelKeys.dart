class CommonKeys {
  static String id = 'id';
  static String address = 'address';
  static String serviceId = 'service_id';
  static String customerId = 'customer_id';
  static String providerId = 'provider_id';
  static String bookingId = 'booking_id';
  static String handymanId = 'handyman_id';
}

class UserKeys {
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String userName = 'username';
  static String email = 'email';
  static String password = 'password';
  static String userType = 'user_type';
  static String status = 'status';
  static String providerId = 'provider_id';
  static String contactNumber = 'contact_number';
  static String address = 'address';
  static String countryId = 'country_id';
  static String stateId = 'state_id';
  static String cityId = 'city_id';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String profileImage = 'profile_image';
  static String playerId = 'player_id';
  static String serviceAddressId = 'service_address_id';
  static String uid = 'uid';
}

class BookingServiceKeys {
  static String description = 'description';
  static String couponId = 'coupon_id';
  static String date = 'date';
  static String totalAmount = 'total_amount';
}

class BookingStatusKeys {
  static String pending = 'pending';
  static String accept = 'accept';
  static String onGoing = 'on_going';
  static String inProgress = 'in_progress';
  static String hold = 'hold';
  static String rejected = 'rejected';
  static String failed = 'failed';
  static String complete = 'completed';
  static String cancelled = 'cancelled';
}

class BookingUpdateKeys {
  static String date = 'date';
  static String description = 'description';
  static String startDate = 'start_date';
  static String endDate = 'end_date';
  static String reason = 'reason';
  static String status = 'status';
  static String startAt = 'start_at';
  static String endAt = 'end_at';
  static String durationDiff = 'duration_diff';
  static String paymentStatus = 'payment_status';
}

class NotificationKey {
  static String type = 'type';
  static String page = 'page';
}

class AddServiceKey {
  static String name = 'name';
  static String providerId = 'provider_id';
  static String categoryId = 'category_id';
  static String type = 'type';
  static String price = 'price';
  static String discountPrice = 'discount';
  static String description = 'description';
  static String isFeatured = 'is_featured';
  static String status = 'status';
  static String duration = 'duration';
  static String attachmentCount = 'attachment_count';
  static String serviceAttachment = 'service_attachment_';
  static String providerAddressId = ' provider_address_id';
}

class AddAddressKey {
  static String id = 'id';
  static String providerId = 'provider_id';
  static String latitude = 'latitude';
  static String longitude = 'longitude';
  static String status = 'status';
  static String address = 'address';
}

class AddDocument{
  static String documentId='document_id';
  static String isVerified='is_verified';
  static String providerDocument='provider_document';
}