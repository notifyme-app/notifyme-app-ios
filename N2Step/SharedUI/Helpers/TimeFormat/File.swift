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

extension TimeInterval {
    private var seconds: String {
        let value = Int(self) % 60
        return value < 10 ? "0\(value)" : "\(value)"
    }

    private var minutes: String {
        let value = (Int(self) / 60) % 60
        return value < 10 ? "0\(value)" : "\(value)"
    }

    private var hours: String {
        let value = Int(self) / 3600
        return value < 10 ? "0\(value)" : "\(value)"
    }

    public func ns_formatTime() -> String {
        if hours != "00" {
            return "\(hours):\(minutes):\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
}
