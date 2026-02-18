# AdsYield iOS Mediation Adapter - Integration Guide

This guide provides step-by-step instructions for integrating the AdsYield iOS Mediation Adapter with Google AdMob or Google Ad Manager (GAM) mediation.

---

## Requirements

| Requirement | Minimum Version |
|-------------|----------------|
| iOS | 13.0+ |
| Xcode | 15.0+ |
| Swift | 5 |
| Google Mobile Ads SDK | 12.5+ |
| CocoaPods | 1.10+ |

You also need an active **AdMob** or **Google Ad Manager** account.

---

## 1. CocoaPods Installation

Add the following lines to your Podfile:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'Google-Mobile-Ads-SDK', '~> 12.5'
  pod 'AdsYieldAdapter', '~> 1.0'
end
```

Then run in terminal:

```bash
pod install
```

> **Note:** After `pod install`, open your project using the `.xcworkspace` file, not `.xcodeproj`.

---

## 2. Info.plist Configuration

Add the following key to your `Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_ADMOB_APP_ID</string>
```

Replace `YOUR_ADMOB_APP_ID` with your app ID from the AdMob console (e.g., `ca-app-pub-XXXXX~YYYYY`).

### SKAdNetwork IDs

You need to add Google's SKAdNetwork ID list to your Info.plist. For the latest list, visit:
https://developers.google.com/admob/ios/ios14#skadnetwork

---

## 3. SDK Initialization

Initialize the Google Mobile Ads SDK in your `AppDelegate.swift`:

```swift
import GoogleMobileAds

func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    MobileAds.shared.start()
    return true
}
```

---

## 4. Creating a Custom Event in AdMob

### Step 1: Add a Waterfall Source

1. Sign in to the [AdMob console](https://admob.google.com)
2. From the left menu, select **Mediation > Waterfall sources**
3. Click **"Set up ad source"**
4. Select **"Add custom event"**

### Step 2: Enter Mapping Details

For each ad format, enter the following:

| Field | Value |
|-------|-------|
| **Mapping Name** | AdsYield |
| **Class Name** | `AdsYieldAdapter.AdsYieldCustomEvent` |
| **Parameter** | Ad Unit ID provided by AdsYield |

> **Important:** The Class Name must be exactly `AdsYieldAdapter.AdsYieldCustomEvent`. `AdsYieldAdapter` is the module name, `AdsYieldCustomEvent` is the class name.

### Step 3: Add to Mediation Group

1. Go to **Mediation > Mediation groups**
2. Select the relevant mediation group (or create a new one)
3. In the **Waterfall** section, add the AdsYield source you created via **"Add custom event"**
4. Set the **eCPM** value

---

## 5. For Google Ad Manager (GAM)

If you're using GAM, the same adapter applies:

1. Go to **Yield Groups** in the GAM console
2. Select **Add yield partner > Custom event**
3. Mapping details are the same as AdMob:
   - **Class Name:** `AdsYieldAdapter.AdsYieldCustomEvent`
   - **Parameter:** AdsYield Ad Unit ID

---

## 6. Supported Ad Formats

| Format | Description | Loader Class |
|--------|-------------|--------------|
| **Banner** | 320x50, 300x250, Adaptive Banner | `AdsYieldBannerLoader` |
| **Interstitial** | Full-screen interstitial ad | `AdsYieldInterstitialLoader` |
| **Rewarded** | Rewarded video ad | `AdsYieldRewardedLoader` |
| **Rewarded Interstitial** | Rewarded interstitial ad | `AdsYieldRewardedInterstitialLoader` |
| **Native** | In-app native ad | `AdsYieldNativeLoader` |

> No changes are needed in your application code. Your standard AdMob/GAM ad loading code works as-is. The adapter is triggered automatically within the mediation chain.

---

## 7. Testing

### Testing with Ad Inspector

Ad Inspector is the easiest way to verify whether the adapter is loaded correctly:

```swift
MobileAds.shared.presentAdInspector(from: viewController) { error in
    if let error = error {
        print("Ad Inspector error: \(error.localizedDescription)")
    }
}
```

You can see the **AdsYieldAdapter** and its loaded ad units in Ad Inspector.

### Testing with Console Logs

Filter for the `AdsYieldAdapter` tag in the Xcode Console. Every adapter operation is logged:

```
[AdsYieldAdapter] Adapter set up complete.
[AdsYieldAdapter] Loading banner ad with ad unit ID: ca-app-pub-XXXXX/YYYYY
[AdsYieldAdapter] Banner ad loaded successfully.
[AdsYieldAdapter] Banner ad impression recorded.
```

---

## 8. Troubleshooting

| Issue | Possible Cause | Solution |
|-------|---------------|----------|
| Adapter not found | Pod not installed or class name incorrect | Run `pod install`, verify class name: `AdsYieldAdapter.AdsYieldCustomEvent` |
| "Missing ad unit ID" | Custom event parameter is empty | Enter the AdsYield ad unit ID in the parameter field in AdMob/GAM UI |
| "No fill" | No demand on the ad unit | Contact the AdsYield team, verify the ad unit is active |
| Ads not loading | SDK not initialized | Ensure `MobileAds.shared.start()` is called |
| No callbacks | Mediation group not configured | Ensure the custom event is added to a mediation group |

### Error Codes

| Code | Description |
|------|-------------|
| 101 | Ad unit ID is missing or empty (check the parameter field) |
| 103 | Attempted to show an ad before it was loaded |

---

## 9. Version Compatibility

| Adapter Version | Google Mobile Ads SDK | Min iOS |
|----------------|-----------------------|---------|
| 1.0.0 | 12.5+ | 13.0 |

---

## Support

For questions or issues:
- GitHub Issues: https://github.com/bugranalci/AdsyieldMediationAdapter-iOS/issues
- Email: info@adsyield.com
