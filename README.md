# AdsYield Mediation Adapter for iOS

AdsYield Mediation Adapter, Google AdMob ve Google Ad Manager mediation ile AdsYield demand'ini iOS uygulamanıza entegre etmenizi sağlar.

## Kurulum

### CocoaPods ile

Podfile dosyanıza ekleyin:

```ruby
pod 'AdsYieldAdapter', '~> 1.0'
```

Ardından çalıştırın:

```bash
pod install
```

## Desteklenen Formatlar

- Banner (320x50, 300x250, Adaptive)
- Interstitial
- Rewarded
- Rewarded Interstitial
- Native

## Gereksinimler

- iOS 13.0+
- Xcode 15.0+
- Swift 5
- Google Mobile Ads SDK 12.5+

## AdMob Custom Event Ayarları

- **Class Name:** `AdsYieldAdapter.AdsYieldCustomEvent`
- **Parameter:** AdsYield tarafından sağlanan Ad Unit ID

## Dokümantasyon

Detaylı entegrasyon rehberi için [docs/ENTEGRASYON_REHBERI.md](docs/ENTEGRASYON_REHBERI.md) dosyasına bakın.

## Lisans

Apache License 2.0
