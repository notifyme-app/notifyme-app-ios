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

    private let stackScrollView = StackScrollView(axis: .vertical, spacing: 0)

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
        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // view for no reports
        let v = UIView()
        v.addSubview(noReportInformationView)

        stackScrollView.addArrangedView(v)

        noReportInformationView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackScrollView.scrollView.delegate = self

        // view with reports
        addSubviewController(vc: reportsInformationViewController)
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.exposureState {
        case .noExposure:
            title = "no_report_title".ub_localized
            noReportInformationView.isHidden = false
            reportsInformationViewController.view.isHidden = true

        case let .exposure(exposure, _):
            title = exposure.count > 1 ? "report_title_plural".ub_localized.replacingOccurrences(of: "{NUMBER}", with: "\(exposure.count)") : "report_title_singular".ub_localized
            noReportInformationView.isHidden = true
            reportsInformationViewController.view.isHidden = false
        }
    }
}

extension ReportsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewContentOffsetDelegate?.didUpdateContentOffset(s: scrollView.contentOffset)
    }
}
