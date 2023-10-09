
//Header
import SmaatoSDKBanner
import VrtcalSDK

//Smaato Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventSmaato: VRTAbstractBannerCustomEvent {
    private var bannerView: SMABannerView?
    var smaBannerViewDelegatePassthrough = SMABannerViewDelegatePassthrough()
    
    override func loadBannerAd() {
        
        
        guard let adSpaceId = customEventConfig.thirdPartyAppId(
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
        smaBannerViewDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        bannerView = SMABannerView(frame: frame)
        bannerView?.delegate = smaBannerViewDelegatePassthrough
        bannerView?.load(
            withAdSpaceId: adSpaceId,
            adSize: .xxLarge_320x50
        )
    }
    
    override func getView() -> UIView? {
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
        customEventLoadDelegate?.customEventLoaded()
    }

    func bannerViewDidClick(_ bannerView: SMABannerView) {
        customEventShowDelegate?.customEventClicked()
    }

    func bannerView(_ bannerView: SMABannerView, didFailWithError error: Error) {
        let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    func bannerViewWillPresentModalContent(_ bannerView: SMABannerView) {
        customEventShowDelegate?.customEventWillPresentModal(.unknown)
    }

    func bannerViewDidPresentModalContent(_ bannerView: SMABannerView) {
        customEventShowDelegate?.customEventDidPresentModal(.unknown)
    }

    func bannerViewDidDismissModalContent(_ bannerView: SMABannerView) {
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func bannerWillLeaveApplication(fromAd bannerView: SMABannerView) {
        customEventShowDelegate?.customEventWillLeaveApplication()
    }

    func bannerViewDidImpress(_ bannerView: SMABannerView) {
        customEventShowDelegate?.customEventShown()
    }
}
