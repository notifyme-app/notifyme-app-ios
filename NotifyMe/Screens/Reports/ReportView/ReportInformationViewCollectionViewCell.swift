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

class ReportInformationViewCollectionViewCell: UICollectionViewCell {
    public let informationView = ReportInformationView(title: "report_information_title".ub_localized, text: "report_information_text".ub_localized, color: .ns_red)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(informationView)

        informationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.lessThanOrEqualTo(self.snp.width)
        }
    }
}
