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

    private let checkedInButton = BigButton(style: .checkedIn, icon: UIImage(named: "icons-ic-qr"), text: "")

    private let textLabel = Label(.boldUppercaseSmall, textColor: .ns_text)

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
            checkInButton.isHidden = false
            checkedInButton.isHidden = true
            stopTitleTimer()

        case let .checkIn(checkIn):
            self.checkIn = checkIn
            checkedInButton.isHidden = false
            checkInButton.isHidden = true
            startTitleTimer()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(checkInButton)
        checkInButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }

        addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.checkInButton.snp.top).offset(-1.5 * Padding.small)
            make.left.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        textLabel.text = "homescreen_checkedin_label".ub_localized

        addSubview(checkedInButton)
        checkedInButton.snp.makeConstraints { make in
            make.edges.equalTo(self.checkInButton)
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
