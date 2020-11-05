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

class CheckinEditViewController: BaseViewController {
    private let checkOutButton = BigButton(style: .normal, text: "checkout_button_title".ub_localized)

    public let dismissButton = TextButton(text: "done_button".ub_localized)
    public let contentView = StackScrollView()

    private let checkinLabel = Label(.boldUppercaseSmall, textColor: .ns_text, textAlignment: .center)
    private let venueView = VenueView(icon: false)
    private let startDateLabel = Label(.textBold, textAlignment: .center)

    private let fromTimePickerControl = TimePickerControl(text: "datepicker_from".ub_localized)
    private let toTimePickerControl = TimePickerControl(text: "datepicker_to".ub_localized)
    private let addCommentControl = AddCommentControl()

    private let removeFromDiaryButton = BigButton(style: .small, text: "remove_from_diary_button".ub_localized)

    private let isCurrentCheckin: Bool

    private var checkIn: CheckIn? {
        didSet { update() }
    }

    // MARK: - Init

    init(checkIn _: CheckIn? = nil) {
        isCurrentCheckin = false
        super.init()
    }

    override init() {
        isCurrentCheckin = true
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.update(state)
        }

        setupCheckout()
        setupTimeInteraction()
        setupComment()
    }

    // MARK: - Update

    private func update(_ state: UIStateModel) {
        if isCurrentCheckin {
            switch state.checkInState {
            case .noCheckIn:
                break
            case let .checkIn(checkIn):
                self.checkIn = checkIn
            }
        }
    }

    private func update() {
        venueView.venue = checkIn?.venue

        if let date = checkIn?.checkInTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"

            var dates: [String] = []
            dates.append(formatter.string(from: date))

            if let checkoutTime = checkIn?.checkOutTime {
                let calendar = NSCalendar.current
                var dayComponent = DateComponents()
                dayComponent.day = 1
                let start = calendar.startOfDay(for: date)
                if let nextDate = calendar.date(byAdding: dayComponent, to: start),
                   nextDate < checkoutTime {
                    dates.append(formatter.string(from: checkoutTime))
                }
            }

            startDateLabel.text = dates.joined(separator: " – ")

            let checkOutTime = checkIn?.checkOutTime ?? Date()

            fromTimePickerControl.setDate(currentStart: date, currentEnd: checkOutTime, isStart: true)
            toTimePickerControl.setDate(currentStart: date, currentEnd: checkOutTime, isStart: false)
        }
    }

    // MARK: - Setup

    private func setupCheckout() {
        dismissButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.checkOut()

                let presentingVC = strongSelf.presentingViewController
                strongSelf.dismiss(animated: true) {
                    if let nvc = presentingVC as? UINavigationController {
                        nvc.popToRootViewController(animated: true)
                    } else {
                        presentingVC?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } else {
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }

        removeFromDiaryButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(RemoveFromDiaryWarningViewController(), animated: true, completion: nil)
        }
    }

    private func setupTimeInteraction() {
        fromTimePickerControl.timeChangedCallback = { [weak self] date in
            guard let strongSelf = self else { return }
            strongSelf.checkIn?.checkInTime = date

            if let checkoutTime = strongSelf.checkIn?.checkOutTime {
                let calendar = NSCalendar.current
                var dayComponent = DateComponents()
                dayComponent.day = 1

                if let nextDate = calendar.date(byAdding: dayComponent, to: date),
                   nextDate < checkoutTime {
                    var minusDateComponent = DateComponents()
                    minusDateComponent.day = -1
                    strongSelf.checkIn?.checkOutTime = calendar.date(byAdding: minusDateComponent, to: checkoutTime)
                }
            }

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.currentCheckin = strongSelf.checkIn
            }
        }

        toTimePickerControl.timeChangedCallback = { [weak self] date in
            guard let strongSelf = self else { return }
            strongSelf.checkIn?.checkOutTime = date

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.currentCheckin = strongSelf.checkIn
            }
        }
    }

    private func setupComment() {
        addCommentControl.commentChangedCallback = { [weak self] comment in
            guard let strongSelf = self else { return }

            strongSelf.checkIn?.comment = comment

            if strongSelf.isCurrentCheckin {
                CurrentCheckinManager.shared.currentCheckin = strongSelf.checkIn
            }
        }
    }

    // MARK: - Setup

    private func setup() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }

        contentView.scrollView.ub_enableDefaultKeyboardObserver()

        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Padding.large + Padding.small)
            make.left.right.equalToSuperview().inset(Padding.large)
        }

        view.addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Padding.small)
            make.right.equalToSuperview().inset(Padding.mediumSmall)
        }

        contentView.addArrangedView(checkinLabel)
        checkinLabel.text = "edit_controller_your_checkin".ub_localized

        contentView.addSpacerView(Padding.mediumSmall)

        contentView.addArrangedView(venueView)

        contentView.addSpacerView(Padding.mediumSmall)

        contentView.addArrangedView(startDateLabel)

        contentView.addSpacerView(Padding.mediumSmall)

        let stackView = UIStackView(arrangedSubviews: [fromTimePickerControl, toTimePickerControl])
        stackView.axis = .vertical
        stackView.spacing = Padding.mediumSmall
        stackView.distribution = .fillEqually

        contentView.addArrangedView(stackView)

        contentView.addSpacerView(Padding.mediumSmall)
        contentView.addArrangedView(addCommentControl)

        let diaryLabel = Label(.boldUppercaseSmall, textColor: .ns_text)
        diaryLabel.text = "diary_option_title".ub_localized

        contentView.addSpacerView(Padding.mediumSmall)

        if !isCurrentCheckin {
            let v = UIView()
            v.addSubview(removeFromDiaryButton)

            removeFromDiaryButton.snp.makeConstraints { make in
                make.top.bottom.centerX.equalToSuperview()
                make.left.right.lessThanOrEqualToSuperview()
            }

            contentView.addArrangedView(v)
        }

        contentView.addSpacerView(Padding.mediumSmall)
    }
}