//
//  Rtc555Voice.swift
//  Rtc555Sdk
//
//  Created by Girish on 05/03/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
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

public class Rtc555Voice: NSObject {
    
    static var callId:String?
    public static var rtcDelegate : Rtc555SdkDelegate!
    static var isCallSuccess:Bool?
    static var isCallFailed:Bool?
    static var sessionError:Error?
    
    
    public static func dial(targetTelephoneNumber targetNumber:String,notificationPayload payload:String, completion: @escaping (Result<String, Error>) -> Void) {
        
       let args = [targetNumber,payload] as [Any]
       RtcReactBridge.sharedInstance.callMethod("dial",args)

       Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
           var result: Result<String, Error>

           if Rtc555Voice.isCallSuccess ?? false{
              Rtc555Voice.isCallSuccess = false
              result = .success(Rtc555Voice.self.callId!)
              completion(result)
              timer.invalidate()
            }else if Rtc555Voice.isCallFailed ?? false{
              Rtc555Voice.isCallFailed = false
              result = .failure(Rtc555Voice.self.sessionError!)
              completion(result)
              timer.invalidate()
            }
       }
    }
    
    public static func accept(notificationData notification:[AnyHashable : Any],completion: @escaping (Result<String, Error>) -> Void) {

        let args = [notification] as [Any]
        RtcReactBridge.sharedInstance.callMethod("accept",args)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            var result: Result<String, Error>
            print("running timer")
            if Rtc555Voice.isCallSuccess ?? false{
               Rtc555Voice.isCallSuccess = false
               result = .success(Rtc555Voice.self.callId!)
               completion(result)
               timer.invalidate()
             }else if Rtc555Voice.isCallFailed ?? false{
               Rtc555Voice.isCallFailed = false
               result = .failure(Rtc555Voice.self.sessionError!)
               completion(result)
               timer.invalidate()
             }
         }
    }
    
    public static func reject(notificationData notification:[AnyHashable : Any],completion: @escaping (Result<String, Error>) -> Void) {
         let args = [notification]
         RtcReactBridge.sharedInstance.callMethod("reject",args)
    
         Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            var result: Result<String, Error>
            print("running timer")
            if Rtc555Voice.isCallSuccess ?? false{
               Rtc555Voice.isCallSuccess = false
               result = .success(Rtc555Voice.self.callId!)
               completion(result)
               timer.invalidate()
           }else if Rtc555Voice.isCallFailed ?? false{
               Rtc555Voice.isCallFailed = false
               result = .failure(Rtc555Voice.self.sessionError!)
               completion(result)
               timer.invalidate()
           }
        }
    }
        
    public static func hangup(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("hangup",args)
    }
    
    public static func hold(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("hold",args)
    }
    
    public static func unhold(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("unhold",args)
    }
    
    public static func mute(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("mute",args)
    }
    
    public static func unmute(callId callid:String) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("unmute",args)
    }
    
    public static func merge(callId callid:Any) {
           let args = [callid]
           RtcReactBridge.sharedInstance.callMethod("merge",args)
    }
    
    public static func sendDTMF(dtmfTone tone:DtmfInputType) {
           let args = [tone.rawValue]
           RtcReactBridge.sharedInstance.callMethod("sendDTMF",args)
    }
    


}
