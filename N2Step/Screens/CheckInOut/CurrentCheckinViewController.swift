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

class CurrentCheckinViewController: BaseViewController {
    private let contentView = StackScrollView()
    private let checkOutButton = BigButton(style: .normal, text: "checkout_button_title".ub_localized)

    public var checkIn: CheckIn? {
        didSet { self.update() }
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let isSmaller = view.frame.size.width < 375

        let imageView = UIImageView(image: UIImage(named: "illus-tea-big")?.ub_image(byScaling: isSmaller ? 0.6 : 1.0))
        imageView.ub_setContentPriorityRequired()

        let v = UIView()
        v.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.right.left.lessThanOrEqualToSuperview().inset(Padding.medium)
        }

        contentView.addSpacerView(Padding.large)
        contentView.addArrangedView(v)

        contentView.addSpacerView(Padding.large + Padding.small)
        contentView.addArrangedView(VenueView(icon: false))

        contentView.addSpacerView(Padding.large)

        let v2 = UIView()
        v2.addSubview(checkOutButton)
        checkOutButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.right.left.lessThanOrEqualToSuperview().inset(Padding.medium).priority(.low)
        }

        contentView.addArrangedView(v2)

        checkOutButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presentCheckOutScreen()
        }
    }

    // MARK: - Present

    public func presentCheckOutScreen() {
        present(CheckinEditViewController(), animated: true, completion: nil)
    }

    // MARK: - Update

    private func update() {
        // TODO: update venue view & time
    }
}
