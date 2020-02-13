//
//  RtcNativeBridge.swift
//  Rtc555Sdk
//
//  Created by Girish on 04/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import React

@objc(RtcNativeBridge)
class RtcNativeBridge: NSObject {
    
    @objc func onRtcConnectionStateChange(_ connectionState: NSString) {
        
        let userinfo = ["state":connectionState]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventConnectionStateChange(staus: userinfo)
       
     }
    
    @objc func onRtcConnectionError(_ errorInfo: NSDictionary) {
           
        let userinfo = ["error":errorInfo]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventConnectionError(error: userinfo)
       
    }
    
    @objc func onRtcSessionStatus(_ status: NSString,traceId trace: NSString) {

        let userinfo = ["status":status, "traceId":trace]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventSessionStatus(status: userinfo)
      
    }
    
    @objc func onRtcSessionError(_ errorInfo: NSDictionary,traceId trace: NSString ) {
       
        let userinfo = ["error":errorInfo, "traceId":trace]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventSessionError(error: userinfo)
       
    }
    
    @objc func onNotification(_ notification: NSDictionary) {
          
        let userinfo = ["info":notification]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventNotification(notification: userinfo)
    
    }
    
    @objc func onCallResponse(_ callId: NSString){
        
        let userinfo = ["callId":callId]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventCallSuccess(staus: userinfo)
    }
    
    @objc func onCallFailed(_ errorInfo: NSDictionary){
        
        let userinfo = ["info":errorInfo]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventCallFailed(error: userinfo)
    
    }
    
    @objc func onRejectSuccess(_ callId: NSString){
           
           let userinfo = ["callId":callId]
           RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventCallSuccess(staus: userinfo)
       }
    
    @objc func onRejectFailed(_ errorInfo: NSDictionary){
        
        let userinfo = ["info":errorInfo]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventCallFailed(error: userinfo)
    
    }
    
    @objc func onCallMerged(_ callId: NSString){
              
        let userinfo = ["callId":callId]
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventCallMergeSuccess(status: userinfo)
    }
    
}

public protocol rtcNativeEventDelegate {
     func onRtcNativeEventNotification(notification notificationData: [AnyHashable : Any])
     func onRtcNativeEventConnectionStateChange(staus connectionStatus: [AnyHashable : Any])
     func onRtcNativeEventConnectionError(error connectionErrorInfo: [AnyHashable : Any])
     func onRtcNativeEventSessionStatus(status callStatusInfo: [AnyHashable : Any])
     func onRtcNativeEventSessionError(error sessionErrorInfo:[AnyHashable : Any])
     func onRtcNativeEventCallSuccess(staus dialStatus: [AnyHashable : Any])
     func onRtcNativeEventCallFailed(error sessionErrorInfo:[AnyHashable : Any])
     func onRtcNativeEventCallMergeSuccess(status callStatusInfo: [AnyHashable : Any])
}
