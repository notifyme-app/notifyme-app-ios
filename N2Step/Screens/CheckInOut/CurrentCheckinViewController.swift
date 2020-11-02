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

class CurrentCheckinViewController : BaseViewController
{
    private let contentView = StackScrollView()
    private let checkOutButton = BigButton(text: "checkout_button_title".ub_localized)

    public var checkIn : CheckIn? {
        didSet { self.update() }
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: - Setup

    private func setup()
    {
        self.view.addSubview(self.contentView)

        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.contentView.addArrangedView(UIImageView(image: UIImage(named: "illus-tea-big")))
        self.contentView.addSubview(VenueView())

        self.contentView.addArrangedView(self.checkOutButton)

        self.checkOutButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presentCheckOutScreen()
        }
    }

    // MARK: - Present

    public func presentCheckOutScreen()
    {
        self.present(CheckOutViewController(), animated: true, completion: nil)
    }

    // MARK: - Update

    private func update()
    {
        // TODO: update venue view & time
    }
}
