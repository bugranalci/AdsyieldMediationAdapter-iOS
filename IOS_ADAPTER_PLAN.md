# AdsYield iOS Mediation Adapter - Plan

## v12 API İsimleri (GAD prefix kaldırıldı)

| v11 | v12 (Swift) |
|-----|-------------|
| GADMediationAdapter | MediationAdapter |
| GADMediationBannerAd | MediationBannerAd |
| GADMediationInterstitialAd | MediationInterstitialAd |
| GADMediationRewardedAd | MediationRewardedAd |
| GADMediationNativeAd | MediationNativeAd |
| GADBannerView | BannerView |
| GADInterstitialAd | InterstitialAd |
| GADRewardedAd | RewardedAd |
| GADRewardedInterstitialAd | RewardedInterstitialAd |
| GADNativeAd | NativeAd |
| GADFullScreenContentDelegate | FullScreenContentDelegate |
| GADBannerViewDelegate | BannerViewDelegate |
| GADVersionNumber | VersionNumber |
| GADRequest | Request |
| GADAdLoader | AdLoader |
| GADNativeAdImage | NativeAdImage |

## Ad Unit ID Okuma
```swift
adConfiguration.credentials.settings["parameter"] as? String
```

## Completion Handler Pattern
```swift
// Başarı: delegate = completionHandler(self, nil)
// Hata: completionHandler(nil, error)
```

## Dosyalar
1. AdsYieldCustomEvent.swift - Ana adapter
2. AdsYieldBannerLoader.swift - Banner
3. AdsYieldInterstitialLoader.swift - Interstitial
4. AdsYieldRewardedLoader.swift - Rewarded
5. AdsYieldRewardedInterstitialLoader.swift - Rewarded Interstitial
6. AdsYieldNativeLoader.swift - Native
