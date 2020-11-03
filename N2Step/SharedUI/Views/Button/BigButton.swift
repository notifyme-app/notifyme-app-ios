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
    private let label = Label(.boldUppercase)

    override var title: String? {
        get { super.title }
        set {
            super.title = newValue
            label.text = newValue
        }
    }

    init(icon: UIImage? = nil) {
        super.init()
        setup()

        snp.makeConstraints { make in
            make.width.equalTo(72.0)
        }

        setImage(icon, for: .normal)

        backgroundColor = UIColor.white
        highlightedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    init(icon: UIImage? = nil, text: String? = nil, color: UIColor? = nil, outline: Bool = false) {
        super.init()
        setup()
        setupIconAndText(icon: icon, text: text)

        if outline {
            label.textColor = color
            backgroundColor = UIColor.white
            layer.borderColor = color?.cgColor
            layer.borderWidth = 3.0
        } else {
            backgroundColor = color
        }
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
        highlightCornerRadius = 36.0
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
