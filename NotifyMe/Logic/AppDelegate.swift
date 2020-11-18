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

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKey()
        window?.rootViewController = UINavigationController(rootViewController: HomescreenViewController())
        window?.makeKeyAndVisible()

        setupBackgroundTasks()

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        clearBadge()
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

    private let minimumBackgroundFetchInterval: TimeInterval = UIApplication.backgroundFetchIntervalMinimum

    private func setupBackgroundTasks() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(minimumBackgroundFetchInterval)
    }

    func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
                completionHandler(.newData)
            }
        }
    }
}
