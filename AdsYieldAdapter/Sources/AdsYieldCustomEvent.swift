import GoogleMobileAds
import UIKit

/// AdsYield mediation adapter for Google AdMob and Google Ad Manager.
/// This is a pass-through adapter that loads ads from AdsYield's MCM ad units
/// using the Google Mobile Ads SDK.
///
/// Register this class in AdMob/GAM as: AdsYieldAdapter.AdsYieldCustomEvent
@objc public class AdsYieldCustomEvent: NSObject, MediationAdapter {

    static let TAG = "AdsYieldAdapter"
    static let adapterVersionString = "1.0.0.0"

    // MARK: - Strong references to loaders (prevent deallocation during async ad loads)

    private var bannerLoader: AdsYieldBannerLoader?
    private var interstitialLoader: AdsYieldInterstitialLoader?
    private var rewardedLoader: AdsYieldRewardedLoader?
    private var rewardedInterstitialLoader: AdsYieldRewardedInterstitialLoader?
    private var nativeLoader: AdsYieldNativeLoader?

    // MARK: - GADMediationAdapter Protocol

    public static func adSDKVersion() -> VersionNumber {
        let versionString = MobileAdsGlobal.sdkVersion
        let components = versionString.components(separatedBy: ".")
        if components.count >= 3 {
            return VersionNumber(
                majorVersion: Int(components[0]) ?? 0,
                minorVersion: Int(components[1]) ?? 0,
                patchVersion: Int(components[2]) ?? 0
            )
        }
        return VersionNumber()
    }

    public static func adapterVersion() -> VersionNumber {
        let components = adapterVersionString.components(separatedBy: ".")
        if components.count >= 4 {
            return VersionNumber(
                majorVersion: Int(components[0]) ?? 0,
                minorVersion: Int(components[1]) ?? 0,
                patchVersion: (Int(components[2]) ?? 0) * 100 + (Int(components[3]) ?? 0)
            )
        }
        return VersionNumber()
    }

    public static func networkExtrasClass() -> (any AdNetworkExtras.Type)? {
        return nil
    }

    public static func setUpWith(
        _ configuration: MediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        // Pass-through adapter - no SDK initialization needed.
        NSLog("[%@] Adapter set up complete.", TAG)
        completionHandler(nil)
    }

    // MARK: - Ad Loading

    public func loadBanner(
        for adConfiguration: MediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        let loader = AdsYieldBannerLoader()
        self.bannerLoader = loader
        loader.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }

    public func loadInterstitial(
        for adConfiguration: MediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        let loader = AdsYieldInterstitialLoader()
        self.interstitialLoader = loader
        loader.loadInterstitial(for: adConfiguration, completionHandler: completionHandler)
    }

    public func loadRewardedAd(
        for adConfiguration: MediationRewardedAdConfiguration,
        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler
    ) {
        let loader = AdsYieldRewardedLoader()
        self.rewardedLoader = loader
        loader.loadRewarded(for: adConfiguration, completionHandler: completionHandler)
    }

    public func loadRewardedInterstitialAd(
        for adConfiguration: MediationRewardedAdConfiguration,
        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler
    ) {
        let loader = AdsYieldRewardedInterstitialLoader()
        self.rewardedInterstitialLoader = loader
        loader.loadRewarded(for: adConfiguration, completionHandler: completionHandler)
    }

    public func loadNativeAd(
        for adConfiguration: MediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) {
        let loader = AdsYieldNativeLoader()
        self.nativeLoader = loader
        loader.loadNativeAd(for: adConfiguration, completionHandler: completionHandler)
    }
}
