//Header
#import "VRTBannerCustomEventSmaato.h"

//Dependencies
@import SmaatoSDKBanner;

@interface VRTBannerCustomEventSmaato() <SMABannerViewDelegate>
@property SMABannerView *bannerView;
@end


//Vungle Banner Adapter, Vrtcal as Primary
@implementation VRTBannerCustomEventSmaato

- (void) loadBannerAd {
    NSString *adSpaceId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    
    if (adSpaceId == nil) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent message:@"No adSpaceId"];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }
    
    CGRect frame = CGRectMake(
        0,
        0,
        self.customEventConfig.adSize.width,
        self.customEventConfig.adSize.height
    );
    
    self.bannerView = [[SMABannerView alloc] initWithFrame:frame];
    self.bannerView.delegate = self;
    [self.bannerView loadWithAdSpaceId:adSpaceId adSize:kSMABannerAdSizeXXLarge_320x50];
}

- (UIView*) getView {
    return self.bannerView;
}


#pragma mark - SMABannerViewDelegate

- (void)bannerViewDidTTLExpire:(SMABannerView * _Nonnull)bannerView {
    // No VRT analog
}

- (nonnull UIViewController *)presentingViewControllerForBannerView:(SMABannerView * _Nonnull)bannerView {
    return [self.viewControllerDelegate vrtViewControllerForModalPresentation];
}

- (void)bannerViewDidLoad:(SMABannerView *_Nonnull)bannerView {
    [self.customEventLoadDelegate customEventLoaded];
}

- (void)bannerViewDidClick:(SMABannerView *_Nonnull)bannerView {
    [self.customEventShowDelegate customEventClicked];
}

- (void)bannerView:(SMABannerView *_Nonnull)bannerView didFailWithError:(NSError *_Nonnull)error {
    [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
}

- (void)bannerViewWillPresentModalContent:(SMABannerView *_Nonnull)bannerView {
    [self.customEventShowDelegate customEventWillPresentModal:VRTModalTypeUnknown];
}

- (void)bannerViewDidPresentModalContent:(SMABannerView *_Nonnull)bannerView {
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeUnknown];
}

- (void)bannerViewDidDismissModalContent:(SMABannerView *_Nonnull)bannerView {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)bannerWillLeaveApplicationFromAd:(SMABannerView *_Nonnull)bannerView {
    [self.customEventShowDelegate customEventWillLeaveApplication];
}

- (void)bannerViewDidImpress:(SMABannerView *_Nonnull)bannerView {
    [self.customEventShowDelegate customEventShown];
}


@end
