import 'package:flutter/cupertino.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/BaseResponse.dart';
import 'package:handyman_provider_flutter/models/BookingDetailResponse.dart';
import 'package:handyman_provider_flutter/models/BookingListResponse.dart';
import 'package:handyman_provider_flutter/models/BookingStatusResponse.dart';
import 'package:handyman_provider_flutter/models/CaregoryResponse.dart';
import 'package:handyman_provider_flutter/models/CityListResponse.dart';
import 'package:handyman_provider_flutter/models/CountryListResponse.dart';
import 'package:handyman_provider_flutter/models/DashboardResponse.dart';
import 'package:handyman_provider_flutter/models/DocumentListResponse.dart';
import 'package:handyman_provider_flutter/models/LoginResponse.dart';
import 'package:handyman_provider_flutter/models/NotificationListResponse.dart';
import 'package:handyman_provider_flutter/models/PaymentListReasponse.dart';
import 'package:handyman_provider_flutter/models/ProfileUpdateResponse.dart';
import 'package:handyman_provider_flutter/models/ProviderDocumentListResponse.dart';
import 'package:handyman_provider_flutter/models/ServiceAddressesResponse.dart';
import 'package:handyman_provider_flutter/models/UserInfoResponse.dart';
import 'package:handyman_provider_flutter/models/RegisterResponse.dart';
import 'package:handyman_provider_flutter/models/ServiceDetailResponse.dart';
import 'package:handyman_provider_flutter/models/ServiceResponse.dart';
import 'package:handyman_provider_flutter/models/StateListResponse.dart';
import 'package:handyman_provider_flutter/models/UserData.dart';
import 'package:handyman_provider_flutter/models/UserListResponse.dart';
import 'package:handyman_provider_flutter/networks/NetworkUtils.dart';
import 'package:handyman_provider_flutter/screens/LoginScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

Future<RegisterResponse> registerUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> loginUser(Map request) async {
  LoginResponse res = LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('login', request: request, method: HttpMethod.POST))));
  await saveUserData(res.data!);
  await appStore.setLoggedIn(true);
  return res;
}

Future<void> saveUserData(UserData data) async {
  if(data.status==1) {
    if (data.apiToken.validate().isNotEmpty) await appStore.setToken(data.apiToken!);
    await appStore.setUserId(data.id.validate());
    await appStore.setFirstName(data.firstName.validate());
    await appStore.setLastName(data.lastName.validate());
    await appStore.setUserEmail(data.email.validate());
    await appStore.setUserName(data.username.validate());
    await appStore.setContactNumber('${data.contactNumber.validate()}');
    await appStore.setUserProfile(data.profileImage.validate());
    await appStore.setCountryId(data.countryId.validate());
    await appStore.setStateId(data.stateId.validate());
    await appStore.setUId(data.uid.validate());
    await appStore.setCityId(data.cityId.validate());
    await appStore.setAddress(data.address
        .validate()
        .isNotEmpty ? data.address.validate() : '');
  }
}

Future<void> logout(BuildContext context) async {
  showConfirmDialogCustom(
    context,
    primaryColor: primaryColor,
    title: context.translate.afterLogoutTxt,
    positiveText: context.translate.lblYes,
    negativeText: context.translate.lblNo,
    onAccept: (context) async {
      await appStore.setFirstName('');
      await appStore.setLastName('');
      await appStore.setUserEmail('');
      await appStore.setUserName('');
      await appStore.setContactNumber('');
      await appStore.setCountryId(0);
      await appStore.setStateId(0);
      await appStore.setCityId(0);
      await appStore.setUId('');
      await appStore.setToken('');
      await appStore.setLoggedIn(false);
      appStore.setLoading(false);
      push(LoginScreen(), isNewTask: true);
    },
  );
}

Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(await buildHttpResponse('country-list', method: HttpMethod.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}

Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethod.GET)));
  return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
}

Future<BookingListResponse> getBookingList(int page, {var perPage = perPageItem, String status = ''}) async {
  return BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethod.GET)));
}

Future<BookingDetailResponse> bookingDetail(Map request) async {
  return BookingDetailResponse.fromJson(await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> bookingUpdate(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethod.POST)));
}

Future<PaymentListResponse> getPaymentList(int page, {var perPage = perPageItem}) async {
  return PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?per_page="$perPage"&page=$page', method: HttpMethod.GET)));
}

Future<BaseResponse> changeUserPassword(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethod.POST)));
}

Future<DashboardResponse> providerDashboard() async {
  return DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('provider-dashboard', method: HttpMethod.GET)));
}

Future<ServiceResponse> getServiceList(int page,int providerId, {String? searchTxt, bool isSearch = false, int? categoryId, bool isCategoryWise = false}) async {
  if (isCategoryWise) {
    return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&category_id=$categoryId&page=$page&provider_id=$providerId', method: HttpMethod.GET)));
  } else if (isSearch) {
    return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&search=$searchTxt&provider_id=$providerId', method: HttpMethod.GET)));
  } else {
    return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&provider_id=$providerId', method: HttpMethod.GET)));
  }
}

Future<NotificationListResponse> getNotification(Map request, {int? page = 1}) async {
  return NotificationListResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list?page=$page', request: request, method: HttpMethod.POST)));
}

Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethod.POST)));
}

Future<UserListResponse> getHandyman({bool isPagination = false, int? page, int? providerId, String? userTypeHandyman = "handyman"}) async {
  if (isPagination) {
    return UserListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userTypeHandyman&provider_id=$providerId&per_page=$perPageItem&page=$page', method: HttpMethod.GET)));
  } else {
    return UserListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userTypeHandyman&provider_id=$providerId', method: HttpMethod.GET)));
  }
}

Future<UserInfoResponse> getUserDetail(int id) async {
  return UserInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future<CategoryResponse> getCategoryList() async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?per_page=all', method: HttpMethod.GET)));
}

Future<BaseResponse> assignBooking(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('booking-assigned', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> forgotPassword(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethod.POST)));
}
Future<BaseResponse> updateHandymanStatus(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('user-update-status', request: request, method: HttpMethod.POST)));
}

Future<ServiceAddressesResponse> getAddresses({int? providerId}) async {
  return ServiceAddressesResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$providerId', method: HttpMethod.GET)));
}

Future<BaseResponse> addAddresses(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-provideraddress', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> removeAddress(int? id) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-delete/$id', method: HttpMethod.POST)));
}

Future<ProfileUpdateResponse> updateProfile(Map request) async {
  return ProfileUpdateResponse.fromJson(await handleResponse(await buildHttpResponse('update-profile',request: request, method: HttpMethod.POST)));
}

Future<ProfileUpdateResponse> deleteService(int id) async {
  return ProfileUpdateResponse.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', method: HttpMethod.POST)));
}

Future<DocumentListResponse> getDocList() async {
  return DocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('document-list', method: HttpMethod.GET)));
}

Future<ProviderDocumentListResponse> getProviderDoc() async {
  return ProviderDocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('provider-document-list', method: HttpMethod.GET)));
}
Future<ProfileUpdateResponse> deleteProviderDoc(int? id) async {
  return ProfileUpdateResponse.fromJson(await handleResponse(await buildHttpResponse('provider-document-delete/$id', method: HttpMethod.POST)));
}