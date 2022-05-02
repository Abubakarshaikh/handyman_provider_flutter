import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/BookingListComponent.dart';
import 'package:handyman_provider_flutter/models/BookingStatusResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Common.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';

class BookingFragment extends StatefulWidget {
  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> with SingleTickerProviderStateMixin {
  TabController? tabController;

  List<Widget> tabs = [];
  List<BookingStatusResponse> statusType = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;
  int selectedTabIndex = 0;

  String status = '';

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });

    LiveStream().on(streamTab, (v) {
      int index = v as int;
      if (index.validate() != -1 && tabs.length > index) {
        tabController?.animateTo(index);
        selectedTabIndex = index;
      }
    });
  }

  Future<void> init() async {
    await bookingStatus().then((value) {
      appStore.isLoading = false;
      statusType.addAll(value);
      statusType.forEach((element) {
        tabs.add(
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              parseHtmlString(element.label.toString().validate()),
              style: secondaryTextStyle(color: Colors.white, size: 16),
            ),
          ),
        );
      });

      tabController = TabController(length: tabs.length, vsync: this);

      tabController!.addListener(() {
        selectedTabIndex = tabController!.index;
      });

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: selectedTabIndex,
      child: Scaffold(
        appBar: appBarWidget(
          context.translate.lblBooking,
          textColor: white,
          showBack: false,
          elevation: 3.0,
          color: context.primaryColor,
          bottom: tabs.isNotEmpty
              ? TabBar(
                  controller: tabController,
                  labelPadding: EdgeInsets.only(left: 0, right: 0),
                  indicatorWeight: 2.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: primaryColor,
                  isScrollable: true,
                  tabs: tabs,
                  onTap: (i) async {
                    selectedTabIndex = i;
                    appStore.setLoading(true);
                  },
                )
              : null,
        ),
        body: Container(
          color: context.cardColor,
          child: Stack(
            children: [
              TabBarView(
                controller: tabController,
                children: tabs.map((e) {
                  selectedTabIndex = tabs.indexOf(e);
                  return BookingListComponent(status: statusType[selectedTabIndex].value);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
