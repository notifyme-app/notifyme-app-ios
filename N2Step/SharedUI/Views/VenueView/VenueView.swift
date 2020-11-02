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
import N2StepSDK

class VenueView : UIView
{
    private let stackView = UIStackView()

    init(venue: VenueInfo? = nil)
    {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup()
    {
        self.stackView.axis = .vertical

        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "venue"))
        imageView.ub_setContentPriorityRequired()
        view.addSubview(imageView)

        imageView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
        }

        self.stackView.addArrangedSubview(view)

        let titleLabel = Label(.title, textAlignment: .center)
        titleLabel.text = "Cybercafe SV"

        self.stackView.addArrangedSubview(titleLabel)

        let subtitleLabel = Label(.subtitle, textAlignment: .center)
        subtitleLabel.text = "EPFL Campus"

        self.stackView.addArrangedSubview(subtitleLabel)

        let textLabel = Label(.text, textAlignment: .center)
        textLabel.text = "Lausanne"

        self.stackView.addArrangedSubview(textLabel)
    }


}
