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

class HomescreenReportViewController : BaseSubViewController
{
    // MARK: - Private parts

    let noReportsView = BigButton(text: "no_report_title".ub_localized)
    let noReportLabel = Label(.heroTitle)

    // MARK: - API

    public var reportsTouchUpCallback : (() -> ())? = nil
    {
        didSet { self.noReportsView.touchUpCallback = self.reportsTouchUpCallback }
    }

    // MARK: - Init

    override init()
    {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: - Setup

    private func setup()
    {
        let stackView = UIStackView()
        stackView.axis = .vertical

        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(Padding.medium)
        }

        stackView.addArrangedView(noReportsView)
        stackView.addSpacerView(Padding.medium)
        stackView.addArrangedView(noReportLabel)

        self.noReportLabel.text = "no_report_hero_text".ub_localized
    }
}
