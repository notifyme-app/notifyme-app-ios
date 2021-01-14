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

class OnboardingStepViewController: BaseViewController {
    public var buttonTouchUpCallback: (() -> Void)?

    internal let button = BigButton(style: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setup()
    }

    public var viewsInTopOrder: [UIView] = []

    // MARK: - Setup

    private func setup() {
        view.addSubview(button)

        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().inset(Padding.mediumSmall)
            make.right.lessThanOrEqualToSuperview().inset(Padding.mediumSmall)
            make.bottom.equalTo(self.view.snp_bottomMargin).inset(Padding.mediumSmall)
        }

        button.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.buttonTouchUpCallback?()
        }
    }
}
