import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/components/HandymanUserComponent.dart';
import 'package:handyman_provider_flutter/components/RegisterUserFormComponent.dart';
import 'package:handyman_provider_flutter/models/UserListResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';
import '../main.dart';

class HandymanListScreen extends StatefulWidget {
  @override
  HandymanListScreenState createState() => HandymanListScreenState();
}

class HandymanListScreenState extends State<HandymanListScreen> {
  ScrollController scrollController = ScrollController();
  List<UserListData> userData = [];
  bool afterInit = false;

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    scrollController.addListener(() {
      scrollHandler();
    });
    getHandymanList();
  }

  scrollHandler() {
    if (currentPage <= totalPage) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        currentPage++;
        appStore.setLoading(true);
        getHandymanList();
      }
    }
  }

  Future<void> getHandymanList() async {
    appStore.setLoading(true);
    await getHandyman(page: currentPage, isPagination: true, providerId: appStore.userId!.toInt()).then((value) {
      totalItems = value.pagination!.totalItems.validate();
      if (!mounted) return;
      if (currentPage == 1) {
        userData.clear();
      }
      if (totalItems != 0) {
        userData.addAll(value.data!);
        print(value);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      afterInit = true;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      if (!mounted) return;
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          currentPage = 1;
          getHandymanList();
          await 2.seconds.delay;
        },
        child: Scaffold(
          appBar: appBarWidget(
            context.translate.lblAllHandyman,
            textColor: white,
            color: context.primaryColor,
            actions: [
              IconButton(
                  onPressed: () async {
                    bool? res = await RegisterUserFormComponent(user_type: UserTypeHandyman).launch(context);
                    if (res ?? true) {
                      userData.clear();
                      currentPage = 1;
                      appStore.setLoading(true);
                      getHandymanList();
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.add, size: 28, color: white),
                  tooltip: context.translate.lblAddHandyman),
            ],
          ),
          body: Observer(
            builder: (_) => Stack(
              children: [
                ListView.builder(
                    padding: EdgeInsets.all(12),
                    controller: scrollController,
                    itemCount: userData.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return HandymanUserComponent(
                        userData[index],
                        onUpdate: () {
                          userData.removeAt(index);
                          setState(() {});
                        },
                      );
                    }).visible(userData.isNotEmpty && afterInit),
                noDataFound().center().visible(userData.isEmpty && afterInit),
                LoaderWidget().center().visible(appStore.isLoading && !afterInit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
