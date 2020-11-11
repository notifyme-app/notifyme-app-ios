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
    private let venueView = VenueView(icon: false)
    private let reminderControl = ReminderControl()

    public var checkIn: CheckIn? {
        didSet { self.update() }
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupReminderControl()

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

    // MARK: - Reminder Control

    private func setupReminderControl() {
        reminderControl.changeCallback = { [weak self] option in
            guard let strongSelf = self else { return }

            if let checkIn = strongSelf.checkIn {
                ReminderManager.shared.scheduleReminder(for: checkIn.identifier, with: option)
            }
        }
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.backgroundColor = .ns_grayBackground

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

        let vView = UIView()
        vView.addSubview(venueView)
        venueView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Padding.medium, bottom: 0, right: Padding.medium))
        }

        contentView.addArrangedView(vView)

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

        contentView.addSpacerView(Padding.large)

        let reminderView = UIView()

        let reminderLabel = Label(.boldUppercaseSmall, textColor: .ns_text, textAlignment: .center)
        reminderLabel.text = "checkin_set_reminder".ub_localized
        reminderView.addSubview(reminderLabel)

        reminderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Padding.medium, bottom: 0, right: Padding.medium))
        }

        contentView.addArrangedView(reminderView)

        contentView.addSpacerView(Padding.medium - Padding.small)

        contentView.addArrangedView(reminderControl)

        contentView.addSpacerView(Padding.large)

        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        contentView.insertSubview(whiteView, at: 0)

        whiteView.snp.makeConstraints { make in
            make.bottom.equalTo(checkOutButton.snp.centerY)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-100.0)
        }

        whiteView.layer.cornerRadius = 36.0
        whiteView.ub_addShadow(radius: 20.0, opacity: 0.17, xOffset: 0, yOffset: 2.0)
        contentView.clipsToBounds = true

        contentView.scrollView.delegate = self
    }

    // MARK: - Present

    public func presentCheckOutScreen() {
        present(CheckinEditViewController(), animated: true, completion: nil)
    }

    // MARK: - Update

    private func update() {
        venueView.venue = checkIn?.venue
        reminderControl.setOption(ReminderManager.shared.currentReminder)
    }
}

extension CurrentCheckinViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        baseViewController?.scrollViewContentOffsetDelegate?.didUpdateContentOffset(s: scrollView.contentOffset)
    }
}
