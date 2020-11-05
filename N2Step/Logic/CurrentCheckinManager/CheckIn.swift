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
    init(identifier: String, qrCode: String, checkInTime: Date, venue: VenueInfo, hideFromDiary: Bool = false) {
        self.identifier = identifier
        self.venue = venue
        self.checkInTime = checkInTime
        checkOutTime = checkInTime
        self.hideFromDiary = hideFromDiary
        self.qrCode = qrCode
    }

    public var identifier: String
    public let qrCode: String
    public var venue: VenueInfo
    public var checkInTime: Date
    public var comment: String?
    public var checkOutTime: Date
    public var hideFromDiary: Bool

    static func == (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func timeSinceCheckIn() -> String {
        return Date().timeIntervalSince(checkInTime).ns_formatTime()
    }
}

struct AdditionalInfo: UBCodable {
    init(identifier: String, publicKey: Data, comment: String?) {
        self.identifier = identifier
        self.publicKey = publicKey
        self.comment = comment
    }

    public let identifier: String
    public let publicKey: Data
    public let comment: String?
}
