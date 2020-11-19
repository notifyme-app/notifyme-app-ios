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

    private let errorViewContainer = UIView()
    private let errorView = ErrorView()

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

        // Error view
        errorViewContainer.addSubview(errorView)
        stackScrollView.addArrangedView(errorViewContainer)

        errorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview().inset(Padding.mediumSmall)
        }

        errorView.errorCallback = handleError(_:)

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
            errorViewContainer.isHidden = state.errorState.error == nil

        case let .exposure(exposure, _):
            title = exposure.count > 1 ? "report_title_plural".ub_localized.replacingOccurrences(of: "{NUMBER}", with: "\(exposure.count)") : "report_title_singular".ub_localized
            noReportInformationView.isHidden = true
            reportsInformationViewController.view.isHidden = false
            errorViewContainer.isHidden = true // When there are exposure, we need to show the error view in the collectionView
        }

        errorView.errorModel = state.errorState.error
    }
}

extension ReportsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewContentOffsetDelegate?.didUpdateContentOffset(s: scrollView.contentOffset)
    }
}
