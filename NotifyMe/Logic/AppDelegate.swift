/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import CrowdNotifierSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?

    @UBUserDefault(key: "ch.notify-me.isFirstRun", defaultValue: true)
    private var isFirstRun: Bool

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CrowdNotifier.initialize()

        if isFirstRun {
            Keychain().deleteAll()
            isFirstRun = false
        }

        setupNotificationDelegate()

        setAppearance()

        clearBadge()

        initializeWindow()

        setupBackgroundTasks()
        startForceUpdateCheck()

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        clearBadge()

        ProblematicEventsManager.shared.sync { _, _ in }

        NotificationManager.shared.checkAuthorization()
        NotificationManager.shared.resetBackgroundTaskWarningTriggers()

        startForceUpdateCheck()
    }

    private func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKey()

        let vc = HomescreenViewController()

        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()

        if !UserStorage.shared.hasCompletedOnboarding {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            window?.rootViewController?.present(onboardingViewController, animated: false)
        }
    }

    private func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    private func setupNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().setNotificationCategories(NotificationManager.shared.notificationCategories)
    }

    // MARK: - Appearance

    private func setAppearance() {
        let switchAppearance = UISwitch.appearance()
        switchAppearance.tintColor = .ns_purple
        switchAppearance.onTintColor = .ns_purple
    }

    // MARK: - Background refresh

    private let minimumBackgroundFetchInterval: TimeInterval = .hour * 3
    private var backgroundTask = UIBackgroundTaskIdentifier.invalid

    private func setupBackgroundTasks() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(minimumBackgroundFetchInterval)
    }

    func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if backgroundTask == .invalid {
            backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
                guard let self = self else {
                    return
                }

                if self.backgroundTask != .invalid {
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                    self.backgroundTask = .invalid
                }
            }
        }

        #if DEBUG || RELEASE_DEV
            NotificationManager.shared.showDebugNotification(title: "Background fetch started", body: "Time: \(Date())")
        #endif
        ProblematicEventsManager.shared.sync(isBackgroundFetch: true) { newData, needsNotification in
            #if DEBUG || RELEASE_DEV
                NotificationManager.shared.showDebugNotification(title: "Sync completed", body: "Time: \(Date()), newData: \(newData), needsNotification: \(needsNotification)")
            #endif
            if !newData {
                completionHandler(.noData)
            } else {
                if needsNotification {
                    NotificationManager.shared.showExposureNotification()
                }

                // data are updated -> reschedule background task warning triggers
                NotificationManager.shared.resetBackgroundTaskWarningTriggers()

                completionHandler(.newData)
            }

            if self.backgroundTask != .invalid {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }
        }
    }

    // MARK: - Force update

    private func startForceUpdateCheck() {
        ConfigManager().startConfigRequest(window: window)
    }

    // MARK: - Universal links

    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let urlString = userActivity.webpageURL?.absoluteString else {
            return false
        }

        if window == nil {
            initializeWindow()
        }

        if !UserStorage.shared.hasCompletedOnboarding {
            return true
        }

        switch UIStateManager.shared.uiState.checkInState {
        case .checkIn:
            let vc = ErrorViewController(errorModel: .alreadyCheckedIn)
            window?.rootViewController?.present(vc, animated: true, completion: nil)
        case .noCheckIn:
            // Try checkin
            let result = CrowdNotifier.getVenueInfo(qrCode: urlString, baseUrl: Environment.current.qrGenBaseUrl)

            switch result {
            case let .success(info):
                let vc = CheckInConfirmViewController(qrCode: urlString, venueInfo: info)
                window?.rootViewController?.present(vc, animated: true, completion: nil)
            case let .failure(failure):
                let vc = ErrorViewController(errorModel: failure.errorViewModel)
                window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }

        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        handleNotification(notification)
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(response.notification)
        completionHandler()
    }

    private func handleNotification(_ notification: UNNotification) {
        let category = notification.request.content.categoryIdentifier

        if category == NotificationType.exposure {
            switch UIStateManager.shared.uiState.exposureState {
            case let .exposure(exposures, _):
                guard let newest = exposures.last else {
                    return
                }

                if window == nil {
                    initializeWindow()
                }
                let vc = ModalReportViewController(exposure: newest)
                window?.rootViewController?.present(vc, animated: true, completion: nil)

            case .noExposure:
                break
            }
        }
    }
}
