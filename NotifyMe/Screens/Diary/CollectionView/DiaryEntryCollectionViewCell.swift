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

class DiaryEntryCollectionViewCell: UICollectionViewCell {
    // MARK: - Content view

    private let diaryContentView = DiaryEntryContentView()

    public var checkIn: CheckIn? {
        didSet { diaryContentView.checkIn = checkIn }
    }

    public var exposure: Exposure? {
        didSet { self.diaryContentView.exposure = exposure }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        layer.cornerRadius = 5.0
        ub_addShadow(radius: 5.0, opacity: 0.17, xOffset: 0, yOffset: 2.0)

        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(diaryContentView)

        diaryContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Highlight

    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            super.isHighlighted = newValue
            contentView.backgroundColor = newValue ? UIColor.ns_genericTouchState : UIColor.clear
        }
    }
}
