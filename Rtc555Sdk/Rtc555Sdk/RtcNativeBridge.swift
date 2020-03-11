//
//  RtcNativeBridge.swift
//  RtcReactSdk
//
//  Created by Girish on 04/12/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import React

@objc(RtcNativeBridge)
class RtcNativeBridge: NSObject {
    
    @objc func onRtcSessionStatus(_ status: NSString,traceId trace: NSString) {
        Rtc555Voice.rtcDelegate?.onStatus(status: self.getCallStatus(status: status as String), id: trace as String)
    }
    
    @objc func onRtcSessionError(_ errorInfo: NSDictionary,traceId trace: NSString ) {
    
        let errorCode = Int(errorInfo["code"] as! String)!
        let error =  NSError(domain:"", code:errorCode, userInfo:[ NSLocalizedDescriptionKey: errorInfo["reason"] as Any])
        Rtc555Voice.rtcDelegate?.onError(error:error ,id:trace as String)
    }
    
    @objc func onNotification(_ notification: NSDictionary) {
        Rtc555Voice.rtcDelegate?.onNotification(notification: notification as! [AnyHashable : Any])
    }
    
    @objc func onCallResponse(_ callId: NSString){
        Rtc555Voice.callId = callId as String;
        Rtc555Voice.isCallSuccess = true;
    }
    
    @objc func onCallFailed(_ errorInfo: NSDictionary){
        let errorCode = Int(errorInfo["code"] as! String)!
        Rtc555Voice.sessionError =  NSError(domain:"", code:errorCode, userInfo:[ NSLocalizedDescriptionKey: errorInfo["reason"] as Any])
        Rtc555Voice.isCallFailed = true
    }
    
    @objc func onRejectSuccess(_ callId: NSString){
        Rtc555Voice.callId = callId as String;
        Rtc555Voice.isCallSuccess = true;
    }
    
    @objc func onRejectFailed(_ errorInfo: NSDictionary){
        
        let errorInfoDict = errorInfo["info"] as? [AnyHashable : Any]
        let errorCode = Int(errorInfoDict?["code"] as! String)!
        Rtc555Voice.sessionError =  NSError(domain:"", code:errorCode, userInfo:[ NSLocalizedDescriptionKey: errorInfoDict?["reason"] as Any])
        Rtc555Voice.isCallFailed = true;
    }
    
    @objc func onCallMerged(_ callId: NSString){

        Rtc555Voice.rtcDelegate?.onCallMerged(id: callId as String)
    }
    @objc func onRtcConnectionStateChange(_ connectionState: NSString) {
          
       //     let userinfo = ["state":connectionState]
       //     RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventConnectionStateChange(staus: userinfo)
         
       }
      
      @objc func onRtcConnectionError(_ errorInfo: NSDictionary) {
             
      //    let userinfo = ["error":errorInfo]
      //    RtcReactBridge.sharedInstance.rtcNativeEventDelegate?.onRtcNativeEventConnectionError(error: userinfo)
         
      }
    
    @objc func onLocalStream(_ localStream:NSDictionary){
    
    }
    
    @objc func onRemoteStream(_ remoteStream:NSDictionary){
    
    }
    
    private func getCallStatus(status:String)-> CallStatus{
        if(status.lowercased() == "initializing"){
            return CallStatus.initializing
        }
        else
        if(status.lowercased() == "connecting"){
            return CallStatus.connecting
        }
        else if(status.lowercased() == "connected"){
            return CallStatus.connected
        }
        else
        if(status.lowercased() == "disconnected"){
            return CallStatus.disconnected
        }
        else if(status.lowercased() == "hold"){
            return CallStatus.hold
        }
        
        return CallStatus.initializing
    }
    
}
