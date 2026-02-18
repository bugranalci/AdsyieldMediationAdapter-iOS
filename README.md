# AdsYield Mediation Adapter for iOS

AdsYield Mediation Adapter enables publishers to integrate AdsYield demand into their iOS apps through Google AdMob or Google Ad Manager mediation.

## Installation

### CocoaPods

Add to your Podfile:

```ruby
pod 'AdsYieldAdapter', '~> 1.0'
```

Then run:

```bash
pod install
```

## Supported Formats

- Banner (320x50, 300x250, Adaptive)
- Interstitial
- Rewarded
- Rewarded Interstitial
- Native

## Requirements

- iOS 13.0+
- Xcode 15.0+
- Swift 5
- Google Mobile Ads SDK 12.5+

## AdMob / GAM Custom Event Configuration

| Field | Value |
|-------|-------|
| **Class Name** | `AdsYieldAdapter.AdsYieldCustomEvent` |
| **Parameter** | Ad Unit ID provided by AdsYield |

## Quick Start

**1.** Initialize SDK in `AppDelegate.swift`:

```swift
import GoogleMobileAds

MobileAds.shared.start()
```

**2.** Add to `Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_ADMOB_APP_ID</string>
```

**3.** Configure the custom event in AdMob/GAM console with the class name and parameter above.

That's it. Your existing ad loading code works without any changes.

## Documentation

- [Entegrasyon Rehberi (TR)](docs/ENTEGRASYON_REHBERI.md)
- [Integration Guide (EN)](docs/INTEGRATION_GUIDE.md)

## Sample App

See `AdsYieldAdapterSample/` for a working demo with all 5 ad formats.

```bash
cd AdsYieldAdapterSample
pod install
open AdsYieldAdapterSample.xcworkspace
```

## License

Apache License 2.0
