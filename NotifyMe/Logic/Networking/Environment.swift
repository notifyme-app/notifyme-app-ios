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
    case abnahme // for BIT

    /// The current environment, as configured in build settings.
    static var current: Environment {
        #if DEBUG
            return .dev
        #elseif RELEASE_DEV
            return .dev
        #elseif RELEASE_PROD
            return .prod
        #elseif RELEASE_ABNAHME
            return .abnahme
        #else
            fatalError("Missing build setting for environment")
        #endif
    }

    var backendService: Backend {
        switch self {
        case .dev:
            return Backend("https://app-dev-ws.notify-me.ch", version: "v1")
        case .prod:
            return Backend("https://app-prod-ws.notify-me.ch", version: "v1")
        case .abnahme:
            return Backend("https://cn-a.bit.admin.ch/", version: "v1")
        }
    }

    var configService: Backend {
        switch self {
        case .dev:
            return Backend("https://app-dev-config.notify-me.ch", version: "v1")
        case .prod:
            return Backend("https://app-prod-config.notify-me.ch", version: "v1")
        case .abnahme:
            return Backend("https://cn-a.bit.admin.ch/", version: "v1")
        }
    }

    var appStoreUrl: URL {
        return URL(string: "https://itunes.apple.com/app/id1537859001")!
    }

    var uploadHost: String {
        switch self {
        case .dev:
            return "upload-dev.notify-me.ch"
        case .prod:
            return "upload.notify-me.ch"
        case .abnahme:
            return "qr-uploader-a.bit.admin.ch"
        }
    }

    var qrGenBaseUrl: String {
        switch self {
        case .dev:
            return "https://qr-dev.notify-me.ch"
        case .prod:
            return "https://qr.notify-me.ch"
        case .abnahme:
            return "https://qr-abn.notify-me.ch"
        }
    }
}

extension Environment {
    static var userAgentHeader: String {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        let appVersion = [Bundle.appVersion].joined(separator: ".")
        let os = "iOS"
        let systemVersion = UIDevice.current.systemVersion
        let header = [bundleIdentifier, appVersion, os, systemVersion].joined(separator: ";")
        return header
    }

    static let shareURLKey: String = "ch.n2step.appclip.url.key"
}
