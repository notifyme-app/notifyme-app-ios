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

    private let checkImageView = UIImageView()

    private let imageTextView = ImageTextView()

    public var checkIn: CheckIn? {
        didSet { update() }
    }

    public var exposure: Exposure? {
        didSet { updateExposure() }
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
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(Padding.small)
        }

        addSubview(imageTextView)
        imageTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Padding.mediumSmall)
            make.top.equalToSuperview().inset(Padding.small + 3.0)
            make.bottom.equalToSuperview().inset(Padding.small)
            make.right.lessThanOrEqualTo(self.checkImageView.snp.left).offset(-5.0)
        }

        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(Padding.small)
        }
    }

    // MARK: - Update

    private func updateExposure() {
        if let d = exposure?.diaryEntry {
            checkIn = d
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"

            if let e = exposure?.exposureEvent {
                imageTextView.title = [e.arrivalTime, e.departureTime].compactMap { (date) -> String? in
                    formatter.string(from: date)
                }.joined(separator: " – ")
                imageTextView.text = ""
            }
        }

        checkImageView.image = UIImage(named: "icons-ic-red-info")
    }

    private func update() {
        checkImageView.image = UIImage(named: "icons-ic-check-filled")

        imageTextView.title = checkIn?.venue.location

        var texts: [String?] = []
        texts.append(checkIn?.venue.room)

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let timeText = [checkIn?.checkInTime, checkIn?.checkOutTime].compactMap { (date) -> String? in
            if let d = date {
                return formatter.string(from: d)
            } else { return nil }
        }.joined(separator: " – ")

        texts.append(timeText)

        imageTextView.text = texts.compactMap { $0 }.joined(separator: "\n")
    }
}
