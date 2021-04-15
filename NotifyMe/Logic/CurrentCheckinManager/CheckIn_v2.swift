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

import CrowdNotifierBaseSDK
import Foundation

struct CheckIn_v2: UBCodable, Equatable {
    init(identifier: String, qrCode: String, checkInTime: Date, venue: VenueInfo_v2, hideFromDiary: Bool = false) {
        self.identifier = identifier
        self.venue = venue
        self.checkInTime = checkInTime
        self.hideFromDiary = hideFromDiary
        self.qrCode = qrCode
    }

    public var identifier: String
    public let qrCode: String
    public var venue: VenueInfo_v2
    public var checkInTime: Date
    public var comment: String?
    public var checkOutTime: Date?
    public var hideFromDiary: Bool

    static func == (lhs: CheckIn_v2, rhs: CheckIn_v2) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func timeSinceCheckIn() -> String {
        return Date().timeIntervalSince(checkInTime).ns_formatTime()
    }
}
