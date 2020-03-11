 # Overview


555 RTC SDK provides APIs which allow iOS developers to create apps with different features like audio/video/pstn call, 
conference call, chat, screen sharing etc. The services offered by SDK are supported by 555 platform's reliable and scalable infrastructure designed to handle a large number of calls. 

Below steps allow user to make an end-to-end PSTN call. This includes user authentication, login and creating media connection.  

1) Follow [installation guide](https://github.com/555platform/555-rtc-ios-sdk/wiki/Installation-Guide) to integrate SDK into your project.
2) From [555 portal](https://developer.555.comcast.com/), get API key and access token.
3) Complete [login](https://github.com/555platform/555-rtc-ios-sdk/wiki/User-Authentication) to get the JWT which is needed to access any SDK or backend APIs.
4) Follow [notification guide](https://github.com/555platform/555-rtc-ios-sdk/wiki/Notification-Guide) to add support for APNS notification in your app.

  
# Usage

## PSTN Call

This document list down all the SDK API calls and their usage for doing incoming/outgoing PSTN calls and using some advance call features like call hold/unhold, mute/unmute etc.  

Before initiating or accepting a PSTN call, make sure you have [logged in](https://github.com/555platform/555-rtc-ios-sdk/wiki/User-Authentication) to 555 platform. 

## SDK initialization

Below API initalizes the SDK and set the context for SDK. It is advisable to call this API at the launch of the application.

```swift
Rtc555Sdk.initializeLibrary()
```

## Adding SDK configuration.

In order to make any PSTN/Voice related API call, SDK should have below mentioned mandatory configuration data in order to 
establish the connection with the 555 platform.

```swift
let config:Rtc555Config = Rtc555Sdk.sharedInstance.getConfig()
config.phoneNumber =  // Source Telephone Number
config.routingId =  // Unique id once login to 555 authmanager
config.url =  // Event manager URL
config.token =  /// JWT token 

Rtc555Sdk.setConfig(config: config)

```
  
## Initiating an Outgoing Call

To make outgoing calls, pass destination Telephone number, notificationPayload to *dial* api . 

As shown below,in order to get callbacks during call, set delegate property of Rtc555Voice class which is of type Rtc555SdkDelegate to self and implement callback methods of Rtc55Sdkdelegate by extending it in the class.

```swift
Rtc555Voice.rtcDelegate = self
```

*dial* API returns enum result. Success case of result will return callid .failure case return error information.

```swift
Rtc555Voice.dial( number: targetTelephoneNumber, notificationPayload:buildNotificationPayload()){ result in
           switch result {
           case .success(let callId):
               print("Dial was success and callid is = \(callId)")
           case .failure(let error):
            print(error)
           }
       }
       
 //build notification  payload
 private func buildNotificationPayload() -> String{
     let data = ["cname" : <Source Telephone Number>,    // source telephone number
                 "cid" : <Source Telephone Number>,      // source telephone number
                 "tar" : <Target Telephone Number>]    // target telephone number

    let notificationPayload = ["type" : "pstn",
                               "topic": "federation/pstn"]


    let userData = ["data": data, "notification" : notificationPayload]

    do{
        let jsonData = try JSONSerialization.data(withJSONObject: userData, options: JSONSerialization.WritingOptions.prettyPrinted)

        return String(data: jsonData, encoding: String.Encoding.utf8)!
    }catch {
        Log.e("Error creating notification payload")
    }
    return " "
}
       
```

| Parameters          | Type   | Description           |
|-------------------|--------|-----------------------|
| targetTelephoneNumber         | string | Contains target 10 digit telephone number|
| notificationPayload             | dictionary | cname, cid, targtid,type,topic             |

Below is the Notification payload need to be build for outgoing notificationData:


| Parameters          | Type   | Description           |
|-------------------|--------|-----------------------|
| data              | dictionary                                                               |  <ul> <li>cname</li><li>cid</li><li>targetId</li></ul> |
| notification | dictionary     |   <ul> <li>type:"pstn"</li><li>topic :"federation/pstn" </li></ul>    |  


***Note:** When using the Rtc555Voice class, it will ask user to allow to use microphone while running. Please make sure access is allowed. When the stream is started, it won't immediately access the microphone, it will use the microphone only when the call is connected. Hence the pop-up for mic access will be presented to the user at a later point of time.*

## Accept/Reject an Incoming Call

When user receives an incoming PSTN call alert, the user can choose to:
  -   [Accept call](#accept-call)
  -   [Reject call](#reject-call)

### Accept Call

If the user wants to accept the incoming PSTN call request, use *accept* API and pass the notification payload received from incoming notification request.
*accept* API returns enum result. Success case of result will return callid and failure case return error information.

```swift
Rtc555Voice.rtcDelegate = self
Rtc555Voice.accept(notificationData: notificationdata){ result in
            switch result {
            case .success(let callId):
                print("callId :: \(callId)")
                 self.callId = callId
            case .failure(let error):
             print(error)
            }
        }
```
Pass notification payload received at incoming notification.

 |Parameters| |
 |------|-----|
 |trace_id|trace id|
 |room_id|Room name that needs to be joined which is recieved in notification payload.|
 |room_token|Room token which is recieved in notification payload.|
 |room_token_expiry_time|Room token expiry time retrieved from notification payload.|
 |to_routing_id|toRoutingId |
 |rtc_server|RTC server URL extracted from notification payload.|

### Reject Call

  User can reject an incoming call notification. Rtc555 IOS SDK provides ***reject()*** API for this feature.

```swift
Rtc555Voice.reject(notificationData: notificationdata){ result in
            switch result {
            case .success(let callId):
                print("Reject was success  = \(callId)")
                 self.callId = result
            case .failure(let error):
             print(error)
            }
        }
```
Pass notification payload received at incoming notification.

 |Parameters| |
 |------|-----|
 |trace_id|trace id|
 |room_id|Room name that needs to be joined which is recieved in notification payload.|
 |room_token|Room token which is recieved in notification payload.|
 |room_token_expiry_time|Room token expiry time retrieved from notification payload.|
 |to_routing_id|toRoutingId |
 |rtc_server|RTC server URL extracted from notification payload.|


## End an Active Call

On end call, close audio session by invoking **hangup** API in Rtc555Voice.

```swift
Rtc555Voice.hangup(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

## Clean up the session.

Invoke **cleanup** API in Rtc555Sdk to release all the resouces used by SDK. It is advisable for app developer to call this api if goes to background or user kill the app.
 
```swift
Rtc555Sdk.cleanup()
```

## On-call Features

Features offered by iOS SDK for PSTN call are:
- [Hold Call](#hold-call)
- [Unhold Call](#unhold-call)
- [Mute Local Audio](#mute-local-audio)
- [Unmute Local Audio](#unmute-local-audio)
- [Merge Two Calls](#merge-two-calls)
- [Send DTMF Tone](#send-dtmf-tone)

### Hold Call
Either caller or callee can hold a call. When the call is on hold neither of the users will be able to send or receive audio streams. iOS SDK provides the ***hold()*** API in *Rtc555Voice* class to hold an active call.

```swift
Rtc555Voice.hold(callId: callIds)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Unhold Call
The user who kept the call on hold can unhold the call and the both the users will be able to send & receive audio streams. iOS SDK provides ***unhold()*** API in *Rtc555Voice* class to unhold a call which is already on hold.

```swift
Rtc555Voice.unhold(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Mute Local Audio
An user can mute his end to stop sharing audio from their end, but at the same time they can receive audio from other end. iOS SDK provides ***mute()*** API in *Rtc555Voice* class for the same.

```swift
Rtc555Voice.mute(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Unmute Local Audio
If an user is on mute he can unmute the call and resume conversation. ***unmute()*** API in *Rtc555Voice* class is used for this feature.

```swift
Rtc555Voice.unmute(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Merge Two Calls

  In this feature, active call is kept on hold to make/join a new call, then both the calls are merged to create a conference call.  Following method is provided by SDK in ***Rtc555Voice*** class for this feature.

```swift
    Rtc555Voice.merge(callId: heldCallId)
```

| Parameters |   |
|------------|---|
| heldCallId | unique id for the first session|


## Audio Call Related Callbacks

### onStatus

This callback gets invoked when we receives status of ongoing PSTN call.

```swift
    func onStatus(status callStatus: CallStatus,id callId:String) {
         
     }
```

|Parameters| |
|-------|----|
|status| status of ongoing call|
|callId| callId received from backend|

Status:
- initializing&emsp;&emsp;&emsp;- &emsp; When the call is initializing
- connecting&nbsp;&emsp;&emsp;- &emsp; When the call is connecting
- connected&nbsp;&emsp;&emsp; - &emsp; When the call is connected
- disconnected&emsp;&nbsp;- &emsp; When the call is disconnected
- hold&emsp;&emsp;&emsp;&emsp;&ensp;&ensp; - &emsp; When the call is hold

### onError

This callback gets invoked when we receives error from ongoing PSTN call.

```swift
    func onError(error errorInfo: Error,id callId:String) {
         
     }
```

|Parameters| |
|-------|----|
|errorInfo| error object consists of error code and error message|
|callId| callId received from backend|

### onCallMerged

This callback gets invoked when merging an active session with the held session in PSTN call, i.e conferencing. This callback is optional.

```swift
    @objc optional func onCallMerged(id callId:String) {
     }
```

|Parameters| |
|-------|----|
|callId| Trace id|


### onNotification

This method is called to indicate the incoming notification .This callback is optional.

```swift
    @objc optional func onNotification(notification notificationData: [AnyHashable : Any]) {

    }
```

 |Parameters| |
 |-------|----|
 |notificationData| notification payload for incoming notification|

