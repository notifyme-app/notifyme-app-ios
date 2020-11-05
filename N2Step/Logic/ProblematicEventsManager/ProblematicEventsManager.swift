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
import SwiftProtobuf

class ProblematicEventsManager {
    // MARK: - Shared

    public static let shared = ProblematicEventsManager()

    private let backend = Environment.current.backendService

    // MARK: - API

    public func sync() {
        let endpoint = backend.endpoint("traceKeys", headers: ["Accept": "application/protobuf"])

        let task = URLSession.shared.dataTask(with: endpoint.request()) { [weak self] data, _, _ in
            guard let strongSelf = self else { return }

            if let data = data {
                let wrapper = try? ProblematicEventWrapper(serializedData: data, partial: true)
                strongSelf.checkForMatches(wrapper: wrapper)
            }
        }

        task.resume()
    }

    // MARK: - Init

    init() {}

    // MARK: - Check

    private func checkForMatches(wrapper: ProblematicEventWrapper?) {
        guard let wrapper = wrapper else { return }

        var problematicEvents : [ProblematicEventInfo] = []

        for i in wrapper.events {
//            let info = ProblematicEventInfo()
//            info.sk = i.secretKey
//            info.entry = Date(timeIntervalSince1970: i.startTime / 1000)
//            info.exit = Date(timeIntervalSince1970: i.endTime / 1000)
//            info.message = i.message
        }

        let exposureEvents = N2Step.checkForMatches(publishedSKs: problematicEvents)
    }
}
