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

class ReminderManager : NSObject
{
    private let notificationCategory = "reminder"

    // MARK: - Shared instance

    public static let shared = ReminderManager()

    // MARK: - Public API

    public func scheduleReminder(for id: Int, in timeInterval: TimeInterval)
    {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                self.scheduleNotification(for: id, in: timeInterval)
            } else {
                // TODO: Problem.
            }
        }
    }

    public func removeAllReminder()
    {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
    }

    // MARK: - Implementation

    private func scheduleNotification(for id: Int, in timeInterval: TimeInterval)
    {
        let notificationCenter = UNUserNotificationCenter.current()
        let notification = UNMutableNotificationContent()

        notification.title = "checkout_reminder_title".ub_localized
        notification.body = "checkout_reminder_text".ub_localized
        notification.categoryIdentifier = self.notificationCategory
        notification.sound = UNNotificationSound.default


        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        notificationCenter.add(notificationRequest)
    }
}

extension ReminderManager : UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        completionHandler()
    }
}
