
//Header
import SmaatoSDKInterstitial
import VrtcalSDK

//Smaato Banner Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventSmaato: VRTAbstractInterstitialCustomEvent {
    
    private var smaInterstitialDelegatePassthrough = SMAInterstitialDelegatePassthrough()
    
    override func loadInterstitialAd() {
        
        guard let adSpaceId = customEventConfig.thirdPartyAdUnitId(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
        
        smaInterstitialDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        
        SmaatoSDK.loadInterstitial(
            forAdSpaceId: adSpaceId,
            delegate: smaInterstitialDelegatePassthrough
        )
    }
    
    override func showInterstitialAd() {
        smaInterstitialDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            customEventShowDelegate?.customEventFailedToShow(
                vrtError: .customEventViewControllerNil
            )
            return
        }
        smaInterstitialDelegatePassthrough.smaInterstitial?.show(from: vc)
    }
}

