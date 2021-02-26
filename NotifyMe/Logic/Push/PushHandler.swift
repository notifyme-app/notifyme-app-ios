//
/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation

class PushHandler: UBPushHandler {
    override func showInAppPushDetails(for notification: UBPushNotification) {
        guard let identifier = notification.categoryIdentifier, let category = NotificationType(rawValue: identifier) else { return }

        (UIApplication.shared.delegate as? AppDelegate)?.handleNotification(type: category)
    }

    override func showInAppPushAlert(withTitle _: String, proposedMessage _: String, notification: UBPushNotification) {
        guard let identifier = notification.categoryIdentifier, let category = NotificationType(rawValue: identifier) else { return }

        (UIApplication.shared.delegate as? AppDelegate)?.handleNotification(type: category)
    }

    override func updateLocalData(withSilent _: Bool, remoteNotification _: UBPushNotification) {
        #if DEBUG || RELEASE_DEV
            NotificationManager.shared.showDebugNotification(title: "[PushHandler] Background fetch started", body: "Time: \(Date())")
        #endif
        ProblematicEventsManager.shared.sync(isBackgroundFetch: UIApplication.shared.applicationState != .active) { newData, needsNotification in
            #if DEBUG || RELEASE_DEV
                NotificationManager.shared.showDebugNotification(title: "[PushHandler] Sync completed", body: "Time: \(Date()), newData: \(newData), needsNotification: \(needsNotification)")
            #endif
            if newData {
                if needsNotification {
                    NotificationManager.shared.showExposureNotification()
                }

                // data are updated -> reschedule background task warning triggers
                NotificationManager.shared.resetBackgroundTaskWarningTriggers()
            }
        }
    }
}
