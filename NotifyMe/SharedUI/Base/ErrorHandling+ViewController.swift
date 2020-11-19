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

protocol ErrorHandlingDelegate: UIViewController {
    func handleError(_ error: ErrorViewModel?)
}

extension BaseViewController: ErrorHandlingDelegate {
    func handleError(_ error: ErrorViewModel?) {
        guard let error = error else {
            return
        }

        switch error {
        case .networkProblem:
            ProblematicEventsManager.shared.sync { _, _ in
            }
        case .noBackgroundFetch, .noCameraPermission, .noNotificationPermission:
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        default:
            break
        }
    }
}

extension BaseSubViewController: ErrorHandlingDelegate {
    func handleError(_ error: ErrorViewModel?) {
        guard let error = error else {
            return
        }

        switch error {
        case .networkProblem:
            ProblematicEventsManager.shared.sync { _, _ in
            }
        case .noBackgroundFetch, .noCameraPermission, .noNotificationPermission:
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        default:
            break
        }
    }
}
