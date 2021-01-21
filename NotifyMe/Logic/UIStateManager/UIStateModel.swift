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

import CrowdNotifierBaseSDK
import Foundation

/// Global state model for all screens that are connected to tracing state and results
/// We use a single state model to ensure that all elements have a consistent state
struct UIStateModel: Equatable {
    var checkInState: CheckInState = .noCheckIn
    var exposureState: ExposureState = .noExposure
    var diaryState: [[CheckIn]] = []
    var errorState = ErrorState(error: nil)

    enum CheckInState: Equatable {
        case noCheckIn
        case checkIn(CheckIn)
    }

    enum ExposureState: Equatable {
        case noExposure
        case exposure(exposure: [Exposure], exposureByDay: [[Exposure]])
    }

    struct ErrorState: Equatable {
        let error: ErrorViewModel?
    }
}

struct Exposure: Equatable {
    init(exposureEvent: ExposureEvent, diaryEntry: CheckIn?) {
        self.exposureEvent = exposureEvent
        self.diaryEntry = diaryEntry
    }

    let exposureEvent: ExposureEvent
    let diaryEntry: CheckIn?
}
