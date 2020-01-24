//
//  RtcReactSdk.swift
//  RtcReactSdk
//
//  Created by Admin on 13/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import React


public class Rtc555Sdk: NSObject,rtcNativeEventDelegate {
    
    private var rtcDelegate : Rtc555SdkDelegate!
    private var sourceTn,irisToken,routingId,evmUrl,callId:String?
    private var sessionError:Error?
    private var isCallSuccess:Bool?
    private var isCallFailed:Bool?
   
    public init(rtc55SdkDelegate:Rtc555SdkDelegate){
        self.sourceTn = ""
        self.irisToken = ""
        self.routingId = ""
        self.evmUrl = ""
        self.callId = ""
        isCallSuccess = false
        isCallFailed = false
        self.rtcDelegate = rtc55SdkDelegate
        RtcReactBridge.sharedInstance.createBridge()
        super.init()
        RtcReactBridge.sharedInstance.rtcNativeEventDelegate = self
    }
    
    public func setConfig(sourceTelephonenum sourceTn:String,token Token:String,routingId RoutingId:String,eventManagerUrl evmUrl:String){
        self.sourceTn = sourceTn
        self.irisToken = Token
        self.routingId = RoutingId
        self.evmUrl = evmUrl
    }
   
    private func connect(evmURL url:String,irisToken token:String,routingId id:String) {
        let args = [url,token,id]
        RtcReactBridge.sharedInstance.callMethod("connect",args)
    }
    
    public func dial(targetTelephoneNumber targetNumber:String,notificationPayload payload:String,completion: @escaping (Result<String, Error>) -> Void) {
 
        var config : [String : String] = [:]
        config["irisToken"] = self.irisToken
        config["routingId"] = self.routingId
        config["evmURL"] = self.evmUrl
       
        let args = [self.sourceTn as Any,targetNumber,payload,config] as [Any]
        RtcReactBridge.sharedInstance.callMethod("dial",args)
    
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
             var result: Result<String, Error>
            if(self.isCallSuccess!){
                self.isCallSuccess = false
                result = .success(self.callId!)
                 completion(result)
                 timer.invalidate()
            }else if (self.isCallFailed!){
                self.isCallFailed = false
                result = .failure(self.sessionError!)
                completion(result)
                timer.invalidate()
            }
        }
    }
    
    
    public func accept(notificationData notification:[AnyHashable : Any]) {
        var config : [String : String] = [:]
        config["irisToken"] = self.irisToken
        config["routingId"] = self.routingId
        config["evmURL"] = self.evmUrl
        let args = [notification,config] as [Any]
       
        RtcReactBridge.sharedInstance.callMethod("accept",args)
    }
    
    public func hangup(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("hangup",args)
    }
    
    public func hold(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("hold",args)
    }
    
    public func unhold(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("unhold",args)
    }
    
    public func mute(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("mute",args)
    }
    
    public func unmute(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("unmute",args)
    }
    
    public func merge(callId callid:Any) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("merge",args)
    }
    
    public func onRtcNativeEventNotification(notification notificationData: [AnyHashable : Any]) {
           let incomingNotification = notificationData["info"]
           rtcDelegate?.onNotification?(notification: incomingNotification as! [AnyHashable : Any])
    }
    
    public func onRtcNativeEventConnectionStateChange(staus connectionStatus: [AnyHashable : Any]) {
//        if let state = connectionStatus["state"] as? String{
//            rtcDelegate?.onRtcConnectionStateChange(state: state)
//        }
    }
       
    public func onRtcNativeEventConnectionError(error connectionErrorInfo: [AnyHashable : Any]) {
          // rtcDelegate?.onRtcConnectionStateChange(state: connectionErrorInfo)
        
    }
    
    public func onRtcNativeEventDialSuccess(staus dialStatus: [AnyHashable : Any]) {
            self.callId = dialStatus["callId"] as? String
            self.isCallSuccess = true
    }
    
    public func onRtcNativeEventDialFailed(error sessionErrorInfo: [AnyHashable : Any]) {
            let errorInfoDict = sessionErrorInfo["info"] as? [AnyHashable : Any]
            let errorCode = Int(errorInfoDict?["code"] as! String)!
            sessionError =  NSError(domain:"", code:errorCode, userInfo:[ NSLocalizedDescriptionKey: errorInfoDict?["reason"] as Any])
            self.isCallFailed = true
    }
      
    public func onRtcNativeEventSessionStatus(status callStatusInfo: [AnyHashable : Any]) {
           if let state = callStatusInfo["status"] as? String, let traceId = callStatusInfo["traceId"] as? String{
                rtcDelegate?.onCallStatus(status: state,id: traceId)
           }
    }
       
    public func onRtcNativeEventSessionError(error sessionErrorInfo: [AnyHashable : Any]) {
          if let errorInfoDict = sessionErrorInfo["error"] as? [AnyHashable : Any], let traceId = sessionErrorInfo["traceId"] as? String{
                rtcDelegate?.onCallError(error:errorInfoDict ,id:traceId)
          }
    }
       
}

@objc public protocol Rtc555SdkDelegate {
    func onCallStatus(status callStatus:String,id callId:String)
    func onCallError(error errorInfo:[AnyHashable : Any],id callId:String)
    @objc optional func onNotification(notification notificationData: [AnyHashable : Any])
}
