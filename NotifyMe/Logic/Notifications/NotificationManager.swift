//
/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation

class NotificationManager: NSObject {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    private var reminderNotificationId: String?

    override private init() {
        super.init()

        notificationCenter.delegate = self
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: completion)
    }

    func scheduleReminderNotification(after timeInterval: TimeInterval) {
        removeCurrentReminderNotification()

        let notification = UNMutableNotificationContent()
        notification.title = "checkout_reminder_title".ub_localized
        notification.body = "checkout_reminder_text".ub_localized
        notification.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let id = UUID().uuidString
        notificationCenter.add(UNNotificationRequest(identifier: id, content: notification, trigger: trigger))

        reminderNotificationId = id
    }

    func removeCurrentReminderNotification() {
        if let id = reminderNotificationId {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
            reminderNotificationId = nil
        }
    }

    func showExposureNotification() {
        let notification = UNMutableNotificationContent()
        notification.title = "exposure_notification_title".ub_localized
        notification.body = "exposure_notification_body".ub_localized
        notification.sound = UNNotificationSound.default

        notificationCenter.add(UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil))
    }

}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
