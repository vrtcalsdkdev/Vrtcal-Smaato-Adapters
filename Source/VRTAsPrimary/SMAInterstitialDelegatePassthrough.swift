//
//  Passthrough.swift
//  Vrtcal-Fyber-Marketplace-Adapters
//
//  Created by Scott McCoy on 9/16/23.
//

import SmaatoSDKInterstitial
import VrtcalSDK

class SMAInterstitialDelegatePassthrough: NSObject, SMAInterstitialDelegate {

    var smaInterstitial: SMAInterstitial?
    weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    func interstitialDidLoad(_ interstitial: SMAInterstitial) {
        smaInterstitial = interstitial
        customEventLoadDelegate?.customEventLoaded()
    }

    func interstitial(_ interstitial: SMAInterstitial?, didFailWithError error: Error) {
        
        
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: .init(customEventError: error))
    }

    func interstitialDidTTLExpire(_ interstitial: SMAInterstitial) {
        //No VRT Analog
    }

    func interstitialWillAppear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate?.customEventWillPresentModal(.interstitial)
    }

    func interstitialDidAppear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate?.customEventDidPresentModal(.interstitial)
    }

    func interstitialWillDisappear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate?.customEventWillDismissModal(.interstitial)
    }

    func interstitialDidDisappear(_ interstitial: SMAInterstitial) {
        customEventShowDelegate?.customEventDidDismissModal(.interstitial)
    }

    func interstitialDidClick(_ interstitial: SMAInterstitial) {
        customEventShowDelegate?.customEventClicked()
    }

    func interstitialWillLeaveApplication(_ interstitial: SMAInterstitial) {
        customEventShowDelegate?.customEventWillLeaveApplication()
    }
}
