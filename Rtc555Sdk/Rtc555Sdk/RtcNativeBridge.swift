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
public class RtcNativeBridge: NSObject {

    @objc public func onRtcConnectionStateChange(_ connectionState: NSString) {
        
        let userinfo = ["state":connectionState]
    
        NotificationCenter.default.post(name: Notification.Name("onConnectionStatus"), object: nil,userInfo: userinfo)
     }
    
    @objc public func onRtcConnectionError(_ errorInfo: NSDictionary) {
           
           let userinfo = ["error":errorInfo]
        
           NotificationCenter.default.post(name: Notification.Name("onConnectionError"), object: nil,userInfo: userinfo)
        }
    
    @objc public func onRtcSessionStatus(_ status: NSString,traceId trace: NSString) {
      
        let userinfo = ["status":status, "traceId":trace]
    
       NotificationCenter.default.post(name: Notification.Name("onSessionStatus"), object: nil,userInfo: userinfo)
    }
    
    @objc public func onRtcSessionError(_ errorInfo: NSDictionary,traceId trace: NSString ) {
       
       let userinfo = ["error":errorInfo, "traceId":trace]
    
       NotificationCenter.default.post(name: Notification.Name("onSessionError"), object: nil,userInfo: userinfo)
    }
    
    @objc public func onNotification(_ notification: NSDictionary) {
          
          let userinfo = ["info":notification]
       
          NotificationCenter.default.post(name: Notification.Name("onNotification"), object: nil,userInfo: userinfo)
       }
    
}
