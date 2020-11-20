/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import UIKit

public extension UIColor {
    static var ns_text: UIColor = .black

    static var ns_green: UIColor = UIColor(ub_hexString: "#00a690")!
    static var ns_purple: UIColor = UIColor(ub_hexString: "#413f8d")!
    static var ns_purpleDark: UIColor = UIColor(ub_hexString: "#292859")!
    static var ns_purpleLight: UIColor = UIColor(ub_hexString: "#DDDCEA")!

    static var ns_genericTouchState = UIColor.black.withAlphaComponent(0.1)

    static var ns_red: UIColor = UIColor(ub_hexString: "#f34e70")!
    static var ns_redLight: UIColor = UIColor(ub_hexString: "#fdedf0")!
    static var ns_redDark: UIColor = UIColor(ub_hexString: "#d00e36")!

    static var ns_grayBackground = UIColor(ub_hexString: "#f2f2f2")!

    static var ns_error: UIColor = UIColor(ub_hexString: "#e20008")!
}
