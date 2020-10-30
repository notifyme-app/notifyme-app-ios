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

class CheckInConfirmViewController: CenterContentViewController {
    private let qrCode: String

    private let checkInButton = BigButton(text: "check_in_now_button_title".ub_localized)

    // MARK: - Init

    init(qrCode: String) {
        self.qrCode = qrCode
        super.init()

        title = qrCode
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: - Setup

    private func setup() {

        let label = UILabel()
        label.text = qrCode
        label.textAlignment = .center
        label.textColor = .black

        self.contentView.addArrangedView(label)

        self.contentView.addSpacerView(Padding.medium)

        let button = BigButton(text: "Check-in now")

        self.contentView.addArrangedView(button)
    }
}
