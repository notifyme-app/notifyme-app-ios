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

    private let title: String
    private let text: String
    private let color: UIColor
    private let buttonTitle: String?

    private let button: UBButton? = nil

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
            // TODO.
        }
    }
}
