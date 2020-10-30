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
import SnapKit

class BigButton: UBButton {
    init(icon _: UIImage? = nil) {
        super.init()
        setup()

        snp.makeConstraints { make in
            make.width.equalTo(72.0)
        }

        backgroundColor = UIColor.blue
    }

    init(icon _: UIImage? = nil, text: String? = nil, color _: UIColor? = nil) {
        super.init()
        setup()
        setTitle(text, for: .normal)
        backgroundColor = UIColor.green
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        snp.makeConstraints { make in
            make.height.equalTo(72.0)
        }

        layer.cornerRadius = 36.0
    }
}
