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

class ModalReportViewController: ModalBaseViewController {
    private let exposure: Exposure

    private let heroTitle = Label(.heroTitle)
    private let whatToDoView = ReportWhatToDoView()
    private let informationView: ModalReportInformationView

    // MARK: - Init

    init(exposure: Exposure) {
        self.exposure = exposure
        informationView = ModalReportInformationView(exposure: exposure)
        super.init(horizontalContentInset: Padding.mediumSmall)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        dismissButton.title = "new_exposure_close_button".ub_localized

        if #available(iOS 13.0, *) {
            isModalInPresentation = false
        } else {
            // Fallback on earlier versions
        }

        contentView.addArrangedView(heroTitle)

        heroTitle.text = "report_message_text".ub_localized
        heroTitle.addHighlight(text: "report_message_text_highlight".ub_localized, color: .ns_red)

        contentView.addSpacerView(Padding.medium)
        contentView.addArrangedView(informationView)

        contentView.addSpacerView(Padding.medium)
        contentView.addArrangedView(whatToDoView)

        whatToDoView.message = exposure.exposureEvent.message
    }
}
