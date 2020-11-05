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

class RemoveFromDiaryWarningViewController: CenterContentViewController {
    private let titleLabel = Label(.title)
    private let textLabel = Label(.text)
    private let explanationLabel = Label(.text)

    private let removeNowButton = BigButton(style: .small, text: "remove_diary_remove_now_button".ub_localized)

    // MARK: - Init

    override init() {
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = "remove_diary_warning_title".ub_localized
        textLabel.text = "remove_diary_warning_text".ub_localized
        explanationLabel.text = "remove_diary_warning_star_text".ub_localized

        contentView.addArrangedView(titleLabel)
        contentView.addSpacerView(Padding.mediumSmall)
        contentView.addArrangedView(textLabel)
        contentView.addSpacerView(Padding.medium)
        contentView.addArrangedView(explanationLabel)
        contentView.addSpacerView(Padding.medium)

        let v = UIView()
        v.addSubview(removeNowButton)

        removeNowButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.left.right.lessThanOrEqualToSuperview()
        }

        contentView.addArrangedView(v)
    }
}
