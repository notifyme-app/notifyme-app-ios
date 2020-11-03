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

class CheckInButton: UIView {
    public var touchUpCallback: (() -> Void)? {
        didSet {
            checkInButton.touchUpCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.touchUpCallback?()
            }
        }
    }

    private let checkInButton = BigButton(icon: UIImage(named: "icons-ic-qr"), text: "checkin_button_title".ub_localized, color: UIColor.ns_purple)

    private let textLabel = Label(.boldUppercase)

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.checkInState {
        case .noCheckIn:
            textLabel.isHidden = true

        case .checkIn:
            break
            // TODO: checked in case
        }
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Padding.small

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // TODO: label
        textLabel.text = "you are checked in"

        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(checkInButton)
    }
}
