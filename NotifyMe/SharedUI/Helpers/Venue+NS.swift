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

public extension VenueInfo {
    // MARK: - Image for UI

    func image(large: Bool) -> UIImage? {
        var imageName: String = ""
        switch venueType {
        case .other:
            imageName = "illus-other"
        case .meetingRoom:
            imageName = "illus-meeting"
        case .cafeteria:
            imageName = "illus-cafeteria"
        case .privateEvent:
            imageName = "illus-private-event"
        case .canteen:
            imageName = "illus-canteen"
        case .library:
            imageName = "illus-library"
        case .lectureRoom:
            imageName = "illus-lecture-room"
        case .shop:
            imageName = "illus-shop"
        case .gym:
            imageName = "illus-gym"
        case .kitchenArea:
            imageName = "illus-kitchen-area"
        case .officeSpace:
            imageName = "illus-office-space"
        }

        return UIImage(named: "\(imageName)\(large ? "" : "-small")")
    }

    static func defaultImage(large: Bool) -> UIImage {
        return UIImage(named: large ? "illus-other" : "illus-other-small")!
    }
}
