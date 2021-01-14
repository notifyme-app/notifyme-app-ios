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
import SnapKit

class ReportWhatToDoView: UIView {
    private let titleLabel = Label(.boldUppercaseSmall, textColor: .ns_red)
    private let messageLabel = Label(.text)

    public var message: String? {
        didSet { messageLabel.text = message }
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 8.0
        backgroundColor = .ns_redLight

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6.0

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(1.5 * Padding.small)
        }

        stackView.addArrangedView(titleLabel)
        stackView.addArrangedView(messageLabel)

        titleLabel.text = "report_information_button_title".ub_localized
    }
}
