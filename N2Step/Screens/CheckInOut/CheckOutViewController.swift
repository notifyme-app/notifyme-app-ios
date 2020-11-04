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
    private let checkOutButton = BigButton(style: .normal, text: "checkout_button_title".ub_localized)

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCheckout()
    }

    // MARK: - Setup

    private func setupCheckout() {
        checkOutButton.touchUpCallback = { [weak self] in
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
        contentView.addArrangedView(venueView)

        contentView.addSpacerView(Padding.medium)

        let v = UIView()
        v.addSubview(checkOutButton)

        checkOutButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.right.left.lessThanOrEqualToSuperview().inset(Padding.medium).priority(.low)
        }

        contentView.addArrangedView(v)

        // TODO:
    }
}
