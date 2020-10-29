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
import LocalAuthentication

class DiaryViewController : BaseViewController
{
    // MARK: - Init

    override init()
    {
        super.init()
        self.title = "diary_title".ub_localized
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        authenticate()
    }

    // MARK: - Authentication

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "face_id_reason_text".ub_localized) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.showDiary()
                    } else {
                        if let err = authenticationError
                        {
                            self.handleError(err)
                        }
                        else
                        {
                            self.showDiary()
                        }
                    }
                }
            }
        }
        else
        {
            // no biometrics
            self.showDiary()
        }
    }

    private func showDiary()
    {
        // TODO: show diary

    }

    private func handleError(_ error : Error)
    {
        // TODO: handle error
        let alert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
