//Header
#import "VRTInterstitialCustomEventSmaato.h"

//Dependencies
@import SmaatoSDKInterstitial;


@interface VRTInterstitialCustomEventSmaato() <SMAInterstitialDelegate>
@property SMAInterstitial *smaInterstitial;
@end

@implementation VRTInterstitialCustomEventSmaato

- (void) loadInterstitialAd {
    NSString *adSpaceId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    
    if (adSpaceId == nil) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent message:@"No adSpaceId"];
        [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
        return;
    }

    [SmaatoSDK loadInterstitialForAdSpaceId:adSpaceId delegate:self];
}

- (void) showInterstitialAd {
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    [self.smaInterstitial showFromViewController:vc];
}


#pragma mark - VRTVungleManagerDelegate

- (void)interstitialDidLoad:(SMAInterstitial *_Nonnull)interstitial {
    self.smaInterstitial = interstitial;
    [self.customEventLoadDelegate customEventLoaded];
}

- (void)interstitial:(SMAInterstitial *_Nullable)interstitial didFailWithError:(NSError *_Nonnull)error {
    [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
}

- (void)interstitialDidTTLExpire:(SMAInterstitial *_Nonnull)interstitial {
    //No VRT Analog
}

- (void)interstitialWillAppear:(SMAInterstitial *_Nonnull)interstitial {
    [self.customEventShowDelegate customEventWillPresentModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidAppear:(SMAInterstitial *_Nonnull)interstitial {
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeInterstitial];
}

- (void)interstitialWillDisappear:(SMAInterstitial *_Nonnull)interstitial {
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidDisappear:(SMAInterstitial *_Nonnull)interstitial {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeInterstitial];
}

- (void)interstitialDidClick:(SMAInterstitial *_Nonnull)interstitial {
    [self.customEventShowDelegate customEventClicked];
}

- (void)interstitialWillLeaveApplication:(SMAInterstitial *_Nonnull)interstitial {
    [self.customEventShowDelegate customEventWillLeaveApplication];
}

@end
