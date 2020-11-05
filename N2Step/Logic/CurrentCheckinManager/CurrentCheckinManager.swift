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

    @KeychainPersisted(key: "ch.n2step.current.diary.key", defaultValue: [])
    private var diary: [CheckIn] {
        didSet { UIStateManager.shared.userCheckinStateChanged() }
    }

    @UBOptionalUserDefault(key: "ch.n2step.current.checkin.key")
    public var currentCheckin: CheckIn? {
        didSet { UIStateManager.shared.userCheckinStateChanged() }
    }

    // MARK: - Public API

    public func getDiary() -> [[CheckIn]] {
        var result: [[CheckIn]] = []
        var currentDate: Date?
        var currentCheckins: [CheckIn] = []

        let calendar = NSCalendar.current

        for i in diary.sorted(by: { (a, b) -> Bool in
            a.checkInTime < b.checkInTime
        }) {
            let d = calendar.startOfDay(for: i.checkInTime)

            if currentDate == nil {
                currentDate = d
            }

            guard let cd = currentDate else { continue }

            if cd == d {
                currentCheckins.append(i)
            } else {
                result.append(currentCheckins)
                currentCheckins.removeAll()

                currentDate = d
                currentCheckins.append(i)
            }
        }

        if currentCheckins.count > 0 {
            result.append(currentCheckins)
        }

        return result
    }

    public func hideFromDiary(identifier: String) {
        removeFromDiary(identifier: identifier)
    }

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
