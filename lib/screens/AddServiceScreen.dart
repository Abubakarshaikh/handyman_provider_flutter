import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/CaregoryResponse.dart';
import 'package:handyman_provider_flutter/models/ServiceDetailResponse.dart';
import 'package:handyman_provider_flutter/networks/NetworkUtils.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/ServiceListScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import 'package:handyman_provider_flutter/models/ServiceAddressesResponse.dart';
import '../main.dart';

class AddServiceScreen extends StatefulWidget {
  final int? categoryId;
  final ServiceDetail? data;

  AddServiceScreen({this.categoryId, this.data});

  @override
  AddServiceScreenState createState() => AddServiceScreenState();
}

class AddServiceScreenState extends State<AddServiceScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ServiceDetailResponse serviceDetailResponse = ServiceDetailResponse();
  ServiceDetail serviceDetail = ServiceDetail();

  //file picker
  FilePickerResult? filePickerResult;
  List<File> imageFiles = [];

  List<int> selectedAddress = [];
  bool isChecked = false;

  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController discountCont = TextEditingController();
  TextEditingController discriptionCont = TextEditingController();
  TextEditingController durationContHr = TextEditingController(text: '00');
  TextEditingController durationContMin = TextEditingController(text: '00');

  List<String> eAttachments = [];
  List<String> addressList = [];
  bool afterInit = false;

  List<Data> serviceAddressList = [];
  List<Data> selectedServiceAddressList = [];

  FocusNode serviceNameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode discriptionFocus = FocusNode();
  FocusNode durationHrFocus = FocusNode();
  FocusNode durationMinFocus = FocusNode();

  List<CategoryData> categoryList = [];
  List<String> typeList = ['fixed', 'hourly'];
  List<String> statusList = ['InActive', 'Active'];

  CategoryData? selectedCategory;
  String? serviceType = '';
  String? serviceStatus = '';

  bool? isFeature = false;
  int? featured = 0;
  int? seviceId;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
      init();
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);
    serviceType = typeList[0];
    serviceStatus = statusList[0];
    await getCategory();
    await getAdressesList();
    if (widget.data != null) {
      getEditServiceData();
    }
    afterInit = true;
    setState(() {});
  }

  getEditServiceData() {
    serviceDetail = widget.data!;
    seviceId = widget.data!.id;
    serviceNameCont.text = serviceDetail.name.validate();
    priceCont.text = serviceDetail.price.toString();
    discountCont.text = serviceDetail.discount.toString();
    discriptionCont.text = serviceDetail.description.validate();
    durationContHr.text = serviceDetail.duration.validate().splitBefore(':');
    durationContMin.text = serviceDetail.duration.validate().splitAfter(':');
    isFeature = serviceDetail.is_featured.validate() == 1 ? true : false;
    serviceStatus = serviceDetail.status == 1 ? 'Active' : 'InActive';
    serviceType = serviceDetail.type.validate();
    serviceStatus = serviceDetail.status == 0 ? 'InActive' : 'Active';
    serviceDetail.attchments!.map((e) {
      eAttachments.add(e);
    }).toList();

    afterInit = true;
    setState(() {});
  }

  Future<void> getCategory() async {
    await getCategoryList().then((value) {
      categoryList.addAll(value.data!);
      if (widget.data != null) selectedCategory = categoryList.where((element) => element.id == widget.data!.category_id).first;
      if (widget.categoryId != null)
        categoryList.map((e) {
          e.id == widget.categoryId ? selectedCategory = e : null;
        }).toList();
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> getAdressesList() async {
    getAddresses(providerId: appStore.userId).then((value) {
      serviceAddressList.addAll(value.data!);
      print(value);
      if (widget.data != null)
        serviceAddressList.forEach(
          (addressElement) {
            serviceDetail.service_address_mapping!.forEach(
              (element) {
                if (element.provider_address_mapping!.id == addressElement.id) {
                  addressElement.isSelected = true;
                  selectedAddress.add(addressElement.id.validate());
                } else {
                  addressElement.isSelected = false;
                }
              },
            );
          },
        );

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  getMultipleFile() async {
    filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);

    if (filePickerResult != null) {
      setState(() {
        imageFiles = filePickerResult!.paths.map((path) => File(path!)).toList();
        eAttachments = [];
      });
    } else {}
  }

  void _onFeatureChanged(bool? newValue) => setState(() {
        isFeature = newValue;
        if (isFeature == true) {
          featured = 1;
        } else {
          featured = 0;
        }
      });

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addNewService() async {
    hideKeyboard(context);

    MultipartRequest multiPartRequest = await getMultiPartRequest('service-save');

    if (seviceId != null) {
      multiPartRequest.fields[CommonKeys.id] = seviceId.toString();
    }
    multiPartRequest.fields[AddServiceKey.name] = serviceNameCont.text;
    multiPartRequest.fields[AddServiceKey.providerId] = appStore.userId.toString();
    multiPartRequest.fields[AddServiceKey.categoryId] = selectedCategory!.id.toString();
    multiPartRequest.fields[AddServiceKey.type] = serviceType!;
    multiPartRequest.fields[AddServiceKey.price] = priceCont.text.toString();
    multiPartRequest.fields[AddServiceKey.discountPrice] = discountCont.text.toString();
    multiPartRequest.fields[AddServiceKey.description] = discriptionCont.text;
    multiPartRequest.fields[AddServiceKey.isFeatured] = featured.toString();
    multiPartRequest.fields[AddServiceKey.status] = '1';
    if (imageFiles.isNotEmpty) {
      multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFiles.length.toString();
    }
    multiPartRequest.fields[AddServiceKey.duration] = durationContHr.text.toString() + ':' + durationContMin.text.toString();

    for (int i = 0; i < selectedAddress.length; i++) {
      multiPartRequest.fields[AddServiceKey.providerAddressId + '[$i]'] = selectedAddress[i].toString();
    }

    if (imageFiles.isNotEmpty) {
      for (int i = 0; i < imageFiles.length; i++) {
        multiPartRequest.files.add(await MultipartFile.fromPath(AddServiceKey.serviceAttachment + i.toString(), imageFiles[i].path));
      }
    } else {
      cachedImage('', fit: BoxFit.cover);
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(data);
        if (widget.data != null) {
          ServiceListScreen().launch(context, isNewTask: true);
        } else {
          finish(context, true);
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
  }

  void checkValidation() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      if (selectedCategory != null && priceCont.text.isNotEmpty && durationContHr.text.isNotEmpty && durationContMin.text.isNotEmpty && discriptionCont.text.isNotEmpty && selectedAddress.isNotEmpty) {
        if (getStringAsync(USER_EMAIL) != demoUser) {
          addNewService();
        } else {
          toast(context.translate.lblUnAuthorized);
          finish(context);
        }
      } else {
        toast(context.translate.hintEnterProperData);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(widget.data != null ? context.translate.lblEditService : context.translate.hintAddService,
            textColor: white,
            color: context.primaryColor,
            backWidget: Icon(Icons.arrow_back_outlined, color: white).onTap(() {
              finish(context, true);
            })),
        body: Stack(
          alignment: Alignment.topLeft,
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: boxDecorationWithShadow(blurRadius: 0, borderRadius: radius(8), backgroundColor: context.cardColor),
                      child: Column(
                        children: [Icon(Icons.add, size: 28, color: context.iconColor), Text(context.translate.hintChooseImage, style: secondaryTextStyle())],
                      ),
                    ).onTap(() async {
                      getMultipleFile();
                    }),
                    8.height,
                    Text(
                      context.translate.selectImgNote,
                      style: secondaryTextStyle(size: 8, color: Colors.red),
                    ),
                    16.height,
                    HorizontalList(
                        itemCount: imageFiles.length,
                        itemBuilder: (context, i) {
                          return Image.file(imageFiles[i], width: 90, height: 90, fit: BoxFit.cover);
                        }).paddingBottom(16).visible(imageFiles.isNotEmpty),
                    HorizontalList(
                        itemCount: eAttachments.length,
                        itemBuilder: (context, i) {
                          return cachedImage(eAttachments[i], width: 90, height: 90, fit: BoxFit.cover);
                        }).paddingBottom(16).visible(eAttachments.isNotEmpty),
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: serviceNameCont,
                      focus: serviceNameFocus,
                      nextFocus: priceFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintServiceName),
                    ),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: viewLineColor, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonFormField<CategoryData>(
                        decoration: InputDecoration.collapsed(hintText: null),
                        hint: Text(context.translate.hintSelectCategory, style: secondaryTextStyle()),
                        // isExpanded: true,
                        value: selectedCategory,
                        dropdownColor: context.cardColor,
                        items: categoryList.map((data) {
                          return DropdownMenuItem<CategoryData>(
                            value: data,
                            child: Text(
                              data.name.validate(),
                              style: primaryTextStyle(),
                            ),
                          );
                        }).toList(),
                        onChanged: (CategoryData? value) async {
                          selectedCategory = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    16.height,
                    Container(
                      // margin: EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: viewLineColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        iconColor: context.iconColor,
                        title: Text(
                          context.translate.selectAddress,
                          style: secondaryTextStyle(),
                        ),
                        children: <Widget>[
                          new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: serviceAddressList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  title: Text(
                                    serviceAddressList[index].address.validate(),
                                    style: secondaryTextStyle(color: context.iconColor),
                                  ),
                                  autofocus: false,
                                  activeColor: primaryColor,
                                  checkColor: context.cardColor,
                                  value: selectedAddress.contains(serviceAddressList[index].id),
                                  onChanged: (bool? val) {
                                    if (selectedAddress.contains(serviceAddressList[index].id)) {
                                      selectedAddress.remove(serviceAddressList[index].id);
                                    } else {
                                      selectedAddress.add(serviceAddressList[index].id.validate());
                                    }
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration.collapsed(hintText: null),
                            hint: Text(context.translate.hintSelectType, style: secondaryTextStyle()),
                            value: serviceType!.isNotEmpty ? serviceType : null,
                            dropdownColor: context.cardColor,
                            items: typeList.map((String data) {
                              return DropdownMenuItem<String>(
                                value: data,
                                child: Text(data, style: primaryTextStyle()),
                              );
                            }).toList(),
                            onChanged: (String? value) async {
                              serviceType = value.validate();
                              setState(() {});
                            },
                          ),
                        ).expand(),
                        8.width,
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: viewLineColor, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration.collapsed(hintText: null),
                            hint: Text(context.translate.hintSelectStatus, style: secondaryTextStyle()),
                            dropdownColor: context.cardColor,
                            value: serviceStatus!.isNotEmpty ? serviceStatus : null,
                            items: statusList.map((String data) {
                              return DropdownMenuItem<String>(
                                value: data,
                                child: Text(data, style: primaryTextStyle()),
                              );
                            }).toList(),
                            onChanged: (String? value) async {
                              serviceStatus = value.validate();
                              setState(() {});
                            },
                          ),
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        AppTextField(
                          textFieldType: TextFieldType.OTHER,
                          controller: priceCont,
                          focus: priceFocus,
                          nextFocus: discountFocus,
                          errorThisFieldRequired: context.translate.hintRequired,
                          decoration: inputDecoration(context, hint: context.translate.hintPrice),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ).paddingRight(8).expand(),
                        AppTextField(
                          textFieldType: TextFieldType.OTHER,
                          controller: discountCont,
                          focus: discountFocus,
                          nextFocus: durationHrFocus,
                          errorThisFieldRequired: context.translate.hintRequired,
                          decoration: inputDecoration(context, hint: context.translate.hintdiscount),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            // signed: true,
                          ),
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          controller: durationContHr,
                          focus: durationHrFocus,
                          nextFocus: durationMinFocus,
                          errorThisFieldRequired: context.translate.hintRequired,
                          decoration: inputDecoration(context, hint: context.translate.lblDurationHr),
                          keyboardType: TextInputType.number,
                        ).paddingRight(8).expand(),
                        AppTextField(
                          textFieldType: TextFieldType.PHONE,
                          controller: durationContMin,
                          focus: durationMinFocus,
                          nextFocus: discriptionFocus,
                          errorThisFieldRequired: context.translate.hintRequired,
                          decoration: inputDecoration(context, hint: context.translate.lblDurationMin),
                          keyboardType: TextInputType.number,
                        ).expand(),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.ADDRESS,
                      minLines: 5,
                      controller: discriptionCont,
                      focus: discriptionFocus,
                      errorThisFieldRequired: context.translate.hintRequired,
                      decoration: inputDecoration(context, hint: context.translate.hintDescription),
                    ),
                    16.height,
                    Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            4.width,
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: Checkbox(
                                value: isFeature,
                                onChanged: (v) async {
                                  _onFeatureChanged(v);
                                },
                              ),
                            ),
                            8.width,
                            Text(context.translate.hintSetAsfeature, style: secondaryTextStyle())
                          ],
                        ).expand(),
                      ],
                    ),
                    24.height,
                    AppButton(
                      text: context.translate.btnSave,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          checkValidation();
                        }
                      },
                    ),
                    16.height,
                  ],
                ).paddingAll(16),
              ),
            ).visible(!appStore.isLoading && afterInit),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
