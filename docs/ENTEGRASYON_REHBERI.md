# AdsYield iOS Mediation Adapter - Entegrasyon Rehberi

Bu rehber, AdsYield iOS Mediation Adapter'ın Google AdMob veya Google Ad Manager (GAM) mediation ile entegrasyonunu adım adım anlatmaktadır.

---

## Gereksinimler

| Gereksinim | Minimum Versiyon |
|------------|-----------------|
| iOS | 13.0+ |
| Xcode | 15.0+ |
| Swift | 5 |
| Google Mobile Ads SDK | 12.5+ |
| CocoaPods | 1.10+ |

Ayrıca aktif bir **AdMob** veya **Google Ad Manager** hesabınız olmalıdır.

---

## 1. CocoaPods Kurulumu

Podfile dosyanıza aşağıdaki satırları ekleyin:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'Google-Mobile-Ads-SDK', '~> 12.5'
  pod 'AdsYieldAdapter', '~> 1.0'
end
```

Ardından terminal'de:

```bash
pod install
```

> **Not:** `pod install` sonrası projenizi `.xcworkspace` dosyası üzerinden açın, `.xcodeproj` değil.

---

## 2. Info.plist Ayarları

`Info.plist` dosyanıza aşağıdaki key'leri ekleyin:

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_ADMOB_APP_ID</string>
```

`YOUR_ADMOB_APP_ID` değerini AdMob konsolundan aldığınız uygulama ID'si ile değiştirin (örn: `ca-app-pub-XXXXX~YYYYY`).

### SKAdNetwork ID'leri

Google'ın SKAdNetwork ID listesini Info.plist'e eklemeniz gerekir. Güncel liste için:
https://developers.google.com/admob/ios/ios14#skadnetwork

---

## 3. SDK Başlatma

`AppDelegate.swift` dosyanızda Google Mobile Ads SDK'yı başlatın:

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

## 4. AdMob'da Custom Event Oluşturma

### Adım 1: Waterfall Source Ekleme

1. [AdMob konsoluna](https://admob.google.com) giriş yapın
2. Sol menüden **Mediation > Waterfall sources** seçin
3. **"Set up ad source"** butonuna tıklayın
4. **"Add custom event"** seçin

### Adım 2: Mapping Bilgilerini Girin

Her reklam formatı için aşağıdaki bilgileri girin:

| Alan | Değer |
|------|-------|
| **Mapping Name** | AdsYield |
| **Class Name** | `AdsYieldAdapter.AdsYieldCustomEvent` |
| **Parameter** | AdsYield tarafından sağlanan Ad Unit ID |

> **Dikkat:** Class Name tam olarak `AdsYieldAdapter.AdsYieldCustomEvent` şeklinde yazılmalıdır. `AdsYieldAdapter` modül adı, `AdsYieldCustomEvent` sınıf adıdır.

### Adım 3: Mediation Group'a Ekleme

1. **Mediation > Mediation groups** bölümüne gidin
2. İlgili mediation group'u seçin (veya yeni oluşturun)
3. **Waterfall** bölümünde **"Add custom event"** ile oluşturduğunuz AdsYield source'u ekleyin
4. **eCPM** değerini belirleyin

---

## 5. Google Ad Manager (GAM) İçin

GAM kullanıyorsanız aynı adapter geçerlidir:

1. GAM konsolunda **Yield Groups** bölümüne gidin
2. **Add yield partner > Custom event** seçin
3. Mapping bilgileri AdMob ile aynıdır:
   - **Class Name:** `AdsYieldAdapter.AdsYieldCustomEvent`
   - **Parameter:** AdsYield Ad Unit ID

---

## 6. Desteklenen Reklam Formatları

| Format | Açıklama | Loader Sınıfı |
|--------|----------|---------------|
| **Banner** | 320x50, 300x250, Adaptive Banner | `AdsYieldBannerLoader` |
| **Interstitial** | Tam ekran geçiş reklamı | `AdsYieldInterstitialLoader` |
| **Rewarded** | Ödüllü video reklam | `AdsYieldRewardedLoader` |
| **Rewarded Interstitial** | Ödüllü geçiş reklamı | `AdsYieldRewardedInterstitialLoader` |
| **Native** | Uygulama içi doğal reklam | `AdsYieldNativeLoader` |

> Uygulama kodunuzda herhangi bir değişiklik yapmanıza gerek yoktur. Standart AdMob/GAM reklam yükleme kodunuz aynen çalışır. Adapter, mediation zincirinde otomatik olarak devreye girer.

---

## 7. Test Etme

### Ad Inspector ile Test

Ad Inspector, adapter'ın doğru yüklenip yüklenmediğini kontrol etmenin en kolay yoludur:

```swift
MobileAds.shared.presentAdInspector(from: viewController) { error in
    if let error = error {
        print("Ad Inspector error: \(error.localizedDescription)")
    }
}
```

Ad Inspector'da **AdsYieldAdapter** adapter'ını ve yüklenen reklam birimlerini görebilirsiniz.

### Console Log ile Test

Xcode Console'da `AdsYieldAdapter` tag'ini filtreleyin. Adapter'ın her işlemi loglanır:

```
[AdsYieldAdapter] Adapter set up complete.
[AdsYieldAdapter] Loading banner ad with ad unit ID: ca-app-pub-XXXXX/YYYYY
[AdsYieldAdapter] Banner ad loaded successfully.
[AdsYieldAdapter] Banner ad impression recorded.
```

---

## 8. Sorun Giderme

| Sorun | Olası Neden | Çözüm |
|-------|-------------|-------|
| Adapter bulunamıyor | Pod eklenmemiş veya class name yanlış | `pod install` yapın, class name'i kontrol edin: `AdsYieldAdapter.AdsYieldCustomEvent` |
| "Missing ad unit ID" | Custom event parameter boş | AdMob/GAM UI'da parameter alanına AdsYield ad unit ID yazın |
| "No fill" | Ad unit'te demand yok | AdsYield ekibine ulaşın, ad unit'in aktif olduğundan emin olun |
| Reklam yüklenmiyor | SDK başlatılmamış | `MobileAds.shared.start()` çağrıldığından emin olun |
| Callback gelmiyor | Mediation group ayarı eksik | Custom event'in mediation group'a eklendiğinden emin olun |

### Hata Kodları

| Kod | Açıklama |
|-----|----------|
| 101 | Ad unit ID eksik veya boş (parameter alanı kontrol edilmeli) |
| 103 | Reklam henüz yüklenmeden gösterilmeye çalışıldı |

---

## 9. Versiyon Uyumluluğu

| Adapter Versiyonu | Google Mobile Ads SDK | Min iOS |
|-------------------|-----------------------|---------|
| 1.0.0 | 12.5+ | 13.0 |

---

## Destek

Sorularınız veya sorunlarınız için:
- GitHub Issues: https://github.com/bugranalci/AdsyieldMediationAdapter-iOS/issues
- E-posta: info@adsyield.com
