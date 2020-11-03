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
import N2StepSDK

/// Global state model for all screens that are connected to tracing state and results
/// We use a single state model to ensure that all elements have a consistent state
struct UIStateModel: Equatable {
    var checkInState: CheckInState = .noCheckIn
    var reportState: ReportState = .noReport

    enum CheckInState: Equatable {
        case noCheckIn
        case checkIn(CheckIn)
    }

    enum ReportState: Equatable {
        case noReport
        case report(reports: [N2StepSDK.ExposureEvent])
    }
}
