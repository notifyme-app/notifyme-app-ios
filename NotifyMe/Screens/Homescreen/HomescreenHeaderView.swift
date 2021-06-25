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

class HomescreenHeaderView: UIView {
    private let titleLabel = Label(.textBold)
    private let image = UIImage(named: "icons-ic-info-outline")!
    private let infoButton: BigButton

    // MARK: - API

    public var infoButtonPressed: (() -> Void)?

    // MARK: - Init

    init() {
        infoButton = BigButton(icon: image)
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        infoButton.snp.remakeConstraints { make in
            make.height.width.equalTo(44.0)
        }

        infoButton.layer.cornerRadius = 44.0 * 0.5
        infoButton.highlightCornerRadius = 44.0 * 0.5

        addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.right.equalToSuperview().inset(Padding.mediumSmall - (44.0 - image.size.width) * 0.5)
            make.bottom.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().inset(Padding.mediumSmall)
            make.right.lessThanOrEqualTo(infoButton.snp.left).offset(-Padding.mediumSmall)
        }

        titleLabel.text = "app_name".ub_localized
        titleLabel.addHighlight(text: "app_name_highlight".ub_localized, color: .ns_purple)

        infoButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.infoButtonPressed?()
        }
    }
}
