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

        setAppearance()

        clearBadge()

        initializeWindow()

        setupBackgroundTasks()

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        clearBadge()
    }

    private func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKey()
        window?.rootViewController = UINavigationController(rootViewController: HomescreenViewController())
        window?.makeKeyAndVisible()
    }

    private func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // MARK: - Appearance

    private func setAppearance() {
        let switchAppearance = UISwitch.appearance()
        switchAppearance.tintColor = .ns_purple
        switchAppearance.onTintColor = .ns_purple
    }

    // MARK: - Background refresh

    private let minimumBackgroundFetchInterval: TimeInterval = .hour * 4

    private func setupBackgroundTasks() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(minimumBackgroundFetchInterval)
    }

    func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ProblematicEventsManager.shared.sync(isBackgroundFetch: true) { newData, needsNotification in
            if !newData {
                completionHandler(.noData)
            } else {
                if needsNotification {
                    NotificationManager.shared.showExposureNotification()
                }
                completionHandler(.newData)
            }
        }
    }

    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let urlString = userActivity.webpageURL?.absoluteString else {
            return false
        }

        if window == nil {
            initializeWindow()
        }

        switch UIStateManager.shared.uiState.checkInState {
        case .checkIn:
            let vc = ErrorViewController(errorModel: ErrorViewModel(title: "error_title".ub_localized, text: "error_already_checked_in".ub_localized, buttonText: "ok_button".ub_localized))
            window?.rootViewController?.present(vc, animated: true, completion: nil)
        case .noCheckIn:
            // Try checkin
            let result = CrowdNotifier.getVenueInfo(qrCode: urlString, baseUrl: Environment.current.qrGenBaseUrl)

            switch result {
            case let .success(info):
                let vc = CheckInConfirmViewController(qrCode: urlString, venueInfo: info)
                window?.rootViewController?.present(vc, animated: true, completion: nil)
            case .failure:
                let vc = ErrorViewController(errorModel: ErrorViewModel(title: "error_title".ub_localized, text: "qrscanner_error".ub_localized, buttonText: "ok_button".ub_localized))
                window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }

        return true
    }
}
