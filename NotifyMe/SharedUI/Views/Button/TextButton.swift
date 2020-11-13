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

class TextButton: UBButton {
    // MARK: - Init

    init(text: String) {
        super.init()
        title = text
        titleLabel?.font = LabelType.boldUppercase.font
        setTitleColor(.ns_purple, for: .normal)
        highlightedBackgroundColor = UIColor.ns_genericTouchState
        highlightCornerRadius = 3.0

        highlightXInset = -5.0
        highlightYInset = 5.0

        snp.makeConstraints { make in
            make.height.equalTo(44.0)
        }
    }

    override var title: String? {
        get { super.title }
        set { super.title = newValue?.uppercased() }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
