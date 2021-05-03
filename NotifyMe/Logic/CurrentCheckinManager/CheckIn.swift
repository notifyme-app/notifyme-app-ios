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

import CrowdNotifierSDK
import Foundation

struct CheckIn: UBCodable, Equatable {
    var identifier: String
    let qrCode: String
    var venue: VenueInfo
    var checkInTime: Date
    var checkOutTime: Date?
    var comment: String?
    var hideFromDiary: Bool

    init(identifier: String, qrCode: String, venue: VenueInfo, checkInTime: Date, checkOutTime: Date? = nil, comment: String? = nil, hideFromDiary: Bool = false) {
        self.identifier = identifier
        self.qrCode = qrCode
        self.venue = venue
        self.checkInTime = checkInTime
        self.checkOutTime = checkOutTime
        self.comment = comment
        self.hideFromDiary = hideFromDiary
    }

    static func == (lhs: CheckIn, rhs: CheckIn) -> Bool {
        let sameId = lhs.identifier == rhs.identifier
        let sameComment = lhs.comment ?? "" == rhs.comment ?? ""
        let sameCheckinTime = lhs.checkInTime == rhs.checkInTime
        let sameCheckoutTime = rhs.checkOutTime == lhs.checkOutTime
        return sameId && sameComment && sameCheckinTime && sameCheckoutTime
    }

    public func timeSinceCheckIn() -> String {
        return Date().timeIntervalSince(checkInTime).ns_formatTime()
    }
}
