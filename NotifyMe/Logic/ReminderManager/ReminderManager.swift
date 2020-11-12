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

enum ReminderOption: Int, UBCodable, CaseIterable {
    case off
    case thirtyMinutes
    case oneHour
    case twoHours
    case fourHours

    var title: String {
        switch self {
        case .off:
            return "reminder_option_off".ub_localized.uppercased()
        case .thirtyMinutes:
            return "reminder_option_minutes".ub_localized.replacingOccurrences(of: "{MINUTES}", with: "30")
        case .oneHour:
            return "reminder_option_hours".ub_localized.replacingOccurrences(of: "{HOURS}", with: "1")
        case .twoHours:
            return "reminder_option_hours".ub_localized.replacingOccurrences(of: "{HOURS}", with: "2")
        case .fourHours:
            return "reminder_option_hours".ub_localized.replacingOccurrences(of: "{HOURS}", with: "4")
        }
    }

    var timeInterval: TimeInterval {
        switch self {
        case .off:
            return 0
        case .thirtyMinutes:
            return 30 * 60
        case .oneHour:
            return 60 * 60
        case .twoHours:
            return 2 * 60 * 60
        case .fourHours:
            return 4 * 60 * 60
        }
    }
}

class ReminderManager: NSObject {
    private let notificationCategory = "reminder"

    // MARK: - Shared instance

    public static let shared = ReminderManager()

    @UBUserDefault(key: "ch.notify-me.current.reminder.key", defaultValue: .off)
    public var currentReminder: ReminderOption

    // MARK: - Public API

    public func scheduleReminder(for id: String, with option: ReminderOption, didFailCallback: @escaping (() -> Void)) {
        currentReminder = option

        if option == .off {
            removeAllReminder()
            return
        }

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                self.scheduleNotification(for: id, in: option.timeInterval)
            } else {
                DispatchQueue.main.async {
                    didFailCallback()
                }
            }
        }
    }

    public func removeAllReminder() {
        currentReminder = .off
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
    }

    // MARK: - Implementation

    private func scheduleNotification(for _: String, in timeInterval: TimeInterval) {
        let notificationCenter = UNUserNotificationCenter.current()
        let notification = UNMutableNotificationContent()

        notification.title = "checkout_reminder_title".ub_localized
        notification.body = "checkout_reminder_text".ub_localized
        notification.categoryIdentifier = notificationCategory
        notification.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        notificationCenter.add(notificationRequest)
    }
}

extension ReminderManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
