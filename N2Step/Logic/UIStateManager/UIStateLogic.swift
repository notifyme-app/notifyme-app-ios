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
        return UIStateModel(checkInState: buildCheckInState(), exposureState: buildExposureState(), diaryState: buildDiaryState())
    }

    // MARK: - Substates

    private func buildCheckInState() -> UIStateModel.CheckInState {
        var checkInState: UIStateModel.CheckInState = .noCheckIn
        if let checkIn = CheckInManager.shared.currentCheckin {
            checkInState = .checkIn(checkIn)
        }

        return checkInState
    }

    private func buildExposureState() -> UIStateModel.ExposureState {
        let events = ProblematicEventsManager.shared.getExposureEvents().sorted { $0.arrivalTime < $1.arrivalTime
        }
        return events.count > 0 ? .exposure(exposureEvents: events) : .noExposure
    }

    private func buildDiaryState() -> [[CheckIn]] {
        let diary = CheckInManager.shared.getDiary()

        var result: [[CheckIn]] = []
        var currentDate: Date?
        var currentCheckins: [CheckIn] = []

        let calendar = NSCalendar.current

        for i in diary.sorted(by: { (a, b) -> Bool in
            a.checkInTime < b.checkInTime
        }) {
            let d = calendar.startOfDay(for: i.checkInTime)

            if currentDate == nil {
                currentDate = d
            }

            guard let cd = currentDate else { continue }

            if cd == d {
                currentCheckins.append(i)
            } else {
                result.append(currentCheckins)
                currentCheckins.removeAll()

                currentDate = d
                currentCheckins.append(i)
            }
        }

        if currentCheckins.count > 0 {
            result.append(currentCheckins)
        }

        return result
    }
}
