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

class CurrentCheckinViewController: BaseSubViewController {
    private let contentView = StackScrollView()
    private let checkOutButton = BigButton(style: .normal, text: "checkout_button_title".ub_localized)
    private let venueView = VenueView(icon: true)
    private var timeLabel = Label(.timerUltraLarge, textAlignment: .center)

    public var checkIn: CheckIn? {
        didSet { update() }
    }

    public var time: String? {
        didSet { updateTime(time: time) }
    }

    public var userWillCheckOutCallback: (() -> Void)?

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        switch state.checkInState {
        case .noCheckIn:
            checkIn = nil
        case let .checkIn(checkIn):
            self.checkIn = checkIn
        }
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSpacerView(Padding.small)

        let isSmall = view.frame.size.width <= 375
        if isSmall {
            timeLabel = Label(.timerLarge, textAlignment: .center)
        }

        contentView.addArrangedView(timeLabel)

        contentView.addSpacerView(Padding.mediumSmall)

        let vView = UIView()
        vView.addSubview(venueView)
        venueView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Padding.medium, bottom: 0, right: Padding.medium))
        }

        contentView.addArrangedView(vView)

        contentView.addSpacerView(Padding.large + Padding.small)

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

        contentView.addSpacerView(Padding.large)

        contentView.scrollView.delegate = self
    }

    // MARK: - Present

    public func presentCheckOutScreen() {
        let vc = CheckinEditViewController()
<<<<<<< HEAD
        vc.userWillCheckOutCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.userWillCheckOutCallback?()
        }

        present(vc, animated: true, completion: nil)
=======
        present(CheckinEditViewController(), animated: true, completion: nil)
>>>>>>> adds basic appclip implementation
    }

    // MARK: - Update

    private func update() {
        venueView.venue = checkIn?.venue
    }

    private func updateTime(time: String?) {
        timeLabel.text = time
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CurrentCheckinViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        baseViewController?.scrollViewContentOffsetDelegate?.didUpdateContentOffset(s: scrollView.contentOffset)
    }
}
