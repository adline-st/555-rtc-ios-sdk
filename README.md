 # Overview


555 RTC SDK provides APIs which allow iOS developers to create apps with different features like Audio/Video/Pstn call, 
conference call, chat, screen sharing, etc. The services offered by SDK are supported by 555 platform's reliable and scalable infrastructure designed to handle a large number of calls. 

Below steps allow the user to make an end-to-end PSTN call. This includes user authentication, login, notification creating media connection.  

1) Follow [installation guide](https://github.com/555platform/555-rtc-ios-sdk/wiki/Installation-Guide) to integrate SDK into your project.
2) From [555 portal](https://developer.555.comcast.com/), get an API key and access token.
3) Complete [login](https://github.com/555platform/555-rtc-ios-sdk/wiki/User-Authentication) to get the JWT which is needed to access any SDK or backend APIs.
4) Follow [notification guide](https://github.com/555platform/555-rtc-ios-sdk/wiki/Notification-Guide) to add support for APNS notification in your app.
4) Use below SDK API document to make incoming/outgoing PSTN calls.

  
# Usage

## PSTN Call

This document list down all the SDK API calls and their usage for making incoming/outgoing PSTN calls and using advance call features like call hold/unhold, mute/unmute, etc.  

Before initiating or accepting a PSTN call, make sure you have [logged in](https://github.com/555platform/555-rtc-ios-sdk/wiki/User-Authentication) to 555 platform. 

## SDK initialization

Below API initializes and sets the context for the SDK. It is advisable to call this API at the launch of the application.

```swift
Rtc555Sdk.initializeLibrary()
```

## Adding SDK configuration.

To make PSTN/Voice related API call, SDK should have below mentioned mandatory configuration data to 
establish a connection with the 555 platform backend.

```swift
let config:Rtc555Config = Rtc555Sdk.sharedInstance.getConfig()
config.phoneNumber =  // Source Telephone Number
config.routingId =  // 555 platform login response will provide unique id for the logged in user.
config.url =  // Event manager URL
config.token =  /// 555 platform login response will provide unique jwt token for the logged in user.

Rtc555Sdk.setConfig(config: config)

```
  
## Initiating an Outgoing Call

To make outgoing calls, pass destination telephone number, notification payload to *dial* api. Notification payload contains two fields called *data* and *notification*. Users can add any custom data as part *data* key which will get delivered to the remote end as part of the notification. The notification key contains the notification type and federation type of the notification (Both values are already populated in the below example). 


*dial* API returns enum Result. A successful dial API call with return call Id, failure case return error code and the reason for the error.

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


***Note:** Please make sure to add mandatory microphone permission in your info.plist file before accessing Dial/Accept call APIs to allow SDK to create local audio stream*

## Accept/Reject an Incoming Call

When user receives an incoming PSTN call alert, the user can choose to:
  -   [Accept call](#accept-call)
  -   [Reject call](#reject-call)

### Accept Call

If the user wants to accept the incoming PSTN call request, use *accept* API and pass the notification payload received from incoming APNS push notification.
*accept* API returns enum result. Success case of result will return call id and failure case return error code and reason for the error.

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

 Users can reject an incoming call using *reject* API. Pass notification payload received in incoming APNs push notification.

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


 |Parameters| |
 |------|-----|
 |trace_id|trace id|
 |room_id|Room name that needs to be joined which is recieved in notification payload.|
 |room_token|Room token which is recieved in notification payload.|
 |room_token_expiry_time|Room token expiry time retrieved from notification payload.|
 |to_routing_id|toRoutingId |
 |rtc_server|RTC server URL extracted from notification payload.|


## End an Active Call

User need to *hangup* API to end the active call.

```swift
Rtc555Voice.hangup(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

## Clean up the session.

Invoke below API in Rtc555Sdk to release all the resources used by SDK. This call also allows  client to disconect with 555 platform backend. It is advisable for app developer to call this API if app goes to background or kill state. 
 
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

This API call allows user to hold the ongoing call. Both caller and callee won't able to hear to each other after invoking this call.

```swift
Rtc555Voice.hold(callId: callIds)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Unhold Call

This API call allows user to un-hold the already holded call. Both caller and callee will to hear to each other after invoking this call.

```swift
Rtc555Voice.unhold(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Mute Local Audio
This API call allows user to mute it's audio in the call. 

```swift
Rtc555Voice.mute(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|

### Unmute Local Audio
This API callow user to un-mute it's audio in the call.

```swift
Rtc555Voice.unmute(callId: callId)
```

|Parameters| |
|-------|---|
|callId| callId is unique id for this call which was returned from dial/accept API|


## Audio Call Delegates


In order to get call status or error report duing the call, impletement Rtc555SdkDelegate protocol and initialize the voice delegate as below

```swift
Rtc555Voice.rtcDelegate = self
```

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



### onNotification

In case you want to use XMPP notification (Instead of APNS), using this optional delegate call. Client need to be connected to 555 backend in order to avail this notification callback.

```swift
    @objc func onNotification(notification notificationData: [AnyHashable : Any]) {

    }
```

 |Parameters| |
 |-------|----|
 |notificationData| notification payload for incoming notification|

