
//Header
import SmaatoSDKInterstitial
import VrtcalSDK

//Smaato Banner Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventSmaato: VRTAbstractInterstitialCustomEvent {
    
    private var smaInterstitialDelegatePassthrough = SMAInterstitialDelegatePassthrough()
    
    override func loadInterstitialAd() {
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            switch result {
            case .success():
                self.finishLoadingInterstitial()
            case .failure(let vrtError):
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            }
        }
    }
    
    func finishLoadingInterstitial() {

        guard let adSpaceId = customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
            thirdPartyCustomEventKey: ThirdPartyCustomEventKey.adUnitId,
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

