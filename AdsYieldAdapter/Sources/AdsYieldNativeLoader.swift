import GoogleMobileAds
import UIKit

/// Loads and manages native ads for AdsYield mediation.
class AdsYieldNativeLoader: NSObject, MediationNativeAd {

    private var nativeAd: NativeAd?
    private var adLoader: AdLoader?
    var delegate: MediationNativeAdEventDelegate?
    private var completionHandler: GADMediationNativeLoadCompletionHandler?

    // MARK: - MediationNativeAd Properties

    var headline: String? {
        return nativeAd?.headline
    }

    var images: [NativeAdImage]? {
        return nativeAd?.images
    }

    var body: String? {
        return nativeAd?.body
    }

    var icon: NativeAdImage? {
        return nativeAd?.icon
    }

    var callToAction: String? {
        return nativeAd?.callToAction
    }

    var starRating: NSDecimalNumber? {
        return nativeAd?.starRating
    }

    var store: String? {
        return nativeAd?.store
    }

    var price: String? {
        return nativeAd?.price
    }

    var advertiser: String? {
        return nativeAd?.advertiser
    }

    var extraAssets: [String: Any]? {
        return nil
    }

    var adChoicesView: UIView? {
        return nil
    }

    var mediaView: UIView? {
        guard let mediaContent = nativeAd?.mediaContent else { return nil }
        let view = MediaView()
        view.mediaContent = mediaContent
        return view
    }

    var hasVideoContent: Bool {
        return nativeAd?.mediaContent.hasVideoContent ?? false
    }

    // MARK: - Load

    func loadNativeAd(
        for adConfiguration: MediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) {
        guard let adUnitID = adConfiguration.credentials.settings["parameter"] as? String,
              !adUnitID.isEmpty else {
            let error = AdsYieldError.missingAdUnitID
            NSLog("[%@] %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
            completionHandler(nil, error)
            return
        }

        self.completionHandler = completionHandler

        NSLog("[%@] Loading native ad with ad unit ID: %@", AdsYieldCustomEvent.TAG, adUnitID)

        let adLoader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: adConfiguration.topViewController,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        adLoader.load(Request())
        self.adLoader = adLoader
    }

    // MARK: - Impression & Click Tracking

    func didRecordImpression() {
        NSLog("[%@] Native ad impression recorded.", AdsYieldCustomEvent.TAG)
        delegate?.reportImpression()
    }

    func didUntrackView(_ view: UIView?) {
        nativeAd = nil
    }
}

// MARK: - NativeAdLoaderDelegate

extension AdsYieldNativeLoader: NativeAdLoaderDelegate {

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        NSLog("[%@] Native ad loaded successfully.", AdsYieldCustomEvent.TAG)
        self.nativeAd = nativeAd
        nativeAd.delegate = self
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        NSLog("[%@] Native ad failed to load: %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
}

// MARK: - NativeAdDelegate

extension AdsYieldNativeLoader: NativeAdDelegate {

    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        NSLog("[%@] Native ad clicked.", AdsYieldCustomEvent.TAG)
        delegate?.reportClick()
    }

    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        NSLog("[%@] Native ad impression recorded.", AdsYieldCustomEvent.TAG)
        delegate?.reportImpression()
    }

    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        delegate?.willPresentFullScreenView()
    }

    func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
        delegate?.willDismissFullScreenView()
    }

    func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
        delegate?.didDismissFullScreenView()
    }
}
