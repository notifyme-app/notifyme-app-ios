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

    private let textColor: UIColor
    private let underlined: Bool
    private let label: Label

    init(text: String, textColor: UIColor = .ns_purple, underlined: Bool = false, lightFont: Bool = false) {
        self.textColor = textColor
        self.underlined = underlined
        label = Label(lightFont ? .lightUppercase : .boldUppercase)

        super.init()

        // set properties first
        label.textColor = textColor
        titleLabel?.font = label.font
        titleLabel?.textColor = textColor

        // then title, that update works
        title = text

        highlightedBackgroundColor = UIColor.ns_genericTouchState
        highlightCornerRadius = 3.0

        highlightXInset = -5.0
        highlightYInset = 5.0

        snp.makeConstraints { make in
            make.height.equalTo(44.0)
        }
    }

    override var title: String? {
        get {
            super.title
        }
        set {
            super.title = newValue
            label.text = newValue
            updateTitle()
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateTitle() {
        if underlined {
            let attributedText = NSAttributedString(string: title ?? "", attributes: [
                .font: label.font!,
                .foregroundColor: textColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ])
            setAttributedTitle(attributedText, for: .normal)
        } else {
            setAttributedTitle(label.attributedText, for: .normal)
        }
    }
}
