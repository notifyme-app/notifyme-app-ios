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

class ReportInformationView: UIView {
    private let titleLabel = Label(.title, textColor: .white)
    private let textLabel = Label(.text, textColor: .white)
    private let buttonLabel = Label(.boldUppercase, textColor: .white, textAlignment: .right)

    private let title: String
    private let text: String
    private let color: UIColor
    private let buttonTitle: String?

    private var button: UBButton?

    public var touchUpCallback: (() -> Void)? {
        didSet {
            button?.touchUpCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.touchUpCallback?()
            }
        }
    }

    init(title: String, text: String, color: UIColor, buttonTitle: String? = nil) {
        self.title = title
        self.text = text
        self.color = color
        self.buttonTitle = buttonTitle

        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        let isButton = buttonTitle != nil

        layer.cornerRadius = 36.0
        backgroundColor = color

        addSubview(titleLabel)
        titleLabel.text = title

        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Padding.mediumSmall + Padding.small)
            make.right.equalToSuperview().inset(Padding.large)
        }

        addSubview(textLabel)
        textLabel.text = text

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Padding.mediumSmall)
            make.left.equalToSuperview().inset(Padding.mediumSmall + Padding.small)
            make.right.equalToSuperview().inset(Padding.large)

            if !isButton {
                make.bottom.equalToSuperview().inset(Padding.mediumSmall + Padding.small)
            }
        }

        if isButton {
            buttonLabel.text = buttonTitle

            addSubview(buttonLabel)

            buttonLabel.snp.makeConstraints { make in
                make.top.equalTo(self.textLabel.snp.bottom).offset(Padding.mediumSmall)
                make.left.equalToSuperview().inset(Padding.mediumSmall + Padding.small)
                make.right.equalToSuperview().inset(Padding.large + Padding.mediumSmall)
                make.bottom.equalToSuperview().inset(Padding.large)
            }

            let imageView = UIImageView(image: UIImage(named: "icons-ic-chevron-right")?.ub_image(with: .white))
            addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.centerY.equalTo(self.buttonLabel)
                make.left.equalTo(self.snp.right).inset(Padding.large)
            }

            let b = UBButton()
            insertSubview(b, at: 0)

            b.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            b.highlightCornerRadius = layer.cornerRadius
            button = b
            b.highlightedBackgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }
}
