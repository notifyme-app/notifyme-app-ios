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

enum BigButtonStyle {
    case normal
    case outline
    case small
    case outlineSmall

    // special case
    case checkedIn
}

enum BigButtonColorStyle {
    case purple
    case red

    var color: UIColor {
        switch self {
        case .red: return .ns_red
        case .purple: return .ns_purple
        }
    }

    var lightColor: UIColor {
        switch self {
        case .red: return .ns_redLight
        case .purple: return .ns_purpleLight
        }
    }

    var darkColor: UIColor {
        switch self {
        case .red: return .ns_redDark
        case .purple: return .ns_purpleDark
        }
    }
}

class BigButton: UBButton {
    private let label: Label
    private let style: BigButtonStyle

    override var title: String? {
        get { super.title }
        set {
            super.title = ""
            accessibilityLabel = newValue
            label.text = newValue
        }
    }

    init(icon: UIImage? = nil) {
        style = .normal
        label = Label(.boldUppercase)

        super.init()
        setup()

        snp.makeConstraints { make in
            make.width.equalTo(72.0)
        }

        setImage(icon, for: .normal)

        backgroundColor = UIColor.white
        highlightedBackgroundColor = .ns_purpleLight
    }

    init(style: BigButtonStyle, icon: UIImage? = nil, text: String? = nil, colorStyle: BigButtonColorStyle = .purple) {
        self.style = style
        label = Label((style == .checkedIn) ? .navigationBarTitle : .boldUppercase)

        super.init()
        setup()

        let isOutline = style == .outline || style == .outlineSmall

        if isOutline || style == .checkedIn {
            setupIconAndText(icon: icon?.ub_image(with: .ns_purple), text: text)

            label.textColor = colorStyle.color
            backgroundColor = UIColor.white
            layer.borderColor = colorStyle.color.cgColor
            layer.borderWidth = 3.0
            highlightedBackgroundColor = colorStyle.lightColor

        } else {
            setupIconAndText(icon: icon?.ub_image(with: .white), text: text)
            backgroundColor = colorStyle.color
            highlightedBackgroundColor = colorStyle.darkColor
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        let isSmall = style == .small || style == .outlineSmall
        snp.makeConstraints { make in
            make.height.equalTo(isSmall ? 48.0 : 72.0)
        }

        layer.cornerRadius = isSmall ? 24.0 : 36.0
        highlightCornerRadius = isSmall ? 24.0 : 36.0
    }

    private func setupIconAndText(icon: UIImage? = nil, text: String? = nil) {
        let imageView = UIImageView(image: icon)
        imageView.ub_setContentPriorityRequired()

        addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Padding.mediumSmall)
        }

        addSubview(label)
        label.text = text

        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().inset(Padding.small)
            make.left.greaterThanOrEqualTo(imageView.snp.right).offset(Padding.small)
            make.centerX.equalToSuperview().priority(.medium)
        }
    }
}
