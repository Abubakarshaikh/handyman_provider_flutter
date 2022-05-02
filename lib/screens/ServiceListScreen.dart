import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/components/ServiceComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/ServiceModel.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/screens/AddServiceScreen.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

class ServiceListScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  ServiceListScreen({this.categoryId, this.categoryName = ''});

  @override
  ServiceListScreenState createState() => ServiceListScreenState();
}

class ServiceListScreenState extends State<ServiceListScreen> {
  ScrollController scrollController = ScrollController();

  List<Service> serviceList = [];
  int? categoryWiseId;

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  bool afterInit = false;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  Future<void> init() async {
    if (widget.categoryId != null) {
      getServices(categoryId: widget.categoryId);
    } else {
      getServices();
    }

    scrollController.addListener(() {
      if (currentPage <= totalPage) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          appStore.setLoading(true);
          currentPage++;
          if (widget.categoryId != null)
            getServices(categoryId: widget.categoryId);
          else
            getServices();
        }
      } else {
        appStore.setLoading(false);
      }
    });
  }

  Future<void> getServices({int? categoryId}) async {
    getServiceList(currentPage, appStore.userId.validate(), categoryId: categoryId, isCategoryWise: categoryId != null ? true : false).then((value) {
      totalItems = value.pagination!.total_items!;
      if (totalItems != 0) {
        if (currentPage == 1) {
          serviceList.clear();
        }
        serviceList.addAll(value.data!);
        print(value);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      afterInit = true;
      if (widget.categoryId != null) {
        categoryWiseId = widget.categoryId;
      }

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
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
        widget.categoryName!.isEmpty ? context.translate.lblAllService : widget.categoryName.validate(),
        textColor: white,
        color: context.primaryColor,
        backWidget: Icon(Icons.arrow_back, size: 28, color: white).onTap(() {
          finish(context, true);
        }),
        actions: [
          IconButton(
              onPressed: () async {
                bool? res;

                if (widget.categoryId != null) {
                  res = await AddServiceScreen(categoryId: widget.categoryId).launch(context);
                } else {
                  res = await AddServiceScreen().launch(context);
                }

                if (res ?? true) {
                  appStore.setLoading(true);
                  serviceList.clear();
                  currentPage = 1;
                  if (categoryWiseId != null) {
                    getServices(categoryId: categoryWiseId);
                  } else {
                    getServices();
                  }
                }
              },
              icon: Icon(Icons.add, size: 28, color: white),
              tooltip: context.translate.lblAddService),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          serviceList.clear();
          currentPage = 1;
          getServices();
          await 2.seconds.delay;
        },
        child: Observer(
          builder: (_) => Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: serviceList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 40),
                itemBuilder: (_, i) {
                  Service data = serviceList[i];
                  return ServiceComponent(
                    serviceData: data,
                    onUpdate: () async {
                      serviceList.removeAt(i);
                      appStore.setLoading(true);
                      serviceList.clear();
                      currentPage = 1;
                      if (categoryWiseId != null) {
                        getServices(categoryId: categoryWiseId);
                      } else {
                        getServices();
                      }
                      setState(() {});
                    },
                  );
                },
              ).visible(afterInit && !appStore.isLoading),
              noDataFound().center().visible(serviceList.isEmpty && afterInit && !appStore.isLoading),
              LoaderWidget().center().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
