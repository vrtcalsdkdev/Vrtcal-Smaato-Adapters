import SmaatoSDKBanner
import VrtcalSDK


// Must be NSObject for SmaatoSdkInitialisationDelegate
class VRTAsPrimaryManager: NSObject {

    static var singleton = VRTAsPrimaryManager()
    var initialized = false
    var completionHandler: ((Result<Void,VRTError>) -> ())?
    
    func initializeThirdParty(
        customEventConfig: VRTCustomEventConfig,
        completionHandler: @escaping (Result<Void,VRTError>) -> ()
    ) {
        VRTLogInfo()
        guard !initialized else {
            completionHandler(.success())
            return
        }
        
        // Require the appId
        guard let appId = customEventConfig.thirdPartyCustomEventDataValue(
            thirdPartyCustomEventKey: .appId
        ).getSuccess(failureHandler: { vrtError in
            completionHandler(.failure(vrtError))
        }) else {
            return
        }
        
        // Attempt to make the config
        guard let config = SMAConfiguration(publisherId: appId) else {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Could not make config")
            completionHandler(.failure(vrtError))
            return
        }
        
        // Retain the completionHandler
        self.completionHandler = completionHandler
        
        config.httpsOnly = true
        config.logLevel = .verbose
        config.maxAdContentRating = .undefined
        SmaatoSDK.initSDK(
            withConfig:config,
            andDelegate: self
        )
    }
}

extension VRTAsPrimaryManager: SmaatoSdkInitialisationDelegate {
    func onInitialisationSuccess() {
        VRTLogInfo()
        initialized = true
        
        self.completionHandler?(.success())
        self.completionHandler = nil
    }
    
    func onInitialisationFailure(_ errorMessage: String?) {
        VRTLogInfo()
        let vrtError = VRTError(vrtErrorCode: .customEvent, message: errorMessage ?? "nil")
        self.completionHandler?(.failure(vrtError))
        self.completionHandler = nil
    }
}
