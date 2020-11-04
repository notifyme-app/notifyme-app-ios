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

class DairyDateSectionHeaderSupplementaryView: UICollectionReusableView {
    let label = Label(.boldUppercaseSmall, textColor: .ns_text)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(label)

        label.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Padding.small, bottom: Padding.small, right: Padding.small))
        }

        // TODO: fix date
        label.text = "Thursday 22.10"
    }
}
