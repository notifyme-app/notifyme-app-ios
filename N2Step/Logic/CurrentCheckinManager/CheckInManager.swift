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

protocol CheckinStateUpdate {
    func checkinStateDidChange()
}

class CheckInManager {
    // MARK: - Shared

    public static let shared = CheckInManager()

    @KeychainPersisted(key: "ch.n2step.current.diary.key", defaultValue: [])
    private var diary: [CheckIn] {
        didSet { UIStateManager.shared.stateChanged() }
    }

    @UBOptionalUserDefault(key: "ch.n2step.current.checkin.key")
    public var currentCheckin: CheckIn? {
        didSet { UIStateManager.shared.stateChanged() }
    }

    // MARK: - Public API

    public func getDiary() -> [CheckIn] {
        return diary
    }

    public func hideFromDiary(identifier: String) {
        removeFromDiary(identifier: identifier)
    }

    public func checkIn(qrCode: String, venueInfo: VenueInfo) {
        currentCheckin = CheckIn(identifier: "", qrCode: qrCode, checkInTime: Date(), venue: venueInfo)
    }

    public func checkOut() {
        if var cc = currentCheckin {
            ReminderManager.shared.removeAllReminder()

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

    public func updateCheckIn(checkIn: CheckIn) {
        let result = N2Step.updateCheckin(checkinId: checkIn.identifier, qrCode: checkIn.qrCode, newArrivalTime: checkIn.checkInTime, newDepartureTime: checkIn.checkOutTime)

        switch result {
        case .success:
            removeFromDiary(identifier: checkIn.identifier)
            saveAdditionalInfo(checkIn: checkIn)
        case .failure:
            break
        }
    }

    // MARK: - Helpers

    private func saveAdditionalInfo(checkIn: CheckIn) {
        var infos: [CheckIn] = diary
        infos.append(checkIn)
        diary = infos
    }

    private func removeFromDiary(identifier: String) {
        let infos = diary.filter { $0.identifier != identifier }
        diary = infos
    }
}
