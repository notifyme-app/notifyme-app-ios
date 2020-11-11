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

/// The backend environment under which the application runs.
enum Environment {
    case dev
    case prod

    /// The current environment, as configured in build settings.
    static var current: Environment {
        #if DEBUG
            return .dev
        #elseif RELEASE_DEV
            return .dev
        #elseif RELEASE_PROD
            return .prod
        #else
            fatalError("Missing build setting for environment")
        #endif
    }

    var backendService: Backend {
        switch self {
        case .dev:
            return Backend("https://app-dev-ws.n2s.ch", version: "v1")
        case .prod:
            return Backend("https://app-prod-ws.n2s.ch", version: "v1")
        }
    }

    var uploadHost: String {
        switch self {
        case .dev:
            return "upload-dev.n2s.ch"
        case .prod:
            return "upload.n2s.ch"
        }
    }
}
