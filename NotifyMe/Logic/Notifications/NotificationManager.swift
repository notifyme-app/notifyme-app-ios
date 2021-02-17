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

struct NotificationType {
    static let reminder = "ch.notify-me.notificationtype.reminder"
    static let exposure = "ch.notify-me.notificationtype.exposure"
}

class NotificationManager {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    private var reminderNotificationId: String?

    var notificationCategories: Set<UNNotificationCategory> {
        return Set(arrayLiteral:
            UNNotificationCategory(identifier: NotificationType.reminder, actions: [], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: NotificationType.exposure, actions: [], intentIdentifiers: [], options: []))
    }

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            self.hasDeniedNotificationPermission = !success

            DispatchQueue.main.async {
                UIStateManager.shared.stateChanged()
                completion(success, error)
            }
        }
    }

    @UBUserDefault(key: "ch.notify-me.hasDeniedNotificationPermission", defaultValue: false)
    private(set) var hasDeniedNotificationPermission: Bool

    func checkAuthorization() {
        notificationCenter.getNotificationSettings { settings in
            self.hasDeniedNotificationPermission = settings.authorizationStatus == .denied

            DispatchQueue.main.async {
                UIStateManager.shared.stateChanged()
            }
        }
    }

    func scheduleReminderNotification(after timeInterval: TimeInterval) {
        removeCurrentReminderNotification()

        let notification = UNMutableNotificationContent()
        notification.categoryIdentifier = NotificationType.reminder
        notification.title = "checkout_reminder_title".ub_localized
        notification.body = "checkout_reminder_text".ub_localized
        notification.sound = .default

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
        notification.categoryIdentifier = NotificationType.exposure
        notification.title = "exposure_notification_title".ub_localized
        notification.body = "exposure_notification_body".ub_localized
        notification.sound = .default

        notificationCenter.add(UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil))
    }

    func showDebugNotification(title: String, body: String) {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.sound = .default

        notificationCenter.add(UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil))
    }
}
