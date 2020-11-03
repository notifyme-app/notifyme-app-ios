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

class ReportsInformationViewController: BaseSubViewController {
    private let stackScrollView = StackScrollView(axis: .vertical, spacing: 0)

    private let reportInformationView = ReportInformationView(title: "report_information_title".ub_localized, text: "report_information_text".ub_localized, color: .ns_red, buttonTitle: "report_information_button_title".ub_localized)

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(stackScrollView)

        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let v = UIView()
        v.addSubview(reportInformationView)

        reportInformationView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackScrollView.addArrangedView(v)
    }
}
