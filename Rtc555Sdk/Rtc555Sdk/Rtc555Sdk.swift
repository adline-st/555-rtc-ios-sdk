//
//  RtcReactSdk.swift
//  RtcReactSdk
//
//  Created by Admin on 13/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import React

public enum CallStatus{
    
    case initializing
    case connecting
    case connected
    case disconnected
    case hold
}

public enum DtmfInputType : String{
    
    case Number1 = "1"
    case Number2 = "2"
    case Number3 = "3"
    case Number4 = "4"
    case Number5 = "5"
    case Number6 = "6"
    case Number7 = "7"
    case Number8 = "8"
    case Number9 = "9"
    case Number0 = "0"
    case Star = "*"
    case Hash = "#"
    case LetterA = "A"
    case LetterB = "B"
    case LetterC = "C"
    case LetterD = "D"
    
}

public struct Rtc555Config{
    public var sourceTelephonenum : String
    public var token : String
    public var routingId : String
    public var eventManagerUrl : String
    
    public init(){
        sourceTelephonenum = ""
        token = ""
        routingId = ""
        eventManagerUrl = ""
    }
}

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
    
    public func setConfig(config Config:Rtc555Config){
       
        var config : [String : String] = [:]
        config["sourceTelephonenum"] = Config.sourceTelephonenum
        config["routingId"] = Config.routingId
        config["eventManagerUrl"] = Config.eventManagerUrl
        config["token"] = Config.token
        
        let args = [config]
        RtcReactBridge.sharedInstance.callMethod("setConfig",args)
       
    }
   
    private func connect(evmURL url:String,irisToken token:String,routingId id:String) {
        let args = [url,token,id]
        RtcReactBridge.sharedInstance.callMethod("connect",args)
    }
    
    public func dial(targetTelephoneNumber targetNumber:String,notificationPayload payload:String,completion: @escaping (Result<String, Error>) -> Void) {
 
        let args = [targetNumber,payload] as [Any]
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
    
    
    public func accept(notificationData notification:[AnyHashable : Any],completion: @escaping (Result<String, Error>) -> Void) {

        let args = [notification] as [Any]
       
        RtcReactBridge.sharedInstance.callMethod("accept",args)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            var result: Result<String, Error>
            
            print("running timer")
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
    
    public func sendDTMF(dtmfTone tone:DtmfInputType) {
           let args = [tone.rawValue]
           RtcReactBridge.sharedInstance.callMethod("sendDTMF",args)
    }
    
    public func cleanup(){
           let args:[String] = []
           RtcReactBridge.sharedInstance.callMethod("cleanup",args)
    }
    
    public func reject(notificationData notification:[AnyHashable : Any],completion: @escaping (Result<String, Error>) -> Void) {
           let args = [notification]
           RtcReactBridge.sharedInstance.callMethod("reject",args)
        
           Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
             var result: Result<String, Error>
             
             print("running timer")
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
    
    public func onRtcNativeEventNotification(notification notificationData: [AnyHashable : Any]) {
           let incomingNotification = notificationData["info"]
           rtcDelegate.onNotification(notification: incomingNotification as! [AnyHashable : Any])
    }
    
    public func onRtcNativeEventConnectionStateChange(staus connectionStatus: [AnyHashable : Any]) {
//        if let state = connectionStatus["state"] as? String{
//            rtcDelegate?.onRtcConnectionStateChange(state: state)
//        }
    }
       
    public func onRtcNativeEventConnectionError(error connectionErrorInfo: [AnyHashable : Any]) {
          // rtcDelegate?.onRtcConnectionStateChange(state: connectionErrorInfo)
        
    }
    
    public func onRtcNativeEventCallSuccess(staus dialStatus: [AnyHashable : Any]) {

            self.callId = dialStatus["callId"] as? String
            self.isCallSuccess = true
    }
    
    public func onRtcNativeEventCallFailed(error sessionErrorInfo: [AnyHashable : Any]) {
            let errorInfoDict = sessionErrorInfo["info"] as? [AnyHashable : Any]
            let errorCode = Int(errorInfoDict?["code"] as! String)!
            sessionError =  NSError(domain:"", code:errorCode, userInfo:[ NSLocalizedDescriptionKey: errorInfoDict?["reason"] as Any])
            self.isCallFailed = true
    }
      
    public func onRtcNativeEventSessionStatus(status callStatusInfo: [AnyHashable : Any]) {
           if let state = callStatusInfo["status"] as? String, let traceId = callStatusInfo["traceId"] as? String{
                rtcDelegate?.onCallStatus(status: self.getCallStatus(status: state),id: traceId)
           }
    }
       
    public func onRtcNativeEventSessionError(error sessionErrorInfo: [AnyHashable : Any]) {
          if let errorInfoDict = sessionErrorInfo["error"] as? [AnyHashable : Any], let traceId = sessionErrorInfo["traceId"] as? String{
                let errorCode = Int(errorInfoDict["code"] as! String)!
                let error =  NSError(domain:"", code:errorCode, userInfo:[ NSLocalizedDescriptionKey: errorInfoDict["reason"] as Any])
                rtcDelegate?.onCallError(error:error ,id:traceId)
          }
    }
    
    public func onRtcNativeEventCallMergeSuccess(status callStatusInfo: [AnyHashable : Any]){
         let callId = callStatusInfo["callId"] as? String
         rtcDelegate?.onCallMerged(id: callId!)
    }
    
    private func getCallStatus(status:String)-> CallStatus{
        if(status.lowercased() == "initializing"){
            return CallStatus.initializing
        }
        else
        if(status.lowercased() == "connecting"){
            return CallStatus.connecting
        }
        if(status.lowercased() == "connected"){
            return CallStatus.connected
        }
        else
        if(status.lowercased() == "disconnected"){
            return CallStatus.disconnected
        }
        if(status.lowercased() == "hold"){
            return CallStatus.hold
        }
        
        return CallStatus.initializing
    }
       
}

public protocol Rtc555SdkDelegate {
    func onCallStatus(status callStatus:CallStatus,id callId:String)
    func onCallError(error errorInfo:Error,id callId:String)
    func onCallMerged(id callId:String)
    func onNotification(notification notificationData: [AnyHashable : Any])
}

extension  Rtc555SdkDelegate  {
    
    func onNotification(notification notificationData: [AnyHashable : Any]){
       
    }
}
