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

class CheckOutViewController: CenterContentViewController {

    private let checkOutButton = BigButton(text: "checkout_button_title".ub_localized)

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupCheckout()
    }

    // MARK: - Setup

    private func setupCheckout()
    {
        self.checkOutButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }

            CurrentCheckinManager.shared.checkOut()

            let presentingVC = strongSelf.presentingViewController
            strongSelf.dismiss(animated: true) {
                if let nvc = presentingVC as? UINavigationController {
                    nvc.popToRootViewController(animated: true)
                } else {
                    presentingVC?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

    private func setup() {

        let venueView = VenueView()
        self.contentView.addArrangedView(venueView)

        self.contentView.addSpacerView(Padding.medium)

        self.contentView.addArrangedView(self.checkOutButton)
    }
}
