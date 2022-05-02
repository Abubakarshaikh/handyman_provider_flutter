import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/CityListResponse.dart';
import 'package:handyman_provider_flutter/models/CountryListResponse.dart';
import 'package:handyman_provider_flutter/models/ProfileUpdateResponse.dart';
import 'package:handyman_provider_flutter/models/StateListResponse.dart';
import 'package:handyman_provider_flutter/networks/NetworkUtils.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import 'VerifyProviderScreen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? imageFile;
  PickedFile? pickedFile;

  List<CountryListResponse> countryList = [];
  List<StateListResponse> stateList = [];
  List<CityListResponse> cityList = [];

  CountryListResponse? selectedCountry;
  StateListResponse? selectedState;
  CityListResponse? selectedCity;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();

  int countryId = 0;
  int stateId = 0;
  int cityId = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    countryId = getIntAsync(COUNTRY_ID).validate();
    stateId = getIntAsync(STATE_ID).validate();
    cityId = getIntAsync(CITY_ID).validate();

    fNameCont.text = appStore.userFirstName.validate();
    lNameCont.text = appStore.userLastName.validate();
    emailCont.text = appStore.userEmail.validate();
    userNameCont.text = appStore.userName.validate();
    mobileCont.text = '${appStore.userContactNumber.validate()}';
    countryId = appStore.countryId.validate();
    stateId = appStore.stateId.validate();
    cityId = appStore.cityId.validate();
    addressCont.text = appStore.address.validate();

    if (getIntAsync(COUNTRY_ID) != 0) {
      await getCountry();
      await getStates(getIntAsync(COUNTRY_ID));
      if (getIntAsync(STATE_ID) != 0) {
        await getCity(getIntAsync(STATE_ID));
      }

      setState(() {});
    } else {
      await getCountry();
    }
  }

  Future<void> getCountry() async {
    await getCountryList().then((value) async {
      countryList.clear();
      countryList.addAll(value);
      setState(() {});
      value.forEach((e) {
        if (e.id == getIntAsync(COUNTRY_ID)) {
          selectedCountry = e;
        }
      });
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getStates(int countryId) async {
    appStore.setLoading(true);
    await getStateList({'country_id': countryId}).then((value) async {
      stateList.clear();
      stateList.addAll(value);
      value.forEach((e) {
        if (e.id == getIntAsync(STATE_ID)) {
          selectedState = e;
        }
      });
      setState(() {});
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getCity(int stateId) async {
    appStore.setLoading(true);

    await getCityList({'state_id': stateId}).then((value) async {
      cityList.clear();
      cityList.addAll(value);
      value.forEach((e) {
        if (e.id == getIntAsync(CITY_ID)) {
          selectedCity = e;
        }
      });
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> update() async {
    hideKeyboard(context);
    Map<String, dynamic> req = {
      UserKeys.firstName: fNameCont.text,
      UserKeys.lastName: lNameCont.text,
      UserKeys.contactNumber: mobileCont.text,
      UserKeys.email: emailCont.text,
      UserKeys.countryId: countryId.toString().toInt(),
      UserKeys.stateId: stateId.toString().toInt(),
      UserKeys.cityId: cityId.toString().toInt(),
      CommonKeys.address: addressCont.text,
      UserKeys.profileImage: appStore.userProfileImage,
      'updatedAt': Timestamp.now(),
    };

    MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
    multiPartRequest.fields[UserKeys.firstName] = fNameCont.text;
    multiPartRequest.fields[UserKeys.lastName] = lNameCont.text;
    multiPartRequest.fields[UserKeys.userName] = userNameCont.text;
    multiPartRequest.fields[UserKeys.userType] = UserTypeProvider;
    multiPartRequest.fields[UserKeys.contactNumber] = mobileCont.text;
    multiPartRequest.fields[UserKeys.email] = emailCont.text;
    multiPartRequest.fields[UserKeys.countryId] = countryId.toString();
    multiPartRequest.fields[UserKeys.stateId] = stateId.toString();
    multiPartRequest.fields[UserKeys.cityId] = cityId.toString();
    multiPartRequest.fields[CommonKeys.address] = addressCont.text;
    if (imageFile != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(UserKeys.profileImage, imageFile!.path));
    }
    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);

    userService.updateUserInfo(req, getStringAsync(UID), profileImage: imageFile != null ? File(imageFile!.path) : null).then((value) {
      sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          appStore.setLoading(false);
          if (data != null) {
            if ((data as String).isJson()) {
              ProfileUpdateResponse res = ProfileUpdateResponse.fromJson(jsonDecode(data));
              saveUserData(res.data!);
              finish(context);
              toast(res.message, print: true);
              finish(context);
            } else {
              cachedImage('', fit: BoxFit.cover);
            }
          }
        },
        onError: (error) {
          toast(error.toString(), print: true);
          appStore.setLoading(false);
        },
      ).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    });
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _showSelectionDialog(context);
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _showSelectionDialog(context);
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showConfirmDialogCustom(
      context,
      title: context.translate.confirmationRequestTxt,
      positiveText: context.translate.lblOk,
      negativeText: context.translate.lblNo,
      onAccept: (BuildContext context) async {
        imageFile = File(pickedFile!.path);
        setState(() {});
      },
      onCancel: (BuildContext context) {
        imageFile = null;
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: context.translate.lblGallery,
              leading: Icon(Icons.image, color: context.iconColor),
              onTap: () {
                _getFromGallery();
                finish(context);
              },
            ),
            SettingItemWidget(
              title: context.translate.camera,
              leading: Icon(Icons.camera, color: context.iconColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.translate.editProfile,
        textColor: white,
        color: context.primaryColor,
       /* actions: [
          Tooltip(
            message: "Verified Provider",
            child: IconButton(
              onPressed: () {
                VerifyProviderScreen().launch(context);
              },
              icon: Icon(LineIcons.certificate),
            ),
          )
        ],*/
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      imageFile != null
                          ? Image.file(imageFile!, width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(45)
                          : Observer(
                              builder: (_) => cachedImage(appStore.userProfileImage, height: 100, width: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(64),
                            ),
                      Positioned(
                        bottom: 4,
                        right: 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            backgroundColor: primaryColor,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Icon(AntDesign.camera, color: Colors.white, size: 16).paddingAll(4.0),
                        ).onTap(() async {
                          _showBottomSheet(context);
                        }),
                      )
                    ],
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: fNameCont,
                    focus: fNameFocus,
                    nextFocus: lNameFocus,
                    errorThisFieldRequired: context.translate.hintRequired,
                    decoration: inputDecoration(context, hint: context.translate.hintFirstNameTxt),
                    suffix: Icon(AntDesign.user, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: lNameCont,
                    focus: lNameFocus,
                    nextFocus: userNameFocus,
                    errorThisFieldRequired: context.translate.hintRequired,
                    decoration: inputDecoration(context, hint: context.translate.hintLastNameTxt),
                    suffix: Icon(AntDesign.user, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: userNameCont,
                    focus: userNameFocus,
                    nextFocus: emailFocus,
                    errorThisFieldRequired: context.translate.hintRequired,
                    decoration: inputDecoration(context, hint: context.translate.hintUserNameTxt),
                    suffix: Icon(AntDesign.user, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.EMAIL,
                    controller: emailCont,
                    focus: emailFocus,
                    nextFocus: mobileFocus,
                    errorThisFieldRequired: context.translate.hintRequired,
                    decoration: inputDecoration(context, hint: context.translate.hintEmailTxt),
                    suffix: Icon(Fontisto.email, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.PHONE,
                    controller: mobileCont,
                    focus: mobileFocus,
                    errorThisFieldRequired: context.translate.hintRequired,
                    decoration: inputDecoration(context, hint: context.translate.hintContactNumberTxt),
                    suffix: Icon(Ionicons.call_outline, color: context.iconColor),
                  ),
                  16.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: viewLineColor, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonFormField<CountryListResponse>(
                          decoration: InputDecoration.collapsed(hintText: null),
                          hint: Text(context.translate.selectCountry, style: primaryTextStyle()),
                          isExpanded: true,
                          value: selectedCountry,
                          dropdownColor: context.cardColor,
                          items: countryList.map((CountryListResponse e) {
                            return DropdownMenuItem<CountryListResponse>(
                              value: e,
                              child: Text(
                                e.name!,
                                style: primaryTextStyle(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (CountryListResponse? value) async {
                            countryId = value!.id!;
                            selectedCountry = value;
                            selectedState = null;
                            selectedCity = null;
                            getStates(value.id!);

                            setState(() {});
                          },
                        ),
                      ).expand(),
                      8.width.visible(stateList.isNotEmpty),
                      if (stateList.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: viewLineColor, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<StateListResponse>(
                            decoration: InputDecoration.collapsed(hintText: null),
                            hint: Text(context.translate.selectState, style: primaryTextStyle()),
                            isExpanded: true,
                            dropdownColor: context.cardColor,
                            value: selectedState,
                            items: stateList.map((StateListResponse e) {
                              return DropdownMenuItem<StateListResponse>(
                                value: e,
                                child: Text(
                                  e.name!,
                                  style: primaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (StateListResponse? value) async {
                              selectedCity = null;
                              selectedState = value;
                              stateId = value!.id!;
                              await getCity(value.id!);
                              setState(() {});
                            },
                          ),
                        ).expand(),
                    ],
                  ),
                  16.height,
                  if (cityList.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: viewLineColor, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonFormField<CityListResponse>(
                        decoration: InputDecoration.collapsed(hintText: null),
                        hint: Text(context.translate.selectCity, style: primaryTextStyle()),
                        isExpanded: true,
                        value: selectedCity,
                        dropdownColor: context.cardColor,
                        items: cityList.map((CityListResponse e) {
                          return DropdownMenuItem<CityListResponse>(
                            value: e,
                            child: Text(
                              e.name!,
                              style: primaryTextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (CityListResponse? value) async {
                          selectedCity = value;
                          cityId = value!.id!;
                          setState(() {});
                        },
                      ),
                    ),
                  16.height,
                  AppTextField(
                    controller: addressCont,
                    textFieldType: TextFieldType.ADDRESS,
                    maxLines: 5,
                    minLines: 3,
                    errorThisFieldRequired: context.translate.hintRequired,
                    decoration: inputDecoration(context, hint: context.translate.hintAddress),
                    onFieldSubmitted: (s) {
                      if (getStringAsync(USER_EMAIL) != demoUser) {
                        update();
                      } else {
                        toast(context.translate.lblUnAuthorized);
                        finish(context);
                      }
                    },
                  ),
                  16.height,
                  AppButton(
                    text: context.translate.saveChanges,
                    height: 40,
                    color: primaryColor,
                    textStyle: primaryTextStyle(color: white),
                    width: context.width() - context.navigationBarHeight,
                    onTap: () {
                      if (getStringAsync(USER_EMAIL) != demoUser) {
                        update();
                      } else {
                        toast(context.translate.lblUnAuthorized);
                        finish(context);
                      }
                    },
                  ),
                  16.height,
                  AppButton(
                    text: context.translate.btnVerifyId,
                    height: 40,
                    color: Colors.green,
                    textStyle: primaryTextStyle(color: white),
                    width: context.width() - context.navigationBarHeight,
                    onTap: () {
                      VerifyProviderScreen().launch(context);
                    },
                  ),
                  24.height,
                ],
              ),
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
