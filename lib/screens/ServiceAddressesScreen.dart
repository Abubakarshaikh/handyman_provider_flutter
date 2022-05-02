import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/components/ServiceAddressesComponent.dart';
import 'package:handyman_provider_flutter/models/ServiceAddressesResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';

class ServiceAddressesScreen extends StatefulWidget {
  final bool? isUpdate;
  final String? updatedAddress;

  ServiceAddressesScreen(this.isUpdate, {this.updatedAddress});

  @override
  ServiceAddressesScreenState createState() => ServiceAddressesScreenState();
}

class ServiceAddressesScreenState extends State<ServiceAddressesScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController addressNameCount = TextEditingController();

  ScrollController scrollController = ScrollController();

  List<Data> serviceAddressList = [];

  double? destinationLatitude;
  double? destinationLongitude;

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
      scrollController.addListener(() {
        scrollHandler();
      });
    });
  }

  Future<void> init() async {
    getServicesAddressList();
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      getServicesAddressList();
    }
  }

  Future<void> getServicesAddressList() async {
    getAddresses(providerId: appStore.userId).then((value) {
      totalItems = value.pagination!.totalItems.validate();
      if (!mounted) return;
      serviceAddressList.clear();
      if (totalItems != 0) {
        serviceAddressList.addAll(value.data!);
        print(value);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      if (!mounted) return;
      isLastPage = true;
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  Future<void> addAddress(String status, String? address, String? lat, String? long, int updateType) async {
    appStore.setLoading(true);
    if (formKey.currentState!.validate()) {
      hideKeyboard(context);
      Map request = {
        AddAddressKey.id: '',
        AddAddressKey.providerId: appStore.userId,
        AddAddressKey.latitude: destinationLatitude,
        AddAddressKey.longitude: destinationLongitude,
        AddAddressKey.status: '1',
        AddAddressKey.address: address,
      };
      await addAddresses(request).then((value) {
        appStore.setLoading(true);
        finish(context);
        // addressNameCount.text = '';
        serviceAddressList.clear();
        currentPage = 1;
        getServicesAddressList();
        setState(() {});
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }
  }

  void addAddressDialog() {
    TextEditingController addressCount = TextEditingController();
    showInDialog(context, title: Text(context.translate.lblAddServiceAddress, style: boldTextStyle(), textAlign: TextAlign.justify), barrierColor: Colors.black45, builder: (context) {
      return SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                textFieldType: TextFieldType.ADDRESS,
                controller: addressCount,
                // focus: serviceNameFocus,
                maxLines: 5,
                minLines: 3,
                decoration: inputDecoration(context, hint: context.translate.hintAddress),
              ),
              16.height,
              AppButton(
                text: context.translate.hintAdd,
                height: 40,
                color: primaryColor,
                textStyle: primaryTextStyle(color: white),
                width: context.width() - context.navigationBarHeight,
                onTap: () async {
                  appStore.setLoading(true);
                  try {
                    List<Location> destinationPlacemark = await locationFromAddress(addressCount.text);
                    destinationLatitude = destinationPlacemark[0].latitude;
                    destinationLongitude = destinationPlacemark[0].longitude;

                    addAddress('1', addressCount.text, destinationLatitude.toString(), destinationLongitude.toString(), 1);
                  } catch (e) {
                    throw errorSomethingWentWrong;
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.translate.lblServiceAddress,
        textColor: white,
        color: context.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                addAddressDialog();
              },
              icon: Icon(Icons.add, size: 28, color: white),
              tooltip: context.translate.lblAddServiceAddress),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          serviceAddressList.clear();
          currentPage = 1;
          getServicesAddressList();
          await 2.seconds.delay;
        },
        child: Observer(
          builder: (_) => Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: serviceAddressList.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemBuilder: (_, i) {
                  Data data = serviceAddressList[i];
                  return ServiceAddressesComponent(
                    data,
                    onUpdate: () async {
                      serviceAddressList.removeAt(i);
                      setState(() {});
                    },
                  );
                },
              ),
              noDataFound().center().visible(serviceAddressList.isEmpty && !appStore.isLoading),
              LoaderWidget().center().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
