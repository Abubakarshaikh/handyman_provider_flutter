// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  Computed<String>? _$userFullNameComputed;

  @override
  String get userFullName =>
      (_$userFullNameComputed ??= Computed<String>(() => super.userFullName,
              name: '_AppStore.userFullName'))
          .value;

  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$isDarkModeAtom = Atom(name: '_AppStore.isDarkMode');

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$isRememberMeAtom = Atom(name: '_AppStore.isRememberMe');

  @override
  bool get isRememberMe {
    _$isRememberMeAtom.reportRead();
    return super.isRememberMe;
  }

  @override
  set isRememberMe(bool value) {
    _$isRememberMeAtom.reportWrite(value, super.isRememberMe, () {
      super.isRememberMe = value;
    });
  }

  final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode');

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage');

  @override
  String get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$uIdAtom = Atom(name: '_AppStore.uId');

  @override
  String get uId {
    _$uIdAtom.reportRead();
    return super.uId;
  }

  @override
  set uId(String value) {
    _$uIdAtom.reportWrite(value, super.uId, () {
      super.uId = value;
    });
  }

  final _$userFirstNameAtom = Atom(name: '_AppStore.userFirstName');

  @override
  String get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  final _$userLastNameAtom = Atom(name: '_AppStore.userLastName');

  @override
  String get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  final _$userContactNumberAtom = Atom(name: '_AppStore.userContactNumber');

  @override
  String get userContactNumber {
    _$userContactNumberAtom.reportRead();
    return super.userContactNumber;
  }

  @override
  set userContactNumber(String value) {
    _$userContactNumberAtom.reportWrite(value, super.userContactNumber, () {
      super.userContactNumber = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$userNameAtom = Atom(name: '_AppStore.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$tokenAtom = Atom(name: '_AppStore.token');

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  final _$countryIdAtom = Atom(name: '_AppStore.countryId');

  @override
  int get countryId {
    _$countryIdAtom.reportRead();
    return super.countryId;
  }

  @override
  set countryId(int value) {
    _$countryIdAtom.reportWrite(value, super.countryId, () {
      super.countryId = value;
    });
  }

  final _$stateIdAtom = Atom(name: '_AppStore.stateId');

  @override
  int get stateId {
    _$stateIdAtom.reportRead();
    return super.stateId;
  }

  @override
  set stateId(int value) {
    _$stateIdAtom.reportWrite(value, super.stateId, () {
      super.stateId = value;
    });
  }

  final _$cityIdAtom = Atom(name: '_AppStore.cityId');

  @override
  int get cityId {
    _$cityIdAtom.reportRead();
    return super.cityId;
  }

  @override
  set cityId(int value) {
    _$cityIdAtom.reportWrite(value, super.cityId, () {
      super.cityId = value;
    });
  }

  final _$addressAtom = Atom(name: '_AppStore.address');

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  final _$playerIdAtom = Atom(name: '_AppStore.playerId');

  @override
  String get playerId {
    _$playerIdAtom.reportRead();
    return super.playerId;
  }

  @override
  set playerId(String value) {
    _$playerIdAtom.reportWrite(value, super.playerId, () {
      super.playerId = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  int? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$initialAdCountAtom = Atom(name: '_AppStore.initialAdCount');

  @override
  int get initialAdCount {
    _$initialAdCountAtom.reportRead();
    return super.initialAdCount;
  }

  @override
  set initialAdCount(int value) {
    _$initialAdCountAtom.reportWrite(value, super.initialAdCount, () {
      super.initialAdCount = value;
    });
  }

  final _$setUserProfileAsyncAction = AsyncAction('_AppStore.setUserProfile');

  @override
  Future<void> setUserProfile(String val, {bool isInitializing = false}) {
    return _$setUserProfileAsyncAction
        .run(() => super.setUserProfile(val, isInitializing: isInitializing));
  }

  final _$setPlayerIdAsyncAction = AsyncAction('_AppStore.setPlayerId');

  @override
  Future<void> setPlayerId(String val, {bool isInitializing = false}) {
    return _$setPlayerIdAsyncAction
        .run(() => super.setPlayerId(val, isInitializing: isInitializing));
  }

  final _$setTokenAsyncAction = AsyncAction('_AppStore.setToken');

  @override
  Future<void> setToken(String val, {bool isInitializing = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitializing: isInitializing));
  }

  final _$setCountryIdAsyncAction = AsyncAction('_AppStore.setCountryId');

  @override
  Future<void> setCountryId(int val, {bool isInitializing = false}) {
    return _$setCountryIdAsyncAction
        .run(() => super.setCountryId(val, isInitializing: isInitializing));
  }

  final _$setStateIdAsyncAction = AsyncAction('_AppStore.setStateId');

  @override
  Future<void> setStateId(int val, {bool isInitializing = false}) {
    return _$setStateIdAsyncAction
        .run(() => super.setStateId(val, isInitializing: isInitializing));
  }

  final _$setCityIdAsyncAction = AsyncAction('_AppStore.setCityId');

  @override
  Future<void> setCityId(int val, {bool isInitializing = false}) {
    return _$setCityIdAsyncAction
        .run(() => super.setCityId(val, isInitializing: isInitializing));
  }

  final _$setUIdAsyncAction = AsyncAction('_AppStore.setUId');

  @override
  Future<void> setUId(String val, {bool isInitializing = false}) {
    return _$setUIdAsyncAction
        .run(() => super.setUId(val, isInitializing: isInitializing));
  }

  final _$setUserIdAsyncAction = AsyncAction('_AppStore.setUserId');

  @override
  Future<void> setUserId(int val, {bool isInitializing = false}) {
    return _$setUserIdAsyncAction
        .run(() => super.setUserId(val, isInitializing: isInitializing));
  }

  final _$setUserEmailAsyncAction = AsyncAction('_AppStore.setUserEmail');

  @override
  Future<void> setUserEmail(String val, {bool isInitializing = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitializing: isInitializing));
  }

  final _$setAddressAsyncAction = AsyncAction('_AppStore.setAddress');

  @override
  Future<void> setAddress(String val, {bool isInitializing = false}) {
    return _$setAddressAsyncAction
        .run(() => super.setAddress(val, isInitializing: isInitializing));
  }

  final _$setFirstNameAsyncAction = AsyncAction('_AppStore.setFirstName');

  @override
  Future<void> setFirstName(String val, {bool isInitializing = false}) {
    return _$setFirstNameAsyncAction
        .run(() => super.setFirstName(val, isInitializing: isInitializing));
  }

  final _$setLastNameAsyncAction = AsyncAction('_AppStore.setLastName');

  @override
  Future<void> setLastName(String val, {bool isInitializing = false}) {
    return _$setLastNameAsyncAction
        .run(() => super.setLastName(val, isInitializing: isInitializing));
  }

  final _$setContactNumberAsyncAction =
      AsyncAction('_AppStore.setContactNumber');

  @override
  Future<void> setContactNumber(String val, {bool isInitializing = false}) {
    return _$setContactNumberAsyncAction
        .run(() => super.setContactNumber(val, isInitializing: isInitializing));
  }

  final _$setUserNameAsyncAction = AsyncAction('_AppStore.setUserName');

  @override
  Future<void> setUserName(String val, {bool isInitializing = false}) {
    return _$setUserNameAsyncAction
        .run(() => super.setUserName(val, isInitializing: isInitializing));
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) {
    return _$setLoggedInAsyncAction
        .run(() => super.setLoggedIn(val, isInitializing: isInitializing));
  }

  final _$setInitialAdCountAsyncAction =
      AsyncAction('_AppStore.setInitialAdCount');

  @override
  Future<void> setInitialAdCount(int val) {
    return _$setInitialAdCountAsyncAction
        .run(() => super.setInitialAdCount(val));
  }

  final _$setDarkModeAsyncAction = AsyncAction('_AppStore.setDarkMode');

  @override
  Future<void> setDarkMode(bool val) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(val));
  }

  final _$setLanguageAsyncAction = AsyncAction('_AppStore.setLanguage');

  @override
  Future<void> setLanguage(String val, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(val, context: context));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRemember(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setRemember');
    try {
      return super.setRemember(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
isRememberMe: ${isRememberMe},
selectedLanguageCode: ${selectedLanguageCode},
userProfileImage: ${userProfileImage},
uId: ${uId},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
userContactNumber: ${userContactNumber},
userEmail: ${userEmail},
userName: ${userName},
token: ${token},
countryId: ${countryId},
stateId: ${stateId},
cityId: ${cityId},
address: ${address},
playerId: ${playerId},
userId: ${userId},
initialAdCount: ${initialAdCount},
userFullName: ${userFullName}
    ''';
  }
}
