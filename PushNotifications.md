# Usage of push notifications

There is no single reliable way on iOS to periodically check for possible exposures in the background. Therefore, NotifyMe uses multiple mechanisms to trigger the check in the background:
* On devices running iOS 13 and above, Apple's [BackgroundTasks framework](https://developer.apple.com/documentation/backgroundtasks) is used. It allows to schedule tasks that will opportunistically be executed in the background, depending on various conditions such as frequency of app usage, battery level and network connectivity. There is no guarantee that tasks will reliably be scheduled. To maximize chances of execution, NotifyMe schedules both [BGProcessingTasks](https://developer.apple.com/documentation/backgroundtasks/bgprocessingtask) *and* [BGAppRefreshTasks](https://developer.apple.com/documentation/backgroundtasks/bgapprefreshtask), both of which trigger a sync with the server to download new data and locally check for new exposures.
* On devices running iOS 12 and below, the BackgroundTasks framework is not available, so Apple's previous, now deprecated, [background task API](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623125-application) is used. The underlying mechanism is the same as for the BackgroundTasks framework, but there are less configuration options and therefore even less guarantees to be executed regularly.
* Since both of these mechanisms depend heavily on a user's general device usage, meaning that NotifyMe might be competing with many other often-used apps for background execution time, it cannot be guaranteed that a sync will be triggered often enough to notify the user of a possible exposure within reasonable time. This is why a third, more reliable mechanism of triggering syncs has been introduced: silent pushes. Their usage and privacy implications are explained in more detail below

### Apple Push Notification Service
The architecture overview of Apple's Push Notification service can be found [here](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html#//apple_ref/doc/uid/TP40008194-CH8-SW1). As soon as necessary, each app can ask the system to be registered with APNs. It will receive an app-specific push token that it can then send to the app backend, together with a unique app-instance token that is randomly generated upon app installation, identifying a specific app instance. The backend can then use the push token to send push payloads to APNs, which in turn will send a push notification to the registered device.

### What data is sent via push
NotifyMe uses pushes as a mechanism to trigger a sync request, not to actually send new data. Therefore, the payload of the push is empty, and the push is configured to be "silent", meaning that it is delivered to the device without triggering a visible or audible notification. Upon receiving the push, the app downloads new data from the server and checks for possible exposures. If it finds any, it then triggers a new, local notification that alerts the user and prompts them to open the app.

A push payload looks like this:
```
{
    "aps" : {
        "content-available": 1
    }
}
```

## Data stored on NotifyMe servers
For each device that registers for push notifications, the NotifyMe backend stores the push token used to authenticate with APNs, together with the app-instance token. The app-instance token is needed so apps can update their push token in case Apple for some reason invalidates the push token and issues a new one, or possibly also to unregister from push notifications.
