//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//Header
import SmaatoSDKInterstitial
import VrtcalSDK

//Smaato Banner Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventSmaato: VRTAbstractInterstitialCustomEvent, SMAInterstitialDelegate {
    private var smaInterstitial: SMAInterstitial?

    func loadInterstitialAd() {
        let adSpaceId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String

        if adSpaceId == nil {
            let error = VRTError(code: VRTErrorCodeCustomEvent, message: "No adSpaceId")
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }

        SmaatoSDK.loadInterstitial(forAdSpaceId: adSpaceId, delegate: self)
    }

    func showInterstitialAd() {
        let vc = viewControllerDelegate.vrtViewControllerForModalPresentation()
        smaInterstitial?.show(from: vc)
    }

    // MARK: - VRTVungleManagerDelegate

    func interstitialDidLoad(_ interstitial: SMAInterstitial) {
        smaInterstitial = interstitial
        customEventLoadDelegate.customEventLoaded()
    }

    func interstitial(_ interstitial: SMAInterstitial?, didFailWithError error: Error) {
        customEventLoadDelegate.customEventFailedToLoadWithError(error)
    }

    func interstitialDidTTLExpire(_ interstitial: SMAInterstitial) {
        //No VRT Analog
    }

    func interstitialWillAppear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate.customEventWillPresentModal(VRTModalTypeInterstitial)
    }

    func interstitialDidAppear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate.customEventDidPresentModal(VRTModalTypeInterstitial)
    }

    func interstitialWillDisappear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate.customEventWillDismissModal(VRTModalTypeInterstitial)
    }

    func interstitialDidDisappear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeInterstitial)
    }

    func interstitialDidClick(_ interstitial: SMAInterstitial) {
        customEventShowDelegate.customEventClicked()
    }

    func interstitialWillLeaveApplication(_ interstitial: SMAInterstitial) {
        customEventShowDelegate.customEventWillLeaveApplication()
    }
}

//Dependencies