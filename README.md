<h1 align="center">NotifyMe for iOS</h1>
<br />
<div align="center">
  <img width="180" height="180" src="NotifyMe/Resources/Assets.xcassets/AppIcon.appiconset/appicon@1024x1024-60@3x.png" />
  <br />
  <a href="https://testflight.apple.com/join/OqONONgv" target="_blank">Download iOS App</a>
</div>
<br />
<div align="center">
    <!-- SPM -->
    <a href="https://github.com/apple/swift-package-manager">
      <img alt="Swift Package Manager"
      src="https://img.shields.io/badge/SPM-%E2%9C%93-brightgreen.svg?style=flat">
    </a>
    <!-- License -->
    <a href="https://github.com/UbiqueInnovation/notifyme-app-ios/blob/master/LICENSE">
      <img alt="License: MPL 2.0"
      src="https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg">
    </a>
</div>

## Introduction

The app is a decentralised check-in system for meetings and events. Users can check in to a venue by scanning a QR Code. The check in is stored locally and encrypted. In case one of the visitors tests positive subsequent to a gathering, all other participants can be easily informed via the app. The app uses the [CrowdNotifier SDK](https://github.com/CrowdNotifier/crowdnotifier-sdk-ios) based on the [CrowdNotifier White Paper](https://github.com/CrowdNotifier/documents) by Wouter Lueks (EPFL) et al. The app design, UX and implementation was done by [Ubique](https://ubique.ch/). More information can be found [here](https://notify-me.ch).


## Repositories
* Android SDK: [crowdnotifier-sdk-android](https://github.com/CrowdNotifier/crowdnotifier-sdk-android)
* iOS SDK: [crowdnotifier-sdk-ios](https://github.com/CrowdNotifier/crowdnotifier-sdk-ios)
* TypeScript Reference Implementation: [crowdnotifier-ts](https://github.com/CrowdNotifier/crowdnotifier-ts)
* Android Demo App: [notifyme-app-android](https://github.com/notifyme-app/notifyme-app-android)
* iOS Demo App: [notifyme-app-ios](https://github.com/notifyme-app/notifyme-app-ios)
* Backend SDK: [notifyme-sdk-backend](https://github.com/notifyme-app/notifyme-sdk-backend)
* Web Apps: [notifyme-webpages](https://github.com/notifyme-app/notifyme-webpages)

## Work in Progress
The NotifyMe App for iOS contains alpha-quality code only and is not yet complete. It has not yet been reviewed or audited for security and compatibility. We are both continuing the development and have started a security review. This project is truly open-source and we welcome any feedback on the code regarding both the implementation and security aspects.
This repository contains the open prototype Application, so please focus your feedback for this repository on implementation issues.

## Further Documentation
The full set of documents for CrowdNotifier is at https://github.com/CrowdNotifier/documents. Please refer to the technical documents and whitepapers for a description of the implementation.

## Installation and Building

### Direct installation
The application can be downloaded and installed from TestFlight using this [link](https://testflight.apple.com/join/OqONONgv).

### Building locally
The project should be opened with Xcode 12.0 or newer. Dependencies are managed with [Swift Package Manager](https://swift.org/package-manager); no further setup is needed.

### Provisioning
The project is configured for a specific provisioning profile. To install the app on your own device, you will have to update the settings using your own provisioning profile.


## License
This project is licensed under the terms of the MPL 2 license. See the [LICENSE](LICENSE) file.
