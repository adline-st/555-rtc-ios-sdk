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
       
  }
    
  func callMethod(_ apiname: String, _ args:[Any]){
       bridge?.enqueueJSCall("RtcSdk", method: apiname, args: args, completion: nil)
  }
    
}
