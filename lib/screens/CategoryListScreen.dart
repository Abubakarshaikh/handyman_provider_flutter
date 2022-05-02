import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/AppWidgets.dart';
import 'package:handyman_provider_flutter/models/CaregoryResponse.dart';
import 'package:handyman_provider_flutter/networks/RestApis.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';
import 'ServiceListScreen.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  CategoryListScreenState createState() => CategoryListScreenState();
}

class CategoryListScreenState extends State<CategoryListScreen> {
  List<CategoryData> categoryList = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);
    getCategory();
  }

  Future<void> getCategory() async {
    appStore.setLoading(true);
    await getCategoryList().then((value) {
      categoryList.addAll(value.data!);
      setState(() {});
      appStore.setLoading(false);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context.translate.lblCategory, textColor: white, color: context.primaryColor),
      body: Stack(
        children: [
          GridView.count(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(16),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: List.generate(categoryList.length, (index) {
              return Container(
                decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : secondaryPrimaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(categoryList[index].categoryImage != '' ? categoryList[index].categoryImage.validate() : '', height: 55, width: 55, color: primaryColor, fit: BoxFit.cover).paddingAll(4.0),
                    8.height,
                    Text(categoryList[index].name.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ).paddingOnly(left: 8, right: 8),
              ).onTap(() {
                ServiceListScreen(categoryId: categoryList[index].id!, categoryName: categoryList[index].name!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              }, borderRadius: BorderRadius.circular(defaultRadius.toDouble())).cornerRadiusWithClipRRect(8);
            }),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
