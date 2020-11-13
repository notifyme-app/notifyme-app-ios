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

    init(title: String, text: String, color: UIColor) {
        self.title = title
        self.text = text
        self.color = color

        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        // let isButton = buttonTitle != nil

        layer.cornerRadius = 36.0
        backgroundColor = color

        titleLabel.text = title
        textLabel.text = text

        let stackView = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        stackView.axis = .vertical
        stackView.spacing = Padding.medium - Padding.small
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Padding.mediumSmall + Padding.small)
            make.right.equalToSuperview().inset(Padding.large)
            make.bottom.equalToSuperview().inset(Padding.mediumSmall + Padding.small)
        }

        // needed for collection view cell content to layout correctly
        titleLabel.ub_setContentPriorityRequired()
        textLabel.ub_setContentPriorityRequired()
    }
}
