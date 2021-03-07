# Usage of push notifications

NotifyMe must notify users quickly and reliably. To compute this information, the app must regularly download any new keys that have been published on the backend server. NotifyMe runs these downloads in the background. However, background processes are unreliable on iOS. They might be delayed by more than a day, or not run at all. To ensure timely notification, NotifyMe additionally uses silent pushes from the server to ensure that the download happens.

In this document we describe how NotifyMe currently employs background processes and how it uses server-side pushes to complement these.

## Background processing on iOS

NotifyMe uses two different mechanisms to schedule background processes depending on the iOS version:

* On devices running iOS 13 and above, Apple's [BackgroundTasks framework](https://developer.apple.com/documentation/backgroundtasks) is used. It allows to schedule tasks that will opportunistically be executed in the background, depending on various conditions such as frequency of app usage, battery level and network connectivity. There is no guarantee that tasks will reliably be scheduled. To maximize chances of execution, NotifyMe schedules both [BGProcessingTasks](https://developer.apple.com/documentation/backgroundtasks/bgprocessingtask) *and* [BGAppRefreshTasks](https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtask), both of which trigger a sync with the server to download new data and locally check for new exposures.
* On devices running iOS 12 and below, the BackgroundTasks framework is not available. We then use Apple's previous, now deprecated, [background task API](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623125-application). The underlying mechanism is the same as for the BackgroundTasks framework, but there are less configuration options and therefore even less guarantees to be executed regularly.

These two mechanisms depend heavily on a user's general device usage. NotifyMe might be competing with many other often-used apps for background execution time. Therefore, these frameworks on their own give no guarantee that a sync with the server will be triggered often enough to notify the user within reasonable time.

## Silent Pushes
To address the challenge with unreliable background tasks, NotifyMe uses a third, more reliable mechanism of triggering syncs: silent pushes. Push messages are sent by the server and will always result in processing time being allocated to the app. Thereby ensuring that the app will always perform a timely sync with the server and can check for notifications.

### Apple Push Notification Service
Apple provides the Apple Push Notification Service to send messages to iPhones. The architecture overview of Apple's Push Notification service can be found [here](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html#//apple_ref/doc/uid/TP40008194-CH8-SW1). Apps can ask the system to be registered with APNs. Once an app does, it receives an app-specific push token that it can then send to the app backend server. Usually, apps also send a unique app-instance token that is randomly generated upon app installation, identifying a specific app instance. The backend can then use the push token to send push payloads to APNs, which in turn will send a push notification to the registered device.

### What data is sent via push
NotifyMe uses pushes just as a mechanism to trigger a sync request. _NotifyMe pushes do not to actually send  data_.  The payload of the push is empty. Moreover, the push is configured to be "silent", meaning that it is delivered to the device without triggering a visible or audible notification. Upon receiving the push, the app downloads new data from the server and checks for possible exposures. If it finds any, it then triggers a new, local notification that alerts the user and prompts them to open the app.

A push payload looks like this:
```
{
    "aps" : {
        "content-available": 1
    }
}
```

## Data stored on NotifyMe servers
For each device that registers for push notifications, the NotifyMe backend stores the push token used to authenticate with APNs. The server uses the push token to send push notifications to the app.

For each push token, the server also stores a random app-instance token. This token is also stored inside the app. No other apps have access to this app-instance token. The app-instance token is used only for updating or deleting the push token associated with an app. Updates are needed when Apple for some reason invalidates the old push token. The app then sends the new push token and the app-instance token to server. Finally, the app-instance token is used to unregister the app from push notifications.

The app-instance token is not communicated to the backend server at any other time  and can therefore not be used to track users. No other data is stored related to apps and users on the NotifyMe servers.
