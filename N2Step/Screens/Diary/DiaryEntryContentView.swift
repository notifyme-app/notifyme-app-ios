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

    public var checkIn: CheckIn? {
        didSet { update() }
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
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

    // MARK: - Update

    private func update() {
        roomLabel.text = checkIn?.venue.room
        venueLabel.text = checkIn?.venue.location

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        timeLabel.text = [checkIn?.checkInTime, checkIn?.checkOutTime].compactMap { (date) -> String? in
            if let d = date {
                return formatter.string(from: d)
            } else { return nil }
        }.joined(separator: " – ")
    }
}
