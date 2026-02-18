import GoogleMobileAds
import UIKit

/// Loads and manages interstitial ads for AdsYield mediation.
class AdsYieldInterstitialLoader: NSObject, MediationInterstitialAd, FullScreenContentDelegate {

    private var interstitialAd: InterstitialAd?
    private var delegate: MediationInterstitialAdEventDelegate?
    private var completionHandler: GADMediationInterstitialLoadCompletionHandler?

    func loadInterstitial(
        for adConfiguration: MediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        guard let adUnitID = adConfiguration.credentials.settings["parameter"] as? String,
              !adUnitID.isEmpty else {
            let error = AdsYieldError.missingAdUnitID
            NSLog("[%@] %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
            completionHandler(nil, error)
            return
        }

        self.completionHandler = completionHandler

        NSLog("[%@] Loading interstitial ad with ad unit ID: %@", AdsYieldCustomEvent.TAG, adUnitID)

        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            guard let self = self else { return }

            if let error = error {
                NSLog("[%@] Interstitial ad failed to load: %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
                completionHandler(nil, error)
                return
            }

            NSLog("[%@] Interstitial ad loaded successfully.", AdsYieldCustomEvent.TAG)
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
            self.delegate = completionHandler(self, nil)
        }
    }

    func present(from viewController: UIViewController) {
        guard let ad = interstitialAd else {
            let error = AdsYieldError.adNotLoaded
            NSLog("[%@] %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
            delegate?.didFailToPresentWithError(error)
            return
        }
        ad.present(from: viewController)
    }

    // MARK: - FullScreenContentDelegate

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Interstitial ad clicked.", AdsYieldCustomEvent.TAG)
        delegate?.reportClick()
    }

    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Interstitial ad impression recorded.", AdsYieldCustomEvent.TAG)
        delegate?.reportImpression()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        NSLog("[%@] Interstitial ad failed to present: %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
        delegate?.didFailToPresentWithError(error)
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Interstitial ad will present.", AdsYieldCustomEvent.TAG)
        delegate?.willPresentFullScreenView()
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Interstitial ad dismissed.", AdsYieldCustomEvent.TAG)
        delegate?.didDismissFullScreenView()
        interstitialAd = nil
    }
}
