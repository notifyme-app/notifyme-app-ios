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

@testable import CrowdNotifierSDK
import XCTest

class NotifyMeTests: XCTestCase {
    private let storage: CheckinStorage = .shared

    private let baseUrl = "https://qr.notify-me.ch"

    private let qrCode = "https://qr.notify-me.ch/#CAESZAgBEiDwR2Oj0B1_XP1WeCfXRFIN0FylcYGP27HsEhANnE0KExoKSG9tZW9mZmljZSIHWnVoYXVzZSoFQsO8cm8wADogIiO_NrgF7RtaIoQqvPhCN1GoCKGK93p3XNYV7QJ7AjgaQNssfMm583dl88rNfgD8ZPMyRna_xO87g3sNp8zhYi9cbRJ1TKB_UWTBFiO5Tx9G0xbSSOx7qW54wrPwUzjDYQ4"
    private let wrongQrCode = "https://qr.notify-me.ch/#CAESZAgBEiDwR2Oj0B1_XP1WeCfRFIN0FylcYGP27HsEhANnE0KExoKSG9tZW9mZmljZSIHWnVoYXVzZSoFQsO8cm8wADogIiO_NrgF7RtaIoQqvPhCN1GoCKGK93p3XNYV7QJ7AjgaQNssfMm583dl88rNfgD8ZPMyRna_xO87g3sNp8zhYi9cbRJ1TKB_UWTBFiO5Tx9G0xbSSOx7qW54wrPwUzjDYQ4"

    override class func setUp() {
        CrowdNotifier.cleanUpOldData(maxDaysToKeep: 0)
    }

    func testCorrectQrCode() {
        let result = CrowdNotifier.getVenueInfo(qrCode: qrCode, baseUrl: baseUrl)

        switch result {
        case let .success(venue):
            XCTAssert(venue.name == "Homeoffice", "Wrong venue name")
            XCTAssert(venue.location == "Zuhause", "Wrong venue location")
            XCTAssert(venue.room == "Büro", "Wrong venue room")
            XCTAssert(venue.venueType == .other, "Wrong venue type")

            let arrivalTime = Date()
            let checkinResult = CrowdNotifier.addCheckin(arrivalTime: arrivalTime, departureTime: arrivalTime.addingTimeInterval(.hour * 2), notificationKey: venue.notificationKey.bytes, venuePublicKey: venue.publicKey.bytes)

            switch checkinResult {
            case let .success(id):
                XCTAssert(storage.allEntries.count == 1, "Storage should contain 1 checkin entry")

                guard let entry = storage.allEntries[id] else {
                    XCTFail("Entry stored with wrong id")
                    return
                }

                XCTAssert(entry.id == id, "Entry has wrong id")
                XCTAssert(entry.daysSince1970 == arrivalTime.daysSince1970, "Wrong daysSince1970 value")

            case .failure:
                XCTFail("Checkin with correct QR Code should succeed")
            }

        case .failure:
            XCTFail("QR Code should be correct")
        }
    }

    func testWrongQrCode() {
        let result = CrowdNotifier.getVenueInfo(qrCode: wrongQrCode, baseUrl: baseUrl)

        switch result {
        case .success:
            XCTFail("QR Code should not be correct")
        case let .failure(error):
            XCTAssert(error == .invalidQRCode, "Error case should be .invalidQRCode")
        }
    }

    func testMatching() {
        let privateKey: Bytes = [43, 251, 221, 2, 27, 157, 184, 187, 93, 206, 197, 146, 72, 110, 187, 109, 250, 171, 118, 22, 94, 68, 178, 181, 43, 243, 42, 4, 121, 199, 73, 131, 240, 71, 99, 163, 208, 29, 127, 92, 253, 86, 120, 39, 215, 68, 82, 13, 208, 92, 165, 113, 129, 143, 219, 177, 236, 18, 16, 13, 156, 77, 10, 19]

        let problematicEvent = ProblematicEventInfo(privateKey: privateKey, entry: Date().addingTimeInterval(-7200), exit: Date().addingTimeInterval(7200), message: Bytes())

        let matches = CrowdNotifier.checkForMatches(publishedSKs: [problematicEvent])

        XCTAssert(matches.count == 1, "Match should be found")
    }

    func testMatchingButDifferentTime() {
        let privateKey: Bytes = [43, 251, 221, 2, 27, 157, 184, 187, 93, 206, 197, 146, 72, 110, 187, 109, 250, 171, 118, 22, 94, 68, 178, 181, 43, 243, 42, 4, 121, 199, 73, 131, 240, 71, 99, 163, 208, 29, 127, 92, 253, 86, 120, 39, 215, 68, 82, 13, 208, 92, 165, 113, 129, 143, 219, 177, 236, 18, 16, 13, 156, 77, 10, 19]

        let problematicEvent = ProblematicEventInfo(privateKey: privateKey, entry: Date().addingTimeInterval(-7200), exit: Date().addingTimeInterval(-3600), message: Bytes())

        let matches = CrowdNotifier.checkForMatches(publishedSKs: [problematicEvent])

        XCTAssert(matches.isEmpty, "No match should be found")
    }

    func testNonMatching() {
        let privateKey: Bytes = [43, 251, 221, 2, 27, 157, 184, 187, 93, 206, 197, 146, 72, 110, 187, 109, 250, 171, 118, 22, 94, 68, 178, 181, 43, 242, 42, 4, 121, 199, 73, 131, 240, 71, 99, 163, 208, 29, 127, 92, 253, 86, 120, 39, 215, 68, 82, 13, 208, 92, 165, 113, 129, 143, 219, 177, 236, 18, 16, 13, 156, 77, 10, 19]

        let problematicEvent = ProblematicEventInfo(privateKey: privateKey, entry: Date().addingTimeInterval(-7200), exit: Date().addingTimeInterval(7200), message: Bytes())

        let matches = CrowdNotifier.checkForMatches(publishedSKs: [problematicEvent])

        XCTAssert(matches.isEmpty, "No match should be found")
    }
}
