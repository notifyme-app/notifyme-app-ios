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

    private let reportButton = ReportButton()
    private let noReportLabel = Label(.heroTitle)

    // MARK: - API

    public var reportsTouchUpCallback: (() -> Void)? {
        didSet { self.reportButton.touchUpCallback = self.reportsTouchUpCallback }
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

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.exposureState {
        case .noExposure:
            noReportLabel.isHidden = false
            reportButton.setContent(title: "no_report_title".ub_localized, error: state.errorState.error)

        case let .exposure(exposure, _):
            noReportLabel.isHidden = true
            let title = exposure.count > 1 ? "report_title_plural".ub_localized.replacingOccurrences(of: "{NUMBER}", with: "\(exposure.count)") : "report_title_singular".ub_localized

            let d = exposure.first?.exposureEvent.arrivalTime ?? Date()
            let subText = d.ns_daysAgo()

            reportButton.setContent(title: title, message: "report_message_text".ub_localized, messageHighlight: "report_message_text_highlight".ub_localized, subText: subText, error: state.errorState.error)
        }
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .vertical

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackView.addArrangedView(reportButton)
        stackView.addSpacerView(Padding.mediumSmall)

        let view = UIView()
        view.addSubview(noReportLabel)

        noReportLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackView.addArrangedView(view)

        noReportLabel.text = "no_report_hero_text".ub_localized
        noReportLabel.addHighlight(text: "no_report_hero_text_highlight".ub_localized, color: UIColor.ns_green)

        reportButton.errorCallback = handleError(_:)
    }
}
