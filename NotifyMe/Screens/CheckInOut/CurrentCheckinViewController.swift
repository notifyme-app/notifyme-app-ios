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
    private let reminderControl = ReminderControl()
    private var timeLabel = Label(.timerUltraLarge, textAlignment: .center)

    public var checkIn: CheckIn? {
        didSet { update() }
    }

    public var time: String? {
        didSet { self.updateTime(time: time) }
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
            strongSelf.scheduleReminder(option: option)
        }
    }

    private func scheduleReminder(option: ReminderOption) {
        if let checkIn = self.checkIn {
            ReminderManager.shared.scheduleReminder(for: checkIn.identifier, with: option, didFailCallback: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.handleReminderError()
            })
        }
    }

    private func handleReminderError() {
        reminderControl.setOption(ReminderOption.off)

        let alertController = UIAlertController(title: "checkin_reminder_settings_alert_title".ub_localized, message: "checkin_reminder_settings_alert_message".ub_localized, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "checkin_reminder_option_open_settings".ub_localized, style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.openAppSettings()
        }))

        alertController.addAction(UIAlertAction(title: "cancel".ub_localized, style: .cancel, handler: { _ in }))

        present(alertController, animated: true, completion: nil)
    }

    private func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
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

        let reminderView = UIView()

        let reminderLabel = Label(.boldUppercaseSmall, textColor: .ns_purple, textAlignment: .center)
        reminderLabel.text = "checkin_set_reminder".ub_localized
        reminderView.addSubview(reminderLabel)

        reminderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: Padding.medium, bottom: 0, right: Padding.medium))
        }

        contentView.addArrangedView(reminderView)

        contentView.addSpacerView(Padding.medium - Padding.small)

        contentView.addArrangedView(reminderControl)

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
        present(CheckinEditViewController(), animated: true, completion: nil)
    }

    // MARK: - Update

    private func update() {
        venueView.venue = checkIn?.venue
        reminderControl.setOption(ReminderManager.shared.currentReminder)
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
