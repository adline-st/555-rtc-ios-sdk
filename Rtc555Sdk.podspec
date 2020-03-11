#
# Be sure to run `pod lib lint Rtc555Sdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Rtc555Sdk'
  s.version          = '0.0.8'
  s.summary          = 'A short description of Rtc555Sdk.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Mobile SDK for Audio, Video and chat functionality. This SDK leverages Comcast 555 Platform.
  DESC
  s.homepage         = 'https://github.com/555platform/555-rtc-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'harishgupta01' => 'harish.28gupta@gmail.com' }
  s.source           = { :git => 'https://github.com/555platform/555-rtc-ios-sdk.git' , :tag => 'v0.0.8' }
  s.source_files = 'Rtc555Sdk/Rtc555Sdk/*'
  s.ios.deployment_target = '10.0'
  s.exclude_files = "Rtc555Sdk/Rtc555Sdk/*.plist"
  s.vendored_frameworks = 'Rtc555Sdk/Dependencies/CoreModules.framework' ,'Rtc555Sdk/Dependencies/cxxreact.framework' ,'Rtc555Sdk/Dependencies/DoubleConversion.framework' ,  'Rtc555Sdk/Dependencies/FBReactNativeSpec.framework', 'Rtc555Sdk/Dependencies/folly.framework' ,  'Rtc555Sdk/Dependencies/glog.framework' ,  'Rtc555Sdk/Dependencies/jsi.framework', 'Rtc555Sdk/Dependencies/jsinspector.framework' ,  'Rtc555Sdk/Dependencies/jsireact.framework',  'Rtc555Sdk/Dependencies/RCTActionSheet.framework', 'Rtc555Sdk/Dependencies/RCTAnimation.framework' ,  'Rtc555Sdk/Dependencies/RCTBlob.framework',  'Rtc555Sdk/Dependencies/RCTImage.framework', 'Rtc555Sdk/Dependencies/RCTLinking.framework' ,  'Rtc555Sdk/Dependencies/RCTNetwork.framework' ,  'Rtc555Sdk/Dependencies/RCTSettings.framework',  'Rtc555Sdk/Dependencies/RCTText.framework',  'Rtc555Sdk/Dependencies/RCTTypeSafety.framework',  'Rtc555Sdk/Dependencies/RCTVibration.framework',  'Rtc555Sdk/Dependencies/react_native_netinfo.framework',  'Rtc555Sdk/Dependencies/react_native_webrtc.framework',  'Rtc555Sdk/Dependencies/React.framework' ,'Rtc555Sdk/Dependencies/ReactCommon.framework','Rtc555Sdk/Dependencies/ReactNativeIncallManager.framework','Rtc555Sdk/Dependencies/RNCAsyncStorage.framework','Rtc555Sdk/Dependencies/RNDeviceInfo.framework','Rtc555Sdk/Dependencies/WebRTC.framework','Rtc555Sdk/Dependencies/yoga.framework','Rtc555Sdk/Dependencies/CoreModules.framework','Rtc555Sdk/Dependencies/DoubleConversion.framework','Rtc555Sdk/Dependencies/react_native_background_timer.framework'
	
   s.resource = 'Rtc555Sdk/main.jsbundle'

  other_frameworks =  ['CoreModules', 'cxxreact', 'DoubleConversion', 'FBReactNativeSpec', 'folly', 'glog', 'jsi', 'jsinspector', 'jsireact','RCTActionSheet', 'RCTAnimation', 'RCTBlob', 'RCTImage','RCTLinking','RCTSettings','RCTText','RCTTypeSafety','RCTVibration','react_native_netinfo','react_native_webrtc','React','ReactCommon','ReactNativeIncallManager','RNCAsyncStorage','RNDeviceInfo','WebRTC','yoga','CoreModules','DoubleConversion']
  
    other_ldflags = '$(inherited) -framework ' + other_frameworks.join(' -framework ') + 
      ' -lz -lstdc++'

    s.xcconfig     = {

      'OTHER_LDFLAGS[arch=arm64]'  => other_ldflags,
      'OTHER_LDFLAGS[arch=armv7]'  => other_ldflags,
      'OTHER_LDFLAGS[arch=armv7s]' => other_ldflags
    }
	
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'precompiled' do |lib|
  #lib.public_header_files = 'IrisRtcSdk/webrtc/header'
  #lib.header_mappings_dir = 'IrisRtcSdk/webrtc/header'
  #lib.source_files = 'IrisRtcSdk/webrtc/header/WebRTC/*', 'IrisRtcSdk/loggerSdk/header/*'
  #lib.preserve_paths = 'webrtc/libs/libwebrtc.a'
  lib.vendored_frameworks = 'Rtc555Sdk/Dependencies/cxxreact.framework' ,  'Rtc555Sdk/Dependencies/FBReactNativeSpec.framework', 'Rtc555Sdk/Dependencies/folly.framework' ,  'Rtc555Sdk/Dependencies/glog.framework' ,  'Rtc555Sdk/Dependencies/jsi.framework', 'Rtc555Sdk/Dependencies/jsinspector.framework' ,  'Rtc555Sdk/Dependencies/jsireact.framework',  'Rtc555Sdk/Dependencies/RCTActionSheet.framework', 'Rtc555Sdk/Dependencies/RCTAnimation.framework' ,  'Rtc555Sdk/Dependencies/RCTBlob.framework',  'Rtc555Sdk/Dependencies/RCTImage.framework', 'Rtc555Sdk/Dependencies/RCTLinking.framework' ,  'Rtc555Sdk/Dependencies/RCTNetwork.framework' ,  'Rtc555Sdk/Dependencies/RCTSettings.framework',  'Rtc555Sdk/Dependencies/RCTText.framework',  'Rtc555Sdk/Dependencies/RCTTypeSafety.framework',  'Rtc555Sdk/Dependencies/RCTVibration.framework',  'Rtc555Sdk/Dependencies/react_native_netinfo.framework',  'Rtc555Sdk/Dependencies/react_native_webrtc.framework',  'Rtc555Sdk/Dependencies/React.framework' ,'Rtc555Sdk/Dependencies/ReactCommon.framework' ,'Rtc555Sdk/Dependencies/ReactNativeIncallManager.framework','Rtc555Sdk/Dependencies/RNCAsyncStorage.framework','Rtc555Sdk/Dependencies/RNDeviceInfo.framework','Rtc555Sdk/Dependencies/yoga.framework','Rtc555Sdk/Dependencies/CoreModules.framework','Rtc555Sdk/Dependencies/DoubleConversion.framework','Rtc555Sdk/Dependencies/react_native_background_timer.framework'
  
  lib.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => "$(PLATFORM_DIR)/Developer/Library/Frameworks", 'OTHER_LDFLAGS' => "-ObjC",'ENABLE_BITCODE' => "NO"}
  end
  
end
