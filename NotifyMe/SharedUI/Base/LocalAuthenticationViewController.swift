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

import LocalAuthentication
import UIKit

class LocalAuthenticationViewController: BaseViewController {
    internal var bypassAuthentication: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if bypassAuthentication {
            handleSuccess()
        } else {
            authenticate()
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "face_id_reason_text".ub_localized) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.handleSuccess()
                    } else {
                        if let err = authenticationError {
                            self.handleError(err)
                        } else {
                            self.handleSuccess()
                        }
                    }
                }
            }
        } else {
            // no biometrics
            handleSuccess()
        }
    }

    internal func handleSuccess() {
        // TODO: Override
    }

    internal func handleError(_: Error) {
        // TODO: Override
    }
}
