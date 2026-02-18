import GoogleMobileAds
import UIKit

/// Loads and manages banner ads for AdsYield mediation.
class AdsYieldBannerLoader: NSObject, MediationBannerAd, BannerViewDelegate {

    private var bannerView: BannerView?
    private var delegate: MediationBannerAdEventDelegate?
    private var completionHandler: GADMediationBannerLoadCompletionHandler?

    var view: UIView {
        return bannerView ?? UIView()
    }

    func loadBanner(
        for adConfiguration: MediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        guard let adUnitID = adConfiguration.credentials.settings["parameter"] as? String,
              !adUnitID.isEmpty else {
            let error = AdsYieldError.missingAdUnitID
            NSLog("[%@] %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
            completionHandler(nil, error)
            return
        }

        self.completionHandler = completionHandler

        NSLog("[%@] Loading banner ad with ad unit ID: %@", AdsYieldCustomEvent.TAG, adUnitID)

        let banner = BannerView(adSize: adConfiguration.adSize)
        banner.adUnitID = adUnitID
        banner.rootViewController = adConfiguration.topViewController
        banner.delegate = self
        banner.load(Request())
        self.bannerView = banner
    }

    // MARK: - BannerViewDelegate

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        NSLog("[%@] Banner ad loaded successfully.", AdsYieldCustomEvent.TAG)
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        NSLog("[%@] Banner ad failed to load: %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }

    func bannerViewDidRecordClick(_ bannerView: BannerView) {
        NSLog("[%@] Banner ad clicked.", AdsYieldCustomEvent.TAG)
        delegate?.reportClick()
    }

    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
        NSLog("[%@] Banner ad impression recorded.", AdsYieldCustomEvent.TAG)
        delegate?.reportImpression()
    }

    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
        delegate?.willPresentFullScreenView()
    }

    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
        delegate?.willDismissFullScreenView()
    }

    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
        delegate?.didDismissFullScreenView()
    }
}
