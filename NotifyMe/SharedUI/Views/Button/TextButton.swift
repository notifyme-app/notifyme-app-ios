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
    private let labelFont: UIFont = LabelType.boldUppercase.font

    init(text: String, textColor: UIColor = .ns_purple, underlined: Bool = false) {
        self.textColor = textColor
        self.underlined = underlined

        super.init()

        if underlined {
            let attributedText = NSAttributedString(string: text, attributes: [
                .font: labelFont,
                .foregroundColor: textColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ])
            setAttributedTitle(attributedText, for: .normal)
        } else {
            let attributedText = NSAttributedString(string: text, attributes: [
                .font: labelFont,
                .foregroundColor: textColor,
            ])
            setAttributedTitle(attributedText, for: .normal)
        }

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
            titleLabel?.text
        }
        set {
            if underlined {
                let attributedText = NSAttributedString(string: newValue ?? "", attributes: [
                    .font: labelFont,
                    .foregroundColor: textColor,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                ])
                setAttributedTitle(attributedText, for: .normal)
            } else {
                let attributedText = NSAttributedString(string: newValue ?? "", attributes: [
                    .font: labelFont,
                    .foregroundColor: textColor,
                ])
                setAttributedTitle(attributedText, for: .normal)
            }
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
