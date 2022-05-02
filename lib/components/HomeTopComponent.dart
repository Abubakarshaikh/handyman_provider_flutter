import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:handyman_provider_flutter/models/DashboardData.dart';
import 'package:handyman_provider_flutter/models/RevenueChartData.dart';
import 'package:handyman_provider_flutter/screens/HandymanListScreen.dart';
import 'package:handyman_provider_flutter/screens/ServiceListScreen.dart';
import 'package:handyman_provider_flutter/utils/Colors.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:handyman_provider_flutter/extensions/ContextExt.dart';

import '../main.dart';

class HomeTopComponent extends StatefulWidget {
  final List<DashboardData>? data;
  final List<RevenueChartData>? chartData;

  HomeTopComponent({this.data, this.chartData});

  @override
  HomeTopComponentState createState() => HomeTopComponentState();
}

class HomeTopComponentState extends State<HomeTopComponent> {
  List<DashboardData>? dashboardData = [];
  TooltipBehavior? tooltipBehavior;
  ZoomPanBehavior? zoomPanBehavior;
  List<RevenueChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    zoomPanBehavior = ZoomPanBehavior(zoomMode: ZoomMode.y);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    dashboardData = widget.data;
    chartData = widget.chartData!;

    tooltipBehavior = TooltipBehavior(enable: true, borderWidth: 1.5, color: context.cardColor, textStyle: secondaryTextStyle(color: context.iconColor));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dashboardData!.length,
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (BuildContext context, int i) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: boxDecorationRoundedWithShadow(
                defaultRadius.toInt(),
                blurRadius: 0,
                backgroundColor: appStore.isDarkMode ? context.cardColor : primaryColor,
                shadowColor: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dashboardData![i].title.validate(), style: secondaryTextStyle(color: white)),
                      Icon(dashboardData![i].icon, size: 18, color: white),
                    ],
                  ),
                  8.height,
                  Text(dashboardData![i].total.validate(), style: boldTextStyle(color: white))
                ],
              ),
            ).onTap(() {
              if (i == 1) {
                ServiceListScreen().launch(context);
              } else if (i == 2) {
                HandymanListScreen().launch(context);
              }
            });
          },
        ),
        Container(
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: SfCartesianChart(
            title: ChartTitle(text: context.translate.lblMonthlyRevenue + ' ( ${getStringAsync(CURRENCY_COUNTRY_CODE)} )', textStyle: secondaryTextStyle(size: 14)),
            primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0), axisLine: AxisLine(width: 0)),
            tooltipBehavior: tooltipBehavior,
            // zoomPanBehavior: zoomPanBehavior,
            series: <ChartSeries>[
              StackedColumnSeries<RevenueChartData, String>(
                name: context.translate.lblRevenue,
                enableTooltip: true,
                color: primaryColor,
                dataSource: chartData,
                yValueMapper: (RevenueChartData sales, _) => sales.revenue,
                xValueMapper: (RevenueChartData sales, _) => sales.month,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
