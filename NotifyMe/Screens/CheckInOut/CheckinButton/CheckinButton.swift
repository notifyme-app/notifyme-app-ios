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

            checkedInButton.touchUpCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.touchUpCallback?()
            }
        }
    }

    private var titleTimer: Timer?
    private var checkIn: CheckIn?

    private let checkInButton = BigButton(style: .normal, icon: UIImage(named: "icons-ic-qr"), text: "checkin_button_title".ub_localized)

    private let checkedInButton = BigButton(style: .checkedIn, icon: UIImage(named: "icons-ic-check-filled")?.ub_image(with: .ns_purple), text: "")

    private let textLabel = Label(.boldUppercaseSmall, textColor: .ns_text)
    private let textContainer = UIView()
    private let stackView = UIStackView()

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
            stackView.isHidden = true
            textContainer.isHidden = true
            checkInButton.isHidden = false
            stopTitleTimer()

        case let .checkIn(checkIn):
            self.checkIn = checkIn
            stackView.isHidden = false
            textContainer.isHidden = false
            checkInButton.isHidden = true
            startTitleTimer()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(checkInButton)
        checkInButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.left.right.bottom.equalToSuperview()
        }

        addSubview(stackView)
        stackView.spacing = 1.5 * Padding.small
        stackView.axis = .vertical

        textContainer.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        stackView.addArrangedSubview(textContainer)
        stackView.addArrangedSubview(checkedInButton)

        stackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.left.right.equalTo(self.checkInButton)
        }

        textLabel.text = "homescreen_checkedin_label".ub_localized

        checkedInButton.snp.makeConstraints { make in
            make.height.equalTo(self.checkInButton)
        }
    }

    // MARK: - Title timer

    private func startTitleTimer() {
        titleTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.checkedInButton.title = strongSelf.checkIn?.timeSinceCheckIn() ?? ""
        })
        titleTimer?.fire()
    }

    private func stopTitleTimer() {
        titleTimer?.invalidate()
        titleTimer = nil
    }
}
