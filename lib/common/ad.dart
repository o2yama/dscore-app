import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';

class Ad extends StatefulWidget {
  const Ad({Key? key}) : super(key: key);

  @override
  _AdState createState() => _AdState();
}

class _AdState extends State<Ad> {
  BannerAd? banner;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(child: SizedBox()),
        banner == null
            ? Container()
            : SizedBox(
                height: 50,
                child: AdWidget(ad: banner!),
              ),
      ],
    );
  }
}
