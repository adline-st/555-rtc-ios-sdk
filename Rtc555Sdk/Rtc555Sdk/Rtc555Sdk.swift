//
//  RtcReactSdk.swift
//  RtcReactSdk
//
//  Created by Admin on 13/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import React

public class Rtc555Sdk {
    
    public static let sharedInstance = Rtc555Sdk()
    var config: Rtc555Config?
    init(){}
   
    public func getConfig() -> Rtc555Config{
        if config == nil {
            config = Rtc555Config()
        }
        return config!
    }
   
    public static func setConfig(config Config:Rtc555Config){
        var config : [String : String] = [:]
        config["sourceTelephonenum"] = Config.phoneNumber
        config["routingId"] = Config.routingId
        config["eventManagerUrl"] = Config.url
        config["token"] = Config.token
         
        let args = [config]
        RtcReactBridge.sharedInstance.callMethod("setConfig",args)
    }
      
    public static func initializeLibrary() {
        RtcReactBridge.sharedInstance.createBridge()
    }
    
    public static func cleanup(){
        let args:[String] = []
        RtcReactBridge.sharedInstance.callMethod("cleanup",args)
    }

}

public protocol Rtc555SdkDelegate {
    func onStatus(status callStatus:CallStatus,id callId:String)
    func onError(error errorInfo:Error,id callId:String)
    func onCallMerged(id callId:String)
    func onNotification(notification notificationData: [AnyHashable : Any])
}

extension  Rtc555SdkDelegate  {
    
    func onCallMerged(id callId:String){
        
    }
    
    func onNotification(notification notificationData: [AnyHashable : Any]){
       
    }
}
