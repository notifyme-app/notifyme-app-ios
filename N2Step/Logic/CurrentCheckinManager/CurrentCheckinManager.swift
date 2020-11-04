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

    public func checkIn(qrCode _: String) -> Bool {
        let checkInTime = Date()

        // TODO: call SDK function
        // if let (venue, id) = N2Step.checkin(qrCode: qrCode, arrivalTime: checkInTime) {

        // TODO: replace id and venue
        currentCheckin = CheckIn(identifier: 0, checkInTime: checkInTime, venue: nil)
        removeAdditionalInfo(identifier: 0)

        return true
    }

    public func checkOut() {
        if let cc = currentCheckin {
            saveAdditionalInfo(checkIn: cc)

            let ti = Date().timeIntervalSince(cc.checkInTime)
            // N2Step.changeDuration(checkinId: cc.identifier, pk: cc.venue.pk, newDuration: ti)
            currentCheckin = nil
        }
    }

    private func removeAdditionalInfo(identifier: Int) {
        let infos = additionalInfos.filter { $0.identifier != identifier }
        additionalInfos = infos
    }

    private func saveAdditionalInfo(checkIn: CheckIn) {
        var infos: [AdditionalInfo] = additionalInfos

        let info = AdditionalInfo(identifier: checkIn.identifier, publicKey: "", comment: checkIn.comment)

        infos.append(info)
        additionalInfos = infos
    }
}
