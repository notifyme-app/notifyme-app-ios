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

protocol CheckinStateUpdate {
    func checkinStateDidChange()
}

class CheckInManager {
    // MARK: - Shared

    public static let shared = CheckInManager()

    @KeychainPersisted(key: "ch.notify-me.current.diary.key", defaultValue: [])
    private var diary: [CheckIn] {
        didSet { UIStateManager.shared.stateChanged() }
    }

    @UBOptionalUserDefault(key: "ch.notify-me.current.checkin.key")
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
        if var cc = currentCheckin, let outTime = cc.checkOutTime {
            // This is the last moment we can ask the user for the required notification permission.
            // After the first checkout, it's possible that a background update triggers a match and therefore a notification
            NotificationManager.shared.requestAuthorization { _, _ in }

            ReminderManager.shared.removeAllReminders()

            let result = CrowdNotifier.addCheckin(venueInfo: cc.venue, arrivalTime: cc.checkInTime, departureTime: outTime)

            switch result {
            case let .success(id):
                cc.identifier = id
                saveAdditionalInfo(checkIn: cc)
            case .failure:
                break
            }

            currentCheckin = nil
        }
    }

    public func updateCheckIn(checkIn: CheckIn) {
        guard let checkOutTime = checkIn.checkOutTime else { return }

        let result = CrowdNotifier.updateCheckin(checkinId: checkIn.identifier, venueInfo: checkIn.venue, newArrivalTime: checkIn.checkInTime, newDepartureTime: checkOutTime)

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
