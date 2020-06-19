const isDev = true;

class AdInfos {
  final String appId; //Testing  ;
  final String allItemId; //Testing ;
  final String intersteialAd;
  final String rewarded;
  final String newBanner;
  final String nativeAd;
  final String nativeAdAdvance;
  //Testing ;
  const AdInfos(
      {this.appId,
      this.allItemId,
      this.rewarded,
      this.newBanner,
      this.nativeAd,
      this.nativeAdAdvance,
      this.intersteialAd});
}

const TestAds = AdInfos(
    appId: "ca-app-pub-3940256099942544~3347511713",
    allItemId: "ca-app-pub-3940256099942544/6300978111",
    intersteialAd: "ca-app-pub-3940256099942544/1033173712",
    rewarded: "ca-app-pub-3940256099942544/5224354917",
    newBanner: "ca-app-pub-3940256099942544/6300978111",
    nativeAd: "ca-app-pub-3940256099942544/2247696110",
    nativeAdAdvance: "ca-app-pub-3940256099942544/1044960115"
    // emotesId: "ca-app-pub-3940256099942544/6300978111",
    // detailShopUpcomingId: "ca-app-pub-3940256099942544/6300978111"
    );

const SamehAds = AdInfos(
    appId: "ca-app-pub-3641865910737281~7724263342",
    allItemId:
        "ca-app-pub-3641865910737281/7948861726", //"ca-app-pub-3641865910737281/6000026241",
    intersteialAd: "ca-app-pub-3641865910737281/6331198736",
    rewarded: "ca-app-pub-3641865910737281/5009370015",
    newBanner: "ca-app-pub-3641865910737281/9836658462"

    // emotesId: "ca-app-pub-3641865910737281/7948861726",
    // detailShopUpcomingId: "ca-app-pub-3641865910737281/9836658462"
    );

AdInfos get theAdsInfo {
  if (isDev) return TestAds;
  return SamehAds;
}
