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

class HomescreenTerminationView: UIView {
    var buttonTouchUpCallback: (() -> Void)? {
        get { button.touchUpCallback }
        set { button.touchUpCallback = newValue }
    }

    private let titleLabel = Label(.title, textColor: .white, textAlignment: .center)
    private let button = BigButton(style: .small, text: "app_termination_homescreen_button_title".ub_localized, colorStyle: .redInverted)

    init() {
        super.init(frame: .zero)
        titleLabel.text = "app_termination_homescreen_text".ub_localized
        setupLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.mediumSmall)
            make.leading.trailing.equalToSuperview().inset(Padding.medium)
        }

        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Padding.medium - 1.0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(44.0)
        }
    }
}
