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

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        CrowdNotifier.initialize()

        setAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.makeKey()
        window?.rootViewController = UINavigationController(rootViewController: HomescreenViewController())
        window?.makeKeyAndVisible()

        return true
    }

    func setAppearance() {
        let switchApperence = UISwitch.appearance()
        switchApperence.tintColor = .ns_purple
        switchApperence.onTintColor = .ns_purple
    }
}
