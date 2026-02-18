import GoogleMobileAds
import UIKit

/// Loads and manages rewarded ads for AdsYield mediation.
class AdsYieldRewardedLoader: NSObject, MediationRewardedAd, FullScreenContentDelegate {

    private var rewardedAd: RewardedAd?
    private var delegate: MediationRewardedAdEventDelegate?
    private var completionHandler: GADMediationRewardedLoadCompletionHandler?

    func loadRewarded(
        for adConfiguration: MediationRewardedAdConfiguration,
        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler
    ) {
        guard let adUnitID = adConfiguration.credentials.settings["parameter"] as? String,
              !adUnitID.isEmpty else {
            let error = AdsYieldError.missingAdUnitID
            NSLog("[%@] %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
            completionHandler(nil, error)
            return
        }

        self.completionHandler = completionHandler

        NSLog("[%@] Loading rewarded ad with ad unit ID: %@", AdsYieldCustomEvent.TAG, adUnitID)

        RewardedAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            guard let self = self else { return }

            if let error = error {
                NSLog("[%@] Rewarded ad failed to load: %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
                completionHandler(nil, error)
                return
            }

            NSLog("[%@] Rewarded ad loaded successfully.", AdsYieldCustomEvent.TAG)
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.delegate = completionHandler(self, nil)
        }
    }

    func present(from viewController: UIViewController) {
        guard let ad = rewardedAd else {
            let error = AdsYieldError.adNotLoaded
            NSLog("[%@] %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
            delegate?.didFailToPresentWithError(error)
            return
        }
        ad.present(from: viewController) { [weak self] in
            guard let self = self else { return }
            let reward = ad.adReward
            NSLog("[%@] User earned reward: %@ %@", AdsYieldCustomEvent.TAG,
                  reward.amount, reward.type)
            self.delegate?.didRewardUser()
        }
    }

    // MARK: - FullScreenContentDelegate

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Rewarded ad clicked.", AdsYieldCustomEvent.TAG)
        delegate?.reportClick()
    }

    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Rewarded ad impression recorded.", AdsYieldCustomEvent.TAG)
        delegate?.reportImpression()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        NSLog("[%@] Rewarded ad failed to present: %@", AdsYieldCustomEvent.TAG, error.localizedDescription)
        delegate?.didFailToPresentWithError(error)
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Rewarded ad will present.", AdsYieldCustomEvent.TAG)
        delegate?.willPresentFullScreenView()
        delegate?.didStartVideo()
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        NSLog("[%@] Rewarded ad dismissed.", AdsYieldCustomEvent.TAG)
        delegate?.didEndVideo()
        delegate?.didDismissFullScreenView()
        rewardedAd = nil
    }
}
