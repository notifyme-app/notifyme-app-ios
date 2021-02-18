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
    static let backgroundTaskWarningTrigger = "ch.notify-me.notificationtype.backgroundtaskwarning"
}

class NotificationManager {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()

    private let syncNotificationIdentifier1 = "ch.notifyme.notification.syncWarning1"
    private let syncNotificationIdentifier2 = "ch.notifyme.notification.syncWarning2"

    @UBOptionalUserDefault(key: "ch.notify-me.reminderNotificationId")
    private var reminderNotificationId: String?

    @UBUserDefault(key: "ch.notify-me.hasCheckedOutOnce", defaultValue: false)
    var hasCheckedOutOnce: Bool

    var notificationCategories: Set<UNNotificationCategory> {
        return Set(arrayLiteral:
            UNNotificationCategory(identifier: NotificationType.reminder, actions: [], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: NotificationType.exposure, actions: [], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: NotificationType.backgroundTaskWarningTrigger, actions: [], intentIdentifiers: [], options: []))
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

    func resetBackgroundTaskWarningTriggers() {
        guard hasCheckedOutOnce else { return }

        // Adding a request with the same identifier again automatically cancels an existing request with that identifier, if present
        scheduleSyncWarningNotification(delay: .day * 2, identifier: syncNotificationIdentifier1)
        scheduleSyncWarningNotification(delay: .day * 7, identifier: syncNotificationIdentifier2)
    }

    private func scheduleSyncWarningNotification(delay: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = NotificationType.backgroundTaskWarningTrigger
        content.title = "sync_warning_notification_title".ub_localized
        content.body = "sync_warning_notification_text".ub_localized
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
    }

    func showDebugNotification(title: String, body: String) {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.sound = .default

        notificationCenter.add(UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: nil))
    }
}
