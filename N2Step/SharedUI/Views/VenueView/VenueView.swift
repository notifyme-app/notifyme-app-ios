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

class VenueView: UIView {
    private let stackView = UIStackView()

    init(venue _: VenueInfo? = nil) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        stackView.axis = .vertical

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "venue"))
        imageView.ub_setContentPriorityRequired()
        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }

        stackView.addArrangedSubview(view)

        let titleLabel = Label(.title, textAlignment: .center)
        titleLabel.text = "Cybercafe SV"

        stackView.addArrangedSubview(titleLabel)

        let subtitleLabel = Label(.subtitle, textAlignment: .center)
        subtitleLabel.text = "EPFL Campus"

        stackView.addArrangedSubview(subtitleLabel)

        let textLabel = Label(.text, textAlignment: .center)
        textLabel.text = "Lausanne"

        stackView.addArrangedSubview(textLabel)
    }
}
