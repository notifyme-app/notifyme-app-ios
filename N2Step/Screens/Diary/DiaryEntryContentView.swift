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

class DiaryEntryContentView: UIView {
    // MARK: - Subviews

    private let imageView = UIImageView(image: UIImage(named: "illus-meeting"))
    private let checkImageView = UIImageView(image: UIImage(named: "icons-ic-check-filled"))

    private let roomLabel = Label(.textBold)
    private let venueLabel = Label(.text)
    private let timeLabel = Label(.text, textColor: .ns_purple)

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()

        // TODO: set real values
        roomLabel.text = "Meeting Room IP32"
        venueLabel.text = "EPFL Campus, Lausanne"
        timeLabel.text = "10:01 – 11:35"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Padding.mediumSmall)
            make.top.equalToSuperview().inset(Padding.small + 2.0)
        }

        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(Padding.small)
        }

        let stackView = UIStackView(arrangedSubviews: [roomLabel, venueLabel, timeLabel])
        stackView.axis = .vertical
        stackView.spacing = 2.0

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(self.imageView.snp.right).offset(Padding.small + 5.0)
            make.top.bottom.equalToSuperview().inset(Padding.small)
            make.right.lessThanOrEqualTo(self.checkImageView.snp.left).offset(-5.0)
        }
    }
}
