
//Header
import SmaatoSDKBanner
import VrtcalSDK

//Smaato Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventSmaato: VRTAbstractBannerCustomEvent {
    private var bannerView: SMABannerView?
    var smaBannerViewDelegatePassthrough = SMABannerViewDelegatePassthrough()
    
    override func loadBannerAd() {
        
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            switch result {
            case .success():
                self.finishLoadingBanner()
            case .failure(let vrtError):
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            }
        }
    }
    
    func finishLoadingBanner() {
        guard let adSpaceId = customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
            thirdPartyCustomEventKey: ThirdPartyCustomEventKey.adUnitId,
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
      
        let frame = CGRect(
            x: 0,
            y: 0,
            width: customEventConfig.adSize.width,
            height: customEventConfig.adSize.height
        )
        
        smaBannerViewDelegatePassthrough.viewControllerDelegate = viewControllerDelegate
        smaBannerViewDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate

        bannerView = SMABannerView(frame: frame)
        bannerView?.delegate = smaBannerViewDelegatePassthrough
        bannerView?.load(
            withAdSpaceId: adSpaceId,
            adSize: .xxLarge_320x50
        )
    }
    
    override func getView() -> UIView? {
        smaBannerViewDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        return bannerView
    }
}

class SMABannerViewDelegatePassthrough: NSObject, SMABannerViewDelegate {

    public weak var viewControllerDelegate: ViewControllerDelegate?
    public weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    public weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    func bannerViewDidTTLExpire(_ bannerView: SMABannerView) {
        // No VRT analog
    }

    func presentingViewController(for bannerView: SMABannerView) -> UIViewController {
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: .customEventViewControllerNil)
            return UIViewController()
        }
        return vc
    }

    func bannerViewDidLoad(_ bannerView: SMABannerView) {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }

    func bannerViewDidClick(_ bannerView: SMABannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func bannerView(_ bannerView: SMABannerView, didFailWithError error: Error) {
        VRTLogInfo("error: \(error)")
        let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    func bannerViewWillPresentModalContent(_ bannerView: SMABannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillPresentModal(.unknown)
    }

    func bannerViewDidPresentModalContent(_ bannerView: SMABannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.unknown)
    }

    func bannerViewDidDismissModalContent(_ bannerView: SMABannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func bannerWillLeaveApplication(fromAd bannerView: SMABannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillLeaveApplication()
    }

    func bannerViewDidImpress(_ bannerView: SMABannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
    }
}
