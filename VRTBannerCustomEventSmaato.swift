//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
//Header
import SmaatoSDKBanner
import VrtcalSDK

//Smaato Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventSmaato: VRTAbstractBannerCustomEvent, SMABannerViewDelegate {
    private var bannerView: SMABannerView?

    func loadBannerAd() {
        let adSpaceId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String

        if adSpaceId == nil {
            let error = VRTError(code: VRTErrorCodeCustomEvent, message: "No adSpaceId")
            customEventLoadDelegate.customEventFailedToLoadWithError(error)
            return
        }

        let frame = CGRect(
            x: 0,
            y: 0,
            width: customEventConfig.adSize.width,
            height: customEventConfig.adSize.height)

        bannerView = SMABannerView(frame: frame)
        bannerView?.delegate = self
        bannerView?.load(withAdSpaceId: adSpaceId, adSize: kSMABannerAdSizeXXLarge_320x50)
    }

    func getView() -> UIView? {
        return bannerView
    }

    // MARK: - SMABannerViewDelegate

    func bannerViewDidTTLExpire(_ bannerView: SMABannerView) {
        // No VRT analog
    }

    func presentingViewController(for bannerView: SMABannerView) -> UIViewController {
        return viewControllerDelegate.vrtViewControllerForModalPresentation()
    }

    func bannerViewDidLoad(_ bannerView: SMABannerView) {
        customEventLoadDelegate.customEventLoaded()
    }

    func bannerViewDidClick(_ bannerView: SMABannerView) {
        customEventShowDelegate.customEventClicked()
    }

    func bannerView(_ bannerView: SMABannerView, didFailWithError error: Error) {
        customEventLoadDelegate.customEventFailedToLoadWithError(error)
    }

    func bannerViewWillPresentModalContent(_ bannerView: SMABannerView) {
        customEventShowDelegate.customEventWillPresentModal(VRTModalTypeUnknown)
    }

    func bannerViewDidPresentModalContent(_ bannerView: SMABannerView) {
        customEventShowDelegate.customEventDidPresentModal(VRTModalTypeUnknown)
    }

    func bannerViewDidDismissModalContent(_ bannerView: SMABannerView) {
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeUnknown)
    }

    func bannerWillLeaveApplication(fromAd bannerView: SMABannerView) {
        customEventShowDelegate.customEventWillLeaveApplication()
    }

    func bannerViewDidImpress(_ bannerView: SMABannerView) {
        customEventShowDelegate.customEventShown()
    }
}

//Dependencies


//Vungle Banner Adapter, Vrtcal as Primary