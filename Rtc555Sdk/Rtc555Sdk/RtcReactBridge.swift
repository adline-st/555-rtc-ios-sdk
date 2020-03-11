//
//  RtcReactBridgewrapper.swift
//  RtcReactSdk
//
//  Created by Girish on 21/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import React

class RtcReactBridge: NSObject {
  var bridge: RCTBridge?
  var reactMethodArray = [[String: Any]]()
  var isBridgeInitialized = false
  static let sharedInstance = RtcReactBridge()
  
  func createBridge() {
  
    RCTSetLogThreshold(.info)
   
    if bridge == nil {
        let bundle = Bundle(for: RtcReactBridge.self)
        let bundleUrl  = bundle.url(forResource: "main", withExtension: "jsbundle")
        bridge = RCTBridge.init(bundleURL: bundleUrl, moduleProvider: nil, launchOptions: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(javascriptDidLoad(notification:)), name: .RCTJavaScriptDidLoad, object: nil)
     }
  }
 
    
  @objc func javascriptDidLoad(notification: NSNotification){
    
    isBridgeInitialized = true
    
    if(!reactMethodArray.isEmpty){
        for item in reactMethodArray {
            for (key, value) in item {
                 callMethod(key, value as! [Any])
            }
        }
        reactMethodArray.removeAll()
    }
  }
    
  func callMethod(_ apiname: String, _ args:[Any]){
    
    if(isBridgeInitialized){
       bridge?.enqueueJSCall("RtcSdk", method: apiname, args: args, completion: nil)
    }else{
        let dict:[String:Any] = [apiname:args]
        reactMethodArray.append(dict)
    }
       
  }

}
