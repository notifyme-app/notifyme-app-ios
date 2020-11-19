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

struct ErrorViewModel: Equatable {
    let title: String
    let text: String
    let buttonText: String
    let icon: UIImage?

    init(title: String, text: String, buttonText: String, icon: UIImage? = nil) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
        self.icon = icon
    }
}

extension ErrorViewModel {
    static let alreadyCheckedIn = ErrorViewModel(title: "error_title".ub_localized,
                                                 text: "error_already_checked_in".ub_localized,
                                                 buttonText: "ok_button".ub_localized,
                                                 icon: UIImage(named: "icons-ic-error"))

    static let invalidQrCode = ErrorViewModel(title: "error_title".ub_localized,
                                              text: "qrscanner_error".ub_localized,
                                              buttonText: "ok_button".ub_localized,
                                              icon: UIImage(named: "icons-ic-error"))

    static let networkProblem = ErrorViewModel(title: "error_network_title".ub_localized,
                                               text: "error_network_text".ub_localized,
                                               buttonText: "error_action_retry".ub_localized,
                                               icon: UIImage(named: "icons-ic-error"))

    static let noNotificationPermission = ErrorViewModel(title: "error_notification_deactivated_title".ub_localized,
                                                         text: "error_notification_deactivated_text".ub_localized,
                                                         buttonText: "error_action_change_settings".ub_localized,
                                                         icon: UIImage(named: "icons-ic-notification-off"))

    static let noBackgroundFetch = ErrorViewModel(title: "error_background_refresh_title".ub_localized,
                                                  text: "error_background_refresh_text".ub_localized,
                                                  buttonText: "error_action_change_settings".ub_localized,
                                                  icon: UIImage(named: "icons-ic-refresh"))

    static let noCameraPermission = ErrorViewModel(title: "error_camera_permission_title".ub_localized,
                                                   text: "error_camera_permission_text".ub_localized,
                                                   buttonText: "error_action_change_settings".ub_localized,
                                                   icon: UIImage(named: "icons-ic-cam-off"))
}
