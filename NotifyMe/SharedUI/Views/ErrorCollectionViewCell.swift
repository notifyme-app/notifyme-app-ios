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

class ErrorCollectionViewCell: UICollectionViewCell {
    public let errorView = ErrorView()

    override init(frame _: CGRect) {
        super.init(frame: .zero)

        backgroundColor = .clear
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.lessThanOrEqualTo(self.snp.width)
        }
    }
}
