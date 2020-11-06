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

    @KeychainPersisted(key: "ch.n2step.exposure.events.key", defaultValue: [])
    private var exposureEvents: [ExposureEvent] {
        didSet { UIStateManager.shared.stateChanged() }
    }

    // MARK: - API

    public func getExposureEvents() -> [ExposureEvent] {
        return exposureEvents
    }

    public func sync(completion: @escaping () -> Void) {
        let endpoint = backend.endpoint("traceKeys", headers: ["Accept": "application/protobuf"])

        let task = URLSession.shared.dataTask(with: endpoint.request()) { [weak self] data, _, _ in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                if let data = data {
                    let wrapper = try? ProblematicEventWrapper(serializedData: data)
                    strongSelf.checkForMatches(wrapper: wrapper)
                }

                completion()
            }
        }

        task.resume()
    }

    // MARK: - Init

    init() {}

    // MARK: - Check

    private func checkForMatches(wrapper: ProblematicEventWrapper?) {
        guard let wrapper = wrapper else { return }

        var problematicEvents: [ProblematicEventInfo] = []

        for i in wrapper.events {
            let sk = i.secretKey.bytes
            let entry: Date = Date(timeIntervalSince1970: TimeInterval(i.startTime / 1000))
            let exit: Date = Date(timeIntervalSince1970: TimeInterval(i.endTime / 1000))
            let message = i.message.bytes

            let info = ProblematicEventInfo(privateKey: sk, entry: entry, exit: exit, message: message)
        }

        exposureEvents = N2Step.checkForMatches(publishedSKs: problematicEvents)
    }
}
