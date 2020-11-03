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

struct CheckIn: UBCodable, Equatable {
    init(identifier: Int, checkInTime: Date, venue: VenueInfo?) {
        self.identifier = identifier
        self.venue = venue
        self.checkInTime = checkInTime
    }

    public let identifier: Int
    public let venue: VenueInfo?
    public let checkInTime: Date

    static func == (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func timeSinceCheckIn() -> String {
        return Date().timeIntervalSince(checkInTime).ns_formatTime()
    }
}
