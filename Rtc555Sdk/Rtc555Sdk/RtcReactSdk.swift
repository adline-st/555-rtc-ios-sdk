//
//  RtcReactSdk.swift
//  RtcReactSdk
//
//  Created by Admin on 13/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import React


public class RtcReactSdk: NSObject {
    
    public var rtcDelegate : RtcReactSdkDelegate!
    
    public override init(){
        super.init()
        RtcReactBridge.sharedInstance.createBridge()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onConnectionStateChange(notification:)), name: Notification.Name("onConnectionStatus"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.onConnectionError(notification:)), name: Notification.Name("onConnectionError"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSessionStatus(notification:)), name: Notification.Name("onSessionStatus"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSessionError(notification:)), name: Notification.Name("onSessionError"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.onNotification(notification:)), name: Notification.Name("onNotification"), object: nil)
    }
   
    public func connect(evmURL url:String,irisToken token:String,routingId id:String) {
        let args = [url,token,id]
        RtcReactBridge.sharedInstance.callMethod("connect",args)
    }
    
    public func dial(sourceTN sourceNumber:String,TargetTN targetNumber:String,notificationPayload payload:String,configuration config: [String:String]?) -> String? {

        var mutatedConfig = config
        var callId = mutatedConfig?["callId"]
        if(callId == nil){
            callId  = UUID().uuidString
            mutatedConfig?["callId"] = callId
            print("creating traceid = ",mutatedConfig?["callId"] as Any)
        }
        
        let args = [sourceNumber,targetNumber,payload,mutatedConfig as Any] as [Any]
           RtcReactBridge.sharedInstance.callMethod("dial",args)
        
        return callId
    }
    
    public func accept(notificationData notification:[AnyHashable : Any],configuration config: [String:String]?) {
        let args = [notification as Any,config as Any]
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
    
    
    @objc func onConnectionStateChange(notification:Notification){
          print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
            if let state = dict["state"] as? String{
                 rtcDelegate?.onRtcConnectionStateChange(state: state)
            }
        }
    }
    
    @objc func onConnectionError(notification:Notification){
          print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
        
            rtcDelegate?.onRtcConnectionError(error: dict as! [AnyHashable : Any])
          
        }
    }
    
    @objc func onSessionStatus(notification:Notification){
          print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
            if let state = dict["status"] as? String, let traceId = dict["traceId"] as? String{
                rtcDelegate?.onRtcSessionStatus(status: state,id: traceId)
            }
        }
    }
    
    @objc func onNotification(notification:Notification){
       if let dict = notification.userInfo as NSDictionary? {
            let incomingNotification = dict["info"]
           
        rtcDelegate?.onNotification(notification: incomingNotification as! [AnyHashable : Any])
            
        }
    }
    
    @objc func onSessionError(notification:Notification){
          print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
          if let errorInfoDict = dict["error"] as? [AnyHashable : Any], let traceId = dict["traceId"] as? String{
            rtcDelegate?.onRtcSessionError(error:errorInfoDict ,id:traceId)
          }
          
          
        }
    }
}

public protocol RtcReactSdkDelegate {
    func onRtcConnectionStateChange(state connectionState:String)
    func onRtcConnectionError(error errorInfo:[AnyHashable : Any])
    func onRtcSessionStatus(status sessionStatus:String,id callId:String)
    func onRtcSessionError(error errorInfo:[AnyHashable : Any],id callId:String)
    func onNotification(notification notfyData: [AnyHashable : Any])
}
