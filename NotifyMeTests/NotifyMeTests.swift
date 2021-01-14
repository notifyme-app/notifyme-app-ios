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

    private let qrCode = "https://qr.notify-me.ch/?v=2#CAISRgoETmFtZRIITG9jYXRpb24aBFJvb20qIJbXvr28KWGTrw5IApWO3OBHi5vmtWfYWhzp3AypFCnnMOSPhOjuLjjk_7a67y4aYNt7LapzxnV4bvXCLhxQp8YkKI_DInWJATZLJvK_fOGHDXse_51wr0R5cK73g9vQGETiJ1jD58yvJSDTPVCfGMVWZkOrK2fXGb8FiJVuRycyUIHLkBtIjWvPtwfnXUR2DCI0ChhsRr9rIl7X7RimrDeIi5n70CcX8LYQEMgSGJOZUmLKwG0N-_EXQn6ltnw42dmMJS7Ejw"
//    private let wrongQrCode = "https://qr.notify-me.ch/#CAESZAgBEiDwR2Oj0B1_XP1WeCfRFIN0FylcYGP27HsEhANnE0KExoKSG9tZW9mZmljZSIHWnVoYXVzZSoFQsO8cm8wADogIiO_NrgF7RtaIoQqvPhCN1GoCKGK93p3XNYV7QJ7AjgaQNssfMm583dl88rNfgD8ZPMyRna_xO87g3sNp8zhYi9cbRJ1TKB_UWTBFiO5Tx9G0xbSSOx7qW54wrPwUzjDYQ4"

    override class func setUp() {
        CrowdNotifier.cleanUpOldData(maxDaysToKeep: 0)
    }

    func testHours() {
        let date1 = Date(timeIntervalSince1970: 1_609_495_200) // 01.01.2021 10:00

        let date2 = date1.addingTimeInterval(.minute * 59) // 01.01.2021 10:59
        assert(date1.hoursUntil(date2) == [447_082], "Hours should be [447082]")

        let date3 = date1.addingTimeInterval(.minute * 60) // 01.01.2021 11:00
        assert(date1.hoursUntil(date3) == [447_082, 447_083], "Hours should be [447082, 447083]")

        let date4 = date1.addingTimeInterval(.minute * -1) // 01.01.2021 09:59
        assert(date1.hoursUntil(date4) == [], "Hours should be [] (validFrom > validTo")
        assert(date4.hoursUntil(date1) == [447_081, 447_082], "Hours should be [447081, 447082]")

        let date5 = date1.addingTimeInterval(.hour * 20 - .second * 1)
        assert(date1.hoursUntil(date5).count == 20, "There should be 20 hours")
    }

    func testCheckin() {
        let result = CrowdNotifier.getVenueInfo(qrCode: qrCode, baseUrl: baseUrl)
        switch result {
        case let .success(venue):
            let arrivalTime = Date()
            let checkinResult = CrowdNotifier.addCheckin(venueInfo: venue, arrivalTime: arrivalTime, departureTime: arrivalTime.addingTimeInterval(.hour * 4))

            switch checkinResult {
            case let .success(id):

                let problematicEvent = ProblematicEventInfo(identity: [19, 51, 0, 151, 144, 173, 120, 199, 246, 19, 49, 214, 242, 211, 6, 8, 43, 239, 8, 147, 203, 77, 78, 43, 172, 83, 199, 238, 48, 83, 71, 250],
                                                            secretKeyForIdentity: [7, 123, 215, 57, 193, 27, 32, 107, 147, 7, 72, 156, 63, 184, 104, 149, 40, 187, 88, 217, 53, 156, 18, 9, 214, 182, 252, 238, 141, 176, 69, 172, 167, 105, 127, 60, 192, 136, 22, 249, 186, 115, 186, 244, 88, 71, 197, 146],
                                                            startTimestamp: Date().addingTimeInterval(.hour * -2),
                                                            endTimestamp: Date().addingTimeInterval(.hour * 2),
                                                            nonce: [230, 228, 145, 105, 55, 153, 41, 198, 64, 194, 188, 81, 98, 97, 18, 170, 193, 83, 246, 228, 72, 84, 53, 53],
                                                            encryptedMessage: [228, 73, 181, 230, 56, 137, 170, 166, 58, 201, 207, 101, 198, 150, 149, 68, 205, 152, 193, 31, 9, 203, 142, 30, 110, 183, 224, 175, 24, 189, 25, 148, 160, 14])

                let events = CrowdNotifier.checkForMatches(problematicEventInfos: [problematicEvent])
                XCTAssert(events.count > 0, "There should be a match")
            case .failure:
                XCTFail("Checkin failed")
            }
        case .failure:
            XCTFail("Invalid QR Code")
        }
    }

//    func testCorrectQrCode() {
//        let result = CrowdNotifier.getVenueInfo(qrCode: qrCode, baseUrl: baseUrl)
//
//        switch result {
//        case let .success(venue):
//            XCTAssert(venue.name == "Homeoffice", "Wrong venue name")
//            XCTAssert(venue.location == "Zuhause", "Wrong venue location")
//            XCTAssert(venue.room == "Büro", "Wrong venue room")
//            XCTAssert(venue.venueType == .other, "Wrong venue type")
//
//            let arrivalTime = Date()
//            let checkinResult = CrowdNotifier.addCheckin(arrivalTime: arrivalTime, departureTime: arrivalTime.addingTimeInterval(.hour * 2), notificationKey: venue.notificationKey.bytes, venuePublicKey: venue.publicKey.bytes)
//
//            switch checkinResult {
//            case let .success(id):
//                XCTAssert(storage.allEntries.count == 1, "Storage should contain 1 checkin entry")
//
//                guard let entry = storage.allEntries[id] else {
//                    XCTFail("Entry stored with wrong id")
//                    return
//                }
//
//                XCTAssert(entry.id == id, "Entry has wrong id")
//                XCTAssert(entry.daysSince1970 == arrivalTime.daysSince1970, "Wrong daysSince1970 value")
//
//            case .failure:
//                XCTFail("Checkin with correct QR Code should succeed")
//            }
//
//        case .failure:
//            XCTFail("QR Code should be correct")
//        }
//    }
//
//    func testWrongQrCode() {
//        let result = CrowdNotifier.getVenueInfo(qrCode: wrongQrCode, baseUrl: baseUrl)
//
//        switch result {
//        case .success:
//            XCTFail("QR Code should not be correct")
//        case let .failure(error):
//            XCTAssert(error == .invalidQRCode, "Error case should be .invalidQRCode")
//        }
//    }
//
//    func testMatching() {
//        let privateKey: Bytes = [43, 251, 221, 2, 27, 157, 184, 187, 93, 206, 197, 146, 72, 110, 187, 109, 250, 171, 118, 22, 94, 68, 178, 181, 43, 243, 42, 4, 121, 199, 73, 131, 240, 71, 99, 163, 208, 29, 127, 92, 253, 86, 120, 39, 215, 68, 82, 13, 208, 92, 165, 113, 129, 143, 219, 177, 236, 18, 16, 13, 156, 77, 10, 19]
//
//        let problematicEvent = ProblematicEventInfo(privateKey: privateKey, entry: Date().addingTimeInterval(-7200), exit: Date().addingTimeInterval(7200), message: Bytes(), nonce: Bytes())
//
//        let matches = CrowdNotifier.checkForMatches(publishedSKs: [problematicEvent])
//
//        XCTAssert(matches.count == 1, "Match should be found")
//    }
//
//    func testMatchingButDifferentTime() {
//        let privateKey: Bytes = [43, 251, 221, 2, 27, 157, 184, 187, 93, 206, 197, 146, 72, 110, 187, 109, 250, 171, 118, 22, 94, 68, 178, 181, 43, 243, 42, 4, 121, 199, 73, 131, 240, 71, 99, 163, 208, 29, 127, 92, 253, 86, 120, 39, 215, 68, 82, 13, 208, 92, 165, 113, 129, 143, 219, 177, 236, 18, 16, 13, 156, 77, 10, 19]
//
//        let problematicEvent = ProblematicEventInfo(privateKey: privateKey, entry: Date().addingTimeInterval(-7200), exit: Date().addingTimeInterval(-3600), message: Bytes(), nonce: Bytes())
//
//        let matches = CrowdNotifier.checkForMatches(publishedSKs: [problematicEvent])
//
//        XCTAssert(matches.isEmpty, "No match should be found")
//    }
//
//    func testNonMatching() {
//        let privateKey: Bytes = [43, 251, 221, 2, 27, 157, 184, 187, 93, 206, 197, 146, 72, 110, 187, 109, 250, 171, 118, 22, 94, 68, 178, 181, 43, 242, 42, 4, 121, 199, 73, 131, 240, 71, 99, 163, 208, 29, 127, 92, 253, 86, 120, 39, 215, 68, 82, 13, 208, 92, 165, 113, 129, 143, 219, 177, 236, 18, 16, 13, 156, 77, 10, 19]
//
//        let problematicEvent = ProblematicEventInfo(privateKey: privateKey, entry: Date().addingTimeInterval(-7200), exit: Date().addingTimeInterval(7200), message: Bytes(), nonce: Bytes())
//
//        let matches = CrowdNotifier.checkForMatches(publishedSKs: [problematicEvent])
//
//        XCTAssert(matches.isEmpty, "No match should be found")
//    }
}
