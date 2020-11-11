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

import CrowdNotifierSDK
import Foundation

class VenueView: UIView {
    // MARK: - Views

    private let stackView = UIStackView()

    private let titleLabel = Label(.title, textAlignment: .center)
    private let subtitleLabel = Label(.subtitle, textAlignment: .center)
    private let textLabel = Label(.text, textAlignment: .center)

    // MARK: - Properties

    private let icon: Bool
    public var venue: VenueInfo? {
        didSet {
            update()
        }
    }

    // MARK: - Init

    init(venue: VenueInfo? = nil, icon: Bool = true) {
        self.venue = venue
        self.icon = icon

        super.init(frame: .zero)
        setup()
        update()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update

    private func update() {
        titleLabel.text = venue?.name
        subtitleLabel.text = venue?.room
        textLabel.text = venue?.location
    }

    // MARK: - Setup

    private func setup() {
        stackView.axis = .vertical

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        if icon {
            let view = UIView()
            let imageView = UIImageView(image: UIImage(named: "venue"))
            imageView.ub_setContentPriorityRequired()
            view.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.bottom.centerX.equalToSuperview()
            }

            stackView.addArrangedSubview(view)
            stackView.addSpacerView(Padding.mediumSmall)
        }

        stackView.addArrangedSubview(titleLabel)
        stackView.addSpacerView(4.0)

        stackView.addArrangedSubview(subtitleLabel)
        stackView.addSpacerView(Padding.small + 4.0)

        stackView.addArrangedSubview(textLabel)
    }
}
