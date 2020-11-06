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

/// Implementation of business rules to link SDK and all errors and states  to UI state
class UIStateLogic {
    let manager: UIStateManager

    init(manager: UIStateManager) {
        self.manager = manager
    }

    func buildState() -> UIStateModel {
        var checkInState: UIStateModel.CheckInState = .noCheckIn
        if let checkIn = CheckInManager.shared.currentCheckin {
            checkInState = .checkIn(checkIn)
        }

        return UIStateModel(checkInState: checkInState, reportState: .report(reports: []), diaryState: CheckInManager.shared.getDiary())
    }
}
