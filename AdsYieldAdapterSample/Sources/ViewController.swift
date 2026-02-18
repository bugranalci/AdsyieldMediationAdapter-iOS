import GoogleMobileAds
import UIKit

class ViewController: UIViewController {

    // MARK: - Test Ad Unit IDs (Google's official test IDs)
    private let bannerAdUnitID        = "ca-app-pub-3940256099942544/2435281174"
    private let interstitialAdUnitID  = "ca-app-pub-3940256099942544/4411468910"
    private let rewardedAdUnitID      = "ca-app-pub-3940256099942544/1712485313"
    private let rewardedIntAdUnitID   = "ca-app-pub-3940256099942544/6978759866"
    private let nativeAdUnitID        = "ca-app-pub-3940256099942544/3986624511"

    // MARK: - Ad Objects
    private var bannerView: BannerView?
    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    private var rewardedInterstitialAd: RewardedInterstitialAd?
    private var nativeAd: NativeAd?
    private var adLoader: AdLoader?

    // MARK: - UI
    private let statusLabel = UILabel()
    private let stackView = UIStackView()
    private let nativeAdContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AdsYield Adapter Sample"
        view.backgroundColor = .systemBackground
        setupUI()
        loadBannerAd()
    }

    // MARK: - UI Setup

    private func setupUI() {
        statusLabel.text = "Ready"
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let buttons: [(String, Selector)] = [
            ("Load Interstitial", #selector(loadInterstitialTapped)),
            ("Show Interstitial", #selector(showInterstitialTapped)),
            ("Load Rewarded", #selector(loadRewardedTapped)),
            ("Show Rewarded", #selector(showRewardedTapped)),
            ("Load Rewarded Interstitial", #selector(loadRewardedIntTapped)),
            ("Show Rewarded Interstitial", #selector(showRewardedIntTapped)),
            ("Load Native", #selector(loadNativeTapped)),
        ]

        for (title, action) in buttons {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.addTarget(self, action: action, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        stackView.addArrangedSubview(statusLabel)

        nativeAdContainer.backgroundColor = .secondarySystemBackground
        nativeAdContainer.layer.cornerRadius = 8
        nativeAdContainer.isHidden = true
        nativeAdContainer.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(nativeAdContainer)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nativeAdContainer.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            nativeAdContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nativeAdContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nativeAdContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            nativeAdContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
        ])
    }

    private func updateStatus(_ text: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = text
            NSLog("[AdsYieldSample] %@", text)
        }
    }

    // MARK: - Banner

    private func loadBannerAd() {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = bannerAdUnitID
        banner.rootViewController = self
        banner.delegate = self
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)

        NSLayoutConstraint.activate([
            banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        banner.load(Request())
        self.bannerView = banner
        updateStatus("Loading banner...")
    }

    // MARK: - Interstitial

    @objc private func loadInterstitialTapped() {
        updateStatus("Loading interstitial...")
        InterstitialAd.load(with: interstitialAdUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                self?.updateStatus("Interstitial load failed: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.updateStatus("Interstitial loaded. Tap Show.")
        }
    }

    @objc private func showInterstitialTapped() {
        guard let ad = interstitialAd else {
            updateStatus("Interstitial not loaded yet.")
            return
        }
        ad.present(from: self)
    }

    // MARK: - Rewarded

    @objc private func loadRewardedTapped() {
        updateStatus("Loading rewarded...")
        RewardedAd.load(with: rewardedAdUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                self?.updateStatus("Rewarded load failed: \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.updateStatus("Rewarded loaded. Tap Show.")
        }
    }

    @objc private func showRewardedTapped() {
        guard let ad = rewardedAd else {
            updateStatus("Rewarded not loaded yet.")
            return
        }
        ad.present(from: self) { [weak self] in
            let reward = ad.adReward
            self?.updateStatus("Reward earned: \(reward.amount) \(reward.type)")
        }
    }

    // MARK: - Rewarded Interstitial

    @objc private func loadRewardedIntTapped() {
        updateStatus("Loading rewarded interstitial...")
        RewardedInterstitialAd.load(with: rewardedIntAdUnitID, request: Request()) { [weak self] ad, error in
            if let error = error {
                self?.updateStatus("Rewarded interstitial load failed: \(error.localizedDescription)")
                return
            }
            self?.rewardedInterstitialAd = ad
            self?.rewardedInterstitialAd?.fullScreenContentDelegate = self
            self?.updateStatus("Rewarded interstitial loaded. Tap Show.")
        }
    }

    @objc private func showRewardedIntTapped() {
        guard let ad = rewardedInterstitialAd else {
            updateStatus("Rewarded interstitial not loaded yet.")
            return
        }
        ad.present(from: self) { [weak self] in
            let reward = ad.adReward
            self?.updateStatus("Reward earned: \(reward.amount) \(reward.type)")
        }
    }

    // MARK: - Native

    @objc private func loadNativeTapped() {
        updateStatus("Loading native...")
        let adLoader = AdLoader(
            adUnitID: nativeAdUnitID,
            rootViewController: self,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = self
        adLoader.load(Request())
        self.adLoader = adLoader
    }

    private func displayNativeAd(_ nativeAd: NativeAd) {
        nativeAdContainer.subviews.forEach { $0.removeFromSuperview() }
        nativeAdContainer.isHidden = false

        let headlineLabel = UILabel()
        headlineLabel.text = nativeAd.headline
        headlineLabel.font = .boldSystemFont(ofSize: 16)
        headlineLabel.numberOfLines = 0

        let bodyLabel = UILabel()
        bodyLabel.text = nativeAd.body
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 0

        let ctaButton = UIButton(type: .system)
        ctaButton.setTitle(nativeAd.callToAction, for: .normal)
        ctaButton.backgroundColor = .systemGreen
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.layer.cornerRadius = 6
        ctaButton.isUserInteractionEnabled = false

        let stack = UIStackView(arrangedSubviews: [headlineLabel, bodyLabel, ctaButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        nativeAdContainer.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: nativeAdContainer.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: nativeAdContainer.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: nativeAdContainer.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: nativeAdContainer.bottomAnchor, constant: -12),
            ctaButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
}

// MARK: - BannerViewDelegate

extension ViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        updateStatus("Banner loaded.")
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        updateStatus("Banner failed: \(error.localizedDescription)")
    }
}

// MARK: - FullScreenContentDelegate

extension ViewController: FullScreenContentDelegate {
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        updateStatus("Ad failed to present: \(error.localizedDescription)")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        updateStatus("Ad dismissed.")
        interstitialAd = nil
        rewardedAd = nil
        rewardedInterstitialAd = nil
    }
}

// MARK: - NativeAdLoaderDelegate

extension ViewController: NativeAdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        self.nativeAd = nativeAd
        updateStatus("Native ad loaded.")
        displayNativeAd(nativeAd)
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        updateStatus("Native failed: \(error.localizedDescription)")
    }
}
