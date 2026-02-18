# AdsYield iOS Mediation Adapter - Entegrasyon Rehberi

## 1. Gereksinimler

- iOS 13.0+
- Xcode 15.0+
- Swift 5
- Google Mobile Ads SDK 12.5+
- AdMob veya Google Ad Manager hesabı

## 2. CocoaPods Kurulumu

Podfile dosyanıza ekleyin:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'Google-Mobile-Ads-SDK'
  pod 'AdsYieldAdapter', '~> 1.0'
end
```

Ardından:

```bash
pod install
```

> **Versiyon Uyumluluk Notu:** Projenizde zaten Google Mobile Ads SDK dependency'si varsa, adapter'ın kullandığı versiyon (12.5+) ile uyumlu olduğundan emin olun.

## 3. Info.plist

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXX~YYYYY</string>
```

**Not:** APPLICATION_ID, AdsYield tarafından sağlanacaktır.

## 4. SDK Başlatma

```swift
import GoogleMobileAds

func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    MobileAds.shared.start(completionHandler: nil)
    return true
}
```

## 5. AdMob'da Custom Event Oluşturma

1. AdMob hesabınıza giriş yapın: https://admob.google.com
2. Sol menüden **Mediation > Waterfall sources** seçin
3. **"Set up ad source"** butonuna tıklayın > **"Add custom event"** seçin
4. Mapping ekleyin:
   - **Mapping Name:** AdsYield
   - **Class Name:** `AdsYieldAdapter.AdsYieldCustomEvent`
   - **Parameter:** AdsYield tarafından sağlanan Ad Unit ID (örn: `ca-app-pub-XXXXX/YYYYYY`)
5. Bu custom event'i mediation grubunuza ekleyin ve eCPM değerini belirleyin

## 6. GAM (Google Ad Manager) İçin

Aynı adımlar GAM'da da geçerlidir:

- **Yield Groups > Add yield partner > Custom event** yolunu izleyin
- Class name ve parameter aynıdır

## 7. Desteklenen Reklam Formatları

| Format | Açıklama |
|--------|----------|
| Banner | 320x50, 300x250, Adaptive Banner |
| Interstitial | Tam ekran geçiş reklamı |
| Rewarded | Ödüllü video reklam |
| Rewarded Interstitial | Ödüllü geçiş reklamı |
| Native | Uygulama içi doğal reklam |

## 8. Test Etme

- Google'ın test ad unit ID'lerini kullanarak test edin
- Ad Inspector ile adapter'ın doğru yüklendiğini doğrulayın
- Console'da `AdsYieldAdapter` tag'ini filtreleyin

## 9. Sorun Giderme

| Hata | Çözüm |
|------|-------|
| "No fill" | MCM ad unit'in aktif ve demand olduğundan emin olun |
| "Adapter not found" | Pod'un doğru eklendiğinden ve class name'in doğru yazıldığından emin olun |
| "Ad failed to load" | Ad unit ID'nin doğru olduğundan emin olun |
| "Missing ad unit ID" | AdMob/GAM UI'da custom event parameter'ına ad unit ID yazıldığından emin olun |

---

# AdsYield iOS Mediation Adapter - Integration Guide (English)

## 1. Requirements

- iOS 13.0+
- Xcode 15.0+
- Swift 5
- Google Mobile Ads SDK 12.5+
- AdMob or Google Ad Manager account

## 2. CocoaPods Setup

Add to your Podfile:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'Google-Mobile-Ads-SDK'
  pod 'AdsYieldAdapter', '~> 1.0'
end
```

Then run:

```bash
pod install
```

> **Version Compatibility Note:** If your project already includes the Google Mobile Ads SDK dependency, make sure it is compatible with the version used by the adapter (12.5+).

## 3. Info.plist

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXX~YYYYY</string>
```

**Note:** The APPLICATION_ID will be provided by AdsYield.

## 4. SDK Initialization

```swift
import GoogleMobileAds

func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    MobileAds.shared.start(completionHandler: nil)
    return true
}
```

## 5. Creating a Custom Event in AdMob

1. Sign in to your AdMob account: https://admob.google.com
2. From the left menu, select **Mediation > Waterfall sources**
3. Click **"Set up ad source"** > Select **"Add custom event"**
4. Add mapping:
   - **Mapping Name:** AdsYield
   - **Class Name:** `AdsYieldAdapter.AdsYieldCustomEvent`
   - **Parameter:** Ad Unit ID provided by AdsYield (e.g., `ca-app-pub-XXXXX/YYYYYY`)
5. Add this custom event to your mediation group and set the eCPM value

## 6. For GAM (Google Ad Manager)

Same steps apply for GAM:

- Follow **Yield Groups > Add yield partner > Custom event** path
- Class name and parameter are the same

## 7. Supported Ad Formats

| Format | Description |
|--------|-------------|
| Banner | 320x50, 300x250, Adaptive Banner |
| Interstitial | Full-screen interstitial ad |
| Rewarded | Rewarded video ad |
| Rewarded Interstitial | Rewarded interstitial ad |
| Native | In-app native ad |

## 8. Testing

- Test using Google's test ad unit IDs
- Verify the adapter loads correctly with Ad Inspector
- Filter `AdsYieldAdapter` tag in Console

## 9. Troubleshooting

| Error | Solution |
|-------|----------|
| "No fill" | Make sure the MCM ad unit is active and has demand |
| "Adapter not found" | Make sure the pod is correctly added and the class name is spelled correctly |
| "Ad failed to load" | Make sure the ad unit ID is correct |
| "Missing ad unit ID" | Make sure you've entered the ad unit ID in the custom event parameter in AdMob/GAM UI |
