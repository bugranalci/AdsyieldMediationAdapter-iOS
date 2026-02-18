import Foundation

/// Error codes used by the AdsYield mediation adapter.
/// These codes match the Android adapter for consistency.
enum AdsYieldError {
    static let domain = "com.adsyield.mediation.adapter"

    /// Error 101: Ad unit ID is missing or empty in the mediation configuration.
    static let missingAdUnitID = NSError(
        domain: domain,
        code: 101,
        userInfo: [NSLocalizedDescriptionKey: "Missing ad unit ID in custom event parameter."]
    )

    /// Error 103: Attempted to show an ad that hasn't been loaded yet.
    static let adNotLoaded = NSError(
        domain: domain,
        code: 103,
        userInfo: [NSLocalizedDescriptionKey: "Ad has not been loaded yet."]
    )
}
