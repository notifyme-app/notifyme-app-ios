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

protocol CheckinStateUpdate {
    func checkinStateDidChange()
}

class CurrentCheckinManager {
    // MARK: - Shared

    public static let shared = CurrentCheckinManager()

    @KeychainPersisted(key: "ch.n2step.current.additional.infos.key", defaultValue: [])
    private var additionalInfos: [AdditionalInfo]

    @UBOptionalUserDefault(key: "ch.n2step.current.checkin.key")
    public var currentCheckin: CheckIn? {
        didSet { UIStateManager.shared.userCheckinStateChanged() }
    }

    // MARK: - Public API

    public func checkIn(qrCode: String, venueInfo: VenueInfo) {
        currentCheckin = CheckIn(identifier: "", qrCode: qrCode, checkInTime: Date(), venue: venueInfo)
    }

    public func checkOut() {
        if var cc = currentCheckin {
            let result = N2Step.addCheckin(qrCode: cc.qrCode, arrivalTime: cc.checkInTime, departureTime: cc.checkOutTime)

            switch result {
            case .success(let (venueInfo, id)):
                cc.identifier = id
                cc.venue = venueInfo
                saveAdditionalInfo(checkIn: cc)
            case .failure:
                break
            }

            currentCheckin = nil
        }
    }

    private func removeAdditionalInfo(identifier: String) {
        let infos = additionalInfos.filter { $0.identifier != identifier }
        additionalInfos = infos
    }

    private func saveAdditionalInfo(checkIn: CheckIn) {
        var infos: [AdditionalInfo] = additionalInfos

        let info = AdditionalInfo(identifier: checkIn.identifier, publicKey: checkIn.venue.publicKey, comment: checkIn.comment)

        infos.append(info)
        additionalInfos = infos
    }
}
