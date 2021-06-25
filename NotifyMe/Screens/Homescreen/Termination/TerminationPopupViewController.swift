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

class TerminationPopupViewController: CenterContentViewController {
    private let titleLabel = Label(.title)
    private let textLabel = Label(.text)

    private let moreInfoButton = BigButton(style: .small, text: "app_termination_button_title".ub_localized, colorStyle: .red)

    public var moreInfoCallback: (() -> Void)? {
        didSet {
            moreInfoButton.touchUpCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true) {
                    strongSelf.moreInfoCallback?()
                }
            }
        }
    }

    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = "app_termination_title".ub_localized
        textLabel.isHtmlContent = true
        textLabel.text = "app_termination_text".ub_localized

        contentView.addArrangedView(titleLabel)
        contentView.addSpacerView(Padding.mediumSmall)
        contentView.addArrangedView(textLabel)
        contentView.addSpacerView(Padding.medium)

        let v2 = UIView()
        v2.addSubview(moreInfoButton)

        moreInfoButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.left.greaterThanOrEqualToSuperview()
        }

        contentView.addArrangedView(v2)
    }
}
