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

    private let checkInButton = BigButton(text: "check_in_now_button_title".ub_localized, color: .ns_purple, outline: true)

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
        setup()
        setupCheckin()
    }

    // MARK: - Setup

    private func setupCheckin() {
        checkInButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            if CurrentCheckinManager.shared.checkIn(qrCode: strongSelf.qrCode) {
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                // TODO: error handling!
            }
        }
    }

    private func setup() {
        let venueView = VenueView()
        contentView.addArrangedView(venueView)
        contentView.addSpacerView(Padding.mediumSmall)
        contentView.addArrangedView(checkInButton)

        // TODO: Diary.
    }
}
