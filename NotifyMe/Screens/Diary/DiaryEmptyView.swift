//
/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation

class DiaryEmptyView: UIView {
    private let stackView = UIStackView()
    private let imageView = UIImageView(image: UIImage(named: "illus-empty-diary"))
    private let titleLabel = Label(.textBold, textAlignment: .center)
    private let textLabel = Label(.text, textAlignment: .center)

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        stackView.axis = .vertical
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.0 * Padding.large)
            make.right.left.equalToSuperview().inset(Padding.medium + Padding.small)
        }

        let imageAroundView = UIView()
        imageAroundView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        let titleView = UIView()
        titleView.addSubview(titleLabel)

        titleLabel.text = "empty_diary_title".ub_localized

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: Padding.medium, left: Padding.mediumSmall, bottom: 0, right: Padding.mediumSmall))
        }

        let textView = UIView()
        textView.addSubview(textLabel)

        textLabel.text = "empty_diary_text".ub_localized

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: Padding.small, left: Padding.mediumSmall, bottom: 0, right: Padding.mediumSmall))
        }

        stackView.addArrangedView(imageAroundView)
        stackView.addArrangedView(titleView)
        stackView.addArrangedView(textView)
    }
}
