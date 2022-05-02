import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/Constant.dart';
import 'package:handyman_provider_flutter/utils/Images.dart';
import 'package:nb_utils/nb_utils.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return Image.asset('images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center);
}

//price
class PriceWidget extends StatefulWidget {
  final num? price;
  final double? size;
  final Color? color;
  final bool isLineThroughEnabled;

  PriceWidget({this.price, this.size = 16.0, this.color, this.isLineThroughEnabled = false});

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  String currency = '₹';
  Color? primaryColor;

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    currency = getStringAsync(CURRENCY_COUNTRY_SYMBOL);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLineThroughEnabled) {
      return Text('$currency${widget.price.toString()}', style: boldTextStyle(size: widget.size!.toInt(), color: widget.color != null ? widget.color : primaryColor));
    } else {
      return widget.price.toString().isNotEmpty
          ? Text('$currency${widget.price.toString()}', style: TextStyle(fontSize: widget.size, color: widget.color ?? textPrimaryColor, decoration: TextDecoration.lineThrough))
          : Text('');
    }
  }
}

//ads
String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return bannerAdIdForIos;
  } else if (Platform.isAndroid) {
    return bannerAdIdForAndroid;
  }
  return '';
}

Future<void> bannerAds(BuildContext context) async {
  final AnchoredAdaptiveBannerAdSize? size = await AdSize.getAnchoredAdaptiveBannerAdSize(
    Orientation.portrait,
    MediaQuery.of(context).size.width.truncate(),
  );

  if (size == null) {
    return;
  }

  final BannerAd banner = BannerAd(
    size: size,
    request: AdRequest(),
    adUnitId: getBannerAdUnitId()!,
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        myBanner = ad as BannerAd?;
        myBanner!.load();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        bannerReady = true;
        bannerAds(context);
      },
      onAdOpened: (Ad ad) {
      },
      onAdClosed: (Ad ad) {
        ad.dispose();
        bannerAds(context);
      },
    ),
  );
  return banner.load();
}

void createInterstitialAd() {
  int numInterstitialLoadAttempts = 0;
  InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialReady = true;
          interstitialAd = ad;
          numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ));
}

void showInterstitialAd(BuildContext context) {
  if (interstitialAd == null) {
    finish(context);
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      createInterstitialAd();
    },
  );
  interstitialAd!.show();
  interstitialAd = null;
}

class LoaderWidget extends StatefulWidget {
  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with TickerProviderStateMixin {
  late AnimationController controller;
  late final Animation<double> _animation = CurvedAnimation(
    parent: controller,
    curve: Curves.linearToEaseOut,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: ScaleTransition(
        scale: _animation,
        child: cachedImage(splashLogo, height: 60, width: 60, fit: BoxFit.cover, alignment: Alignment.topRight),
      ).center(),
    );
  }
}
