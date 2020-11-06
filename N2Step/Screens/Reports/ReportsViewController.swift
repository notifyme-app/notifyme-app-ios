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

class ReportsViewController: BaseViewController {
    // MARK: - SubviewController

    private let noReportInformationView = ReportInformationView(title: "no_report_information_title".ub_localized, text: "no_report_information_text".ub_localized, color: .ns_green)

    private let reportsInformationViewController = ReportsInformationViewController()

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    // MARK: - Setup

    private func setup() {
        // view for no reports
        view.addSubview(noReportInformationView)

        noReportInformationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        // view with reports
        addChild(reportsInformationViewController)
        view.addSubview(reportsInformationViewController.view)

        reportsInformationViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        reportsInformationViewController.didMove(toParent: self)
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.exposureState {
        case .noExposure:
            title = "no_report_title".ub_localized
            noReportInformationView.isHidden = false
            reportsInformationViewController.view.isHidden = true

        case let .exposure(events):
            title = events.count > 1 ? "report_title_plural".ub_localized.replacingOccurrences(of: "{NUMBER}", with: "\(events.count)") : "report_title_singular".ub_localized
            noReportInformationView.isHidden = true
            reportsInformationViewController.view.isHidden = false
        }
    }
}
