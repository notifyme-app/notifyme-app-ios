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
    init(identifier: String, qrCode: String, checkInTime: Date, venue: VenueInfo) {
        self.identifier = identifier
        self.venue = venue
        self.checkInTime = checkInTime
        self.qrCode = qrCode
    }

    public var identifier: String
    public let qrCode: String
    public var venue: VenueInfo
    public var checkInTime: Date
    public var comment: String?
    public var checkOutTime: Date?

    static func == (lhs: CheckIn, rhs: CheckIn) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func timeSinceCheckIn() -> String {
        return Date().timeIntervalSince(checkInTime).ns_formatTime()
    }
}

extension CheckIn {
    // MARK: - Convenience getters

    var notificationKey: Bytes {
        return venue.notificationKey.bytes
    }

    var venuePublicKey: Bytes {
        return Bytes()
    }

    var r1: Bytes {
        return Bytes()
    }
}
