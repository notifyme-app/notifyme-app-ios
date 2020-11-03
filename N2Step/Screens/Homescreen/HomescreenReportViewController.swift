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

class HomescreenReportViewController: BaseSubViewController {
    // MARK: - Private parts

    let noReportsView = ReportButton()
    let noReportLabel = Label(.heroTitle)

    // MARK: - API

    public var reportsTouchUpCallback: (() -> Void)? {
        didSet { self.noReportsView.touchUpCallback = self.reportsTouchUpCallback }
    }

    // MARK: - Init

    override init() {
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        noReportsView.setContent(title: "no_report_title".ub_localized)
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .vertical

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackView.addArrangedView(noReportsView)
        stackView.addSpacerView(Padding.mediumSmall)

        let view = UIView()
        view.addSubview(noReportLabel)

        noReportLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackView.addArrangedView(view)

        noReportLabel.text = "no_report_hero_text".ub_localized
    }
}
