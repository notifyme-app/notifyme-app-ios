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

import UIKit

class SmallErrorView: UIView {
    private let iconView = UIImageView()

    var errorModel: ErrorViewModel? {
        didSet { update() }
    }

    init(errorModel _: ErrorViewModel? = nil) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .ns_grayBackground

        snp.makeConstraints { make in
            make.size.equalTo(62)
        }

        iconView.ub_setContentPriorityRequired()
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        layer.cornerRadius = 31
    }

    private func update() {
        iconView.image = errorModel?.icon
    }
}
