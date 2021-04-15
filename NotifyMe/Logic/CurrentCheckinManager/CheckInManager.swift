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

    private init() {}

    @KeychainPersisted(key: "ch.notify-me.current.diary.key", defaultValue: [])
    private var diaryV2: [CheckIn_v2] {
        didSet { UIStateManager.shared.stateChanged() }
    }

    @KeychainPersisted(key: "ch.notify-me.current.diary-v3.key", defaultValue: [])
    private var diary: [CheckIn] {
        didSet { UIStateManager.shared.stateChanged() }
    }

    @UBOptionalUserDefault(key: "ch.notify-me.current.checkin.key")
    public var currentCheckinV2: CheckIn_v2? {
        didSet { UIStateManager.shared.stateChanged() }
    }

    @UBOptionalUserDefault(key: "ch.notify-me.current.checkin-v3.key")
    public var currentCheckin: CheckIn? {
        didSet { UIStateManager.shared.stateChanged() }
    }

    // MARK: - Public API

    public func getDiary() -> [CheckIn] {
        return diary
    }

    public func cleanUpOldData(maxDaysToKeep: Int) {
        guard maxDaysToKeep > 0 else {
            diary = []
            return
        }

        let daysLimit = Date().daysSince1970 - maxDaysToKeep
        let infos = diary.filter { $0.checkInTime.daysSince1970 >= daysLimit }
        diary = infos
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
            NotificationManager.shared.requestAuthorization { _ in }

            ReminderManager.shared.removeAllReminders()

            let result = CrowdNotifier.addCheckin(venueInfo: cc.venue, arrivalTime: cc.checkInTime, departureTime: outTime)

            switch result {
            case let .success(id):
                NotificationManager.shared.hasCheckedOutOnce = true
                NotificationManager.shared.resetBackgroundTaskWarningTriggers()
                cc.identifier = id
                saveAdditionalInfo(checkIn: cc)
            case .failure:
                break
            }

            currentCheckin = nil
        }
    }

    public func checkoutAfter12HoursIfNecessary() {
        #if DEBUG
            let timeInterval: TimeInterval = .minute * 12
        #else
            let timeInterval: TimeInterval = .hour * 12
        #endif
        if let checkin = currentCheckin, checkin.checkInTime.addingTimeInterval(timeInterval) < Date() {
            currentCheckin?.checkOutTime = checkin.checkInTime.addingTimeInterval(timeInterval)
            checkOut()
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

    // MARK: - V3 Migration

    @UBUserDefault(key: "ch.notify-me.hasMigratedToV3.key", defaultValue: false)
    private var hasMigratedToV3: Bool

    public func migrate() {
        if !hasMigratedToV3 {
            if let current = currentCheckinV2 {
                currentCheckin = createCheckinFromV2(current)
                currentCheckinV2 = nil
            }

            diary = diaryV2.compactMap { createCheckinFromV2($0) }
            diaryV2 = []

            hasMigratedToV3 = true
        }
    }

    private func createCheckinFromV2(_ oldCheckin: CheckIn_v2) -> CheckIn? {
        var location = NotifyMeLocationData()
        location.room = oldCheckin.venue.room
        location.type = .fromVenueType(oldCheckin.venue.venueType)

        guard let countryData = try? location.serializedData() else {
            return nil
        }
        let venueInfo = VenueInfo(description: oldCheckin.venue.name,
                                  address: oldCheckin.venue.location,
                                  notificationKey: oldCheckin.venue.notificationKey,
                                  publicKey: oldCheckin.venue.masterPublicKey,
                                  nonce1: oldCheckin.venue.nonce1,
                                  nonce2: oldCheckin.venue.nonce2,
                                  validFrom: oldCheckin.venue.validFrom,
                                  validTo: oldCheckin.venue.validTo,
                                  infoBytes: nil,
                                  countryData: countryData)

        return CheckIn(identifier: oldCheckin.identifier,
                       qrCode: oldCheckin.qrCode,
                       checkInTime: oldCheckin.checkInTime,
                       venue: venueInfo,
                       hideFromDiary: oldCheckin.hideFromDiary)
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
