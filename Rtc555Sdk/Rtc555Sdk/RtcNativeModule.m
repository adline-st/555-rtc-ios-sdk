//
//  RctNativeModule.m
//  example-rn-framework
//
//  Created by Harish Gupta on 12/2/19.
//  Copyright © 2019 Comcast. All rights reserved.
//

#import "RtcNativeModule.h"

@interface RCT_EXTERN_MODULE(RtcNativeBridge, NSObject)
RCT_EXTERN_METHOD(onRtcConnectionStateChange:(NSString)connectionState)
RCT_EXTERN_METHOD(onRtcConnectionError:(NSDictionary)errorInfo)
RCT_EXTERN_METHOD(onRtcSessionStatus:(NSString)status traceId:(NSString)trace)
RCT_EXTERN_METHOD(onRtcSessionError:(NSDictionary)errorInfo)
RCT_EXTERN_METHOD(onNotification:(NSDictionary)notification)
@end

@implementation RtcNativeModule

@end
