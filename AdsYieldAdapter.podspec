Pod::Spec.new do |s|
  s.name             = 'AdsYieldAdapter'
  s.version          = '1.0.0'
  s.summary          = 'AdsYield iOS mediation adapter for Google AdMob and Google Ad Manager.'
  s.description      = <<-DESC
    AdsYield Mediation Adapter enables publishers to integrate AdsYield demand
    into their apps through Google AdMob or Google Ad Manager mediation.
    Supports Banner, Interstitial, Rewarded, Rewarded Interstitial, and Native ad formats.
  DESC

  s.homepage         = 'https://github.com/bugranalci/AdsyieldMediationAdapter-iOS'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'AdsYield' => 'info@adsyield.com' }
  s.source           = { :git => 'https://github.com/bugranalci/AdsyieldMediationAdapter-iOS.git',
                          :tag => s.version.to_s }

  s.platform         = :ios
  s.ios.deployment_target = '13.0'
  s.swift_versions   = ['5']
  s.static_framework = true

  s.source_files     = 'AdsYieldAdapter/Sources/**/*.swift'

  s.dependency 'Google-Mobile-Ads-SDK', '~> 12.5'
  s.frameworks       = 'UIKit'
end
